# recieves data from client, normalizes it, writes it to postgre 

from writer import writer as W
import yaml
import grpc
from concurrent import futures
import sys
# sys.path.append(r'D:\TRRP\lab3')
import build_orders_pb2
import build_orders_pb2_grpc
import analysis

# CONFIG_PATH = r'D:\TRRP\lab3\server\config.yaml' # 'config.yaml'
CONFIG_PATH = r'config.yaml'

class BuildOrderService(build_orders_pb2_grpc.BuildOrderServiceServicer):
    def __init__(self):
        with open(CONFIG_PATH, 'r', encoding='utf8') as file:
            self.params = yaml.safe_load(file)
        self.w = W(self.params)

    def SendOrders(self, request_iterator, context):
        orders = []
        for request in request_iterator:
            print(f"📥 Получен заказ ID {request.id_order}")
            data = [
                request.id_order, request.address, request.work_stages,
                request.work_prices, request.materials,
                request.material_quantities, request.material_prices
            ]
            orders.append(data)

        self.w.write(orders)
        analysis.run_js_analysis(orders)

        return build_orders_pb2.StatusResponse(status="OK")

def serve():
    with open(CONFIG_PATH, 'r', encoding='utf8') as file:
    # with open(r'D:\TRRP\lab2\server\config.yaml', 'r', encoding='utf8') as file:
            params = yaml.safe_load(file)

    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))

    build_orders_pb2_grpc.add_BuildOrderServiceServicer_to_server(
        BuildOrderService(), server
    )

    # Настройка TLS
    with open(params['certs_path'] + params['server_key'], 'rb') as f:
        private_key = f.read()
    with open(params['certs_path'] + params['server_cert'], 'rb') as f:
        certificate_chain = f.read()
    with open(params['certs_path'] + params['ca_cert'], 'rb') as f:
        root_certificates = f.read()

    credentials = grpc.ssl_server_credentials([
        (private_key, certificate_chain)
    ], root_certificates=root_certificates, require_client_auth=True)

    print('gonna bind to' + params['server_ip'] + ':' + str(params['server_port']))

    server.add_secure_port(params['server_ip'] + ':' + str(params['server_port']), credentials)#'[::]:50051', credentials)
    print("✅ gRPC сервер запущен с TLS на " + params['server_ip'] + ':' + str(params['server_port']))
    server.start()
    server.wait_for_termination()

serve()
-- DROP DATABASE IF EXISTS constructioncompany;
-- CREATE DATABASE constructioncompany;

DROP TABLE IF EXISTS Orders_WorkStages;
DROP TABLE IF EXISTS WorkStages_Materials;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS WorkStages;
DROP TABLE IF EXISTS Materials;

-- Таблица заказов
CREATE TABLE Orders (
    id_order SERIAL PRIMARY KEY,
    address TEXT NOT NULL
);

-- Таблица этапов работ
CREATE TABLE WorkStages (
    id_stage SERIAL PRIMARY KEY,
    stage_name TEXT UNIQUE NOT NULL,
    price NUMERIC NOT NULL CHECK (price >= 0)
);

-- Таблица материалов
CREATE TABLE Materials (
    id_material SERIAL PRIMARY KEY,
    material_name TEXT UNIQUE NOT NULL,
    price NUMERIC NOT NULL CHECK (price >= 0) -- Добавили цену
);

-- Таблица связи Заказы <-> Этапы работ (1:M)
CREATE TABLE Orders_WorkStages (
    id_order INT REFERENCES Orders(id_order) ON DELETE CASCADE,
    id_stage INT REFERENCES WorkStages(id_stage) ON DELETE CASCADE,
    PRIMARY KEY (id_order, id_stage)
);

-- Таблица связи Этапы работ <-> Материалы (M:M)
CREATE TABLE WorkStages_Materials (
    id_stage INT REFERENCES WorkStages(id_stage) ON DELETE CASCADE,
    id_material INT REFERENCES Materials(id_material) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (id_stage, id_material)
);





ALTER TABLE WorkStages ADD CONSTRAINT unique_stage_name UNIQUE (stage_name);
ALTER TABLE Materials ADD CONSTRAINT unique_material_name UNIQUE (material_name);



-- ==========================================
-- GAMEVAULT VERİTABANI PROJESİ
-- Öğrenci: Merve ATİŞ
-- Tarih: 18 Aralık 2024
-- ==========================================

-- ==========================================
-- BÖLÜM 1: VERİTABANI VE TABLO OLUŞTURMA
-- ==========================================

CREATE TABLE "developers"(
    "id" SERIAL PRIMARY KEY NOT NULL,
    "company_name" VARCHAR(255) NOT NULL,
    "country" VARCHAR(255) NOT NULL,
    "founded_year" DATE NOT NULL
);
---Düzeltme: founded_year sütunun tipi INTEGER olarak değiştirildi.
ALTER TABLE developers
DROP COLUMN founded_year;

ALTER TABLE developers
ADD COLUMN founded_year INTEGER;

SELECT * FROM developers;

CREATE TABLE "games"(
    "id" SERIAL PRIMARY KEY NOT NULL,
	"title" VARCHAR(255) NOT NULL,
	"price" DECIMAL(10, 2) NOT NULL,
	"release_date" YEAR NOT NULL,
	"rating" DECIMAL (3,1) NOT NULL,
	"developer_id" INTEGER NOT NULL,
	FOREIGN KEY (developer_id) REFERENCES developers(id)
);

CREATE TABLE "genres"(
    "id" SERIAL PRIMARY KEY NOT NULL,
	"name" VARCHAR(255) NOT NULL,
	"description" VARCHAR(255) NOT NULL
);

CREATE TABLE "games_genres" (
   "id" SERIAL PRIMARY KEY NOT NULL,
   "game_id" INTEGER NOT NULL,
   "genre_id" INTEGER NOT NULL,
   FOREIGN KEY (game_id) REFERENCES games(id),
   FOREIGN KEY (genre_id) REFERENCES genres(id)
);

-- ==========================================
-- BÖLÜM 2: VERİ EKLEME
-- ==========================================

-- DEVELOPERS --

INSERT INTO developers (company_name, country, founded_year) VALUES
    ('CD Projekt Red', 'Poland', 1994),
    ('Rockstar Games', 'USA', 1998),
    ('FromSoftware', 'Japan', 1986),
    ('Valve Corporation', 'USA', 1996),
    ('Bethesda Game Studios', 'USA', 1986);

-- GAMES --	

-- Developer ID'leri:
-- 1 = CD Projekt Red
-- 2 = Rockstar Games
-- 3 = FromSoftware
-- 4 = Valve Corporation
-- 5 = Bethesda Game Studios

INSERT INTO games(title, price, release_date, rating, developer_id) VALUES
       ('Elden Ring', 899.00, '2022-02-25', 9.0, 3),
	   ('Artifact', 180.00, '2018-11-28', 6.0, 4),
	   ('Team Fortress 2', 0.00, '2007-10-10', 9.0, 4),
	   ('Max Payne 3', 249.00, '2012-05-15', 9.0, 2),
       ('Midnight Club 2', 149.00, '2003-04-28', 8.5, 2),
       ('Grand Theft Auto V', 449.00, '2013-09-17', 9.0, 2),
       ('The Witcher 3: Wild Hunt', 599.00, '2015-05-19', 7.0, 1),
       ('Cyberpunk 2077', 699.00, '2020-12-10', 9.0, 1),
	   ('Fallout 76', 250.00, '2018-11-14', 7.0, 5),
	   ('Fallout 4', 349.00, '2015-11-10', 9.0, 5);

SELECT* FROM games;

-- GENRES --

INSERT INTO genres(name, description) VALUES
      ('RPG', 'Role-playing games with character development'),
      ('Action', 'Fast-paced combat-focused games'),
      ('FPS', 'First-person shooter games'),
      ('Racing', 'Car racing and driving games'),
      ('Card Game', 'Digital collectible card games');
	   
SELECT id, name FROM genres;


-- GAMES_GENRES --

-- Genre ID'leri:
-- 1 = RPG
-- 2 = Action
-- 3 = FPS
-- 4 = Racing
-- 5 = Card Game

INSERT INTO games_genres(game_id, genre_id) VALUES
       (1,1) ,(1,2) ,(2,5) ,(3,3) ,(3,2) ,(7,1) ,
       (8,1) ,(8,2) ,(8,3) ,(4,2) ,(4,3) ,(5,4) ,
       (6,2) ,(6,3) ,(9,1) ,(9,2) ,(9,3) ,(10,1) ,
       (10,2) ,(7,2) ,(10,3) ;


select * from games_genres;
-- ==========================================
-- Bölüm 3: Güncelleme ve Silme (UPDATE / DELETE)
-- ==========================================

-- Tüm oyunların fiyatını %10 düşüren bir güncelleme sorgusu yazın.

UPDATE games 
SET price = price * 0.9;

SELECT price FROM games;

-- Bir oyunun puanını (rating) güncelleyin (Örn: 8.5'i 9.0 yapın).

UPDATE games 
SET rating = 7.5 where id= 2;

--Veritabanından bir oyun tamamen silindi. 
--Önce ara tablodaki ilişkiler silinir
DELETE FROM games_genres
WHERE game_id =3;

DELETE FROM games
WHERE id= 3;

-- ==========================================
-- Bölüm 4: Raporlama (SELECT & JOIN)
-- ==========================================

-- Oyunun adı, Fiyatı ve Geliştirici Firmanın Adını yan yana getirildi.

SELECT g.title, g.price, d.company_name FROM games g
INNER JOIN developers d on g.developer_id = d.id;

-- Sadece "RPG" türündeki oyunların adı ve puanı listelendi.

SELECT gm.title as game, gm.rating FROM games gm
JOIN games_genres gg on gm.id = gg.game_id
JOIN genres gn on gg.genre_id = gn.id
WHERE gn.name = 'RPG';

-- Fiyatı 500 TL üzerinde olan oyunlar pahalıdan ucuza doğru sıralandı.

SELECT title FROM games
WHERE price > 500
ORDER BY price DESC;

-- İçinde "War" kelimesi geçen oyunları bulun 

SELECT title FROM games
WHERE title LIKE  '%War%';


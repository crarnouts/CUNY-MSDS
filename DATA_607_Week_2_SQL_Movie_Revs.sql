-- -----------------------------------------
-- CUNY MSDS DATA 607 -- 
-- SQL WEEK 2 assignment: SQL and R

-- -----------------------------------------

CREATE SCHEMA sql_r;

CREATE TABLE tbl_movie_reviews
(movie_id INT(3) NOT NULL,
movie_title VARCHAR(128) NOT NULL,
rev_rating_1 INT(1),
rev_rating_2 INT(1),
rev_rating_3 INT(1),
rev_rating_4 INT(1),
rev_rating_5 INT(1)
);

-- populate table

INSERT INTO tbl_movie_reviews VALUES (1,'Black Panther',4,3,4,5,4);
INSERT INTO tbl_movie_reviews VALUES (2,'Avengers: Infinity War',5,4,4,5,4);
INSERT INTO tbl_movie_reviews VALUES (3,'Han Solo: A Star Wars Movie',3,4,2,3,3);
INSERT INTO tbl_movie_reviews VALUES (4,'Mission Impossible: Fallout',5,5,5,5,5);
INSERT INTO tbl_movie_reviews VALUES (5,'Incredibles',3,3,4,4,4);

select *
from tbl_movie_reviews;

-- drop table tbl_movie_reviews;

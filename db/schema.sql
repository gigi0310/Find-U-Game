CREATE DATABASE gametracker;
\c gametracker

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    user_name TEXT,
    email TEXT,
    password_digest TEXT
);

CREATE TABLE games (
    id SERIAL PRIMARY KEY,
    users_id SERIAL,
    title TEXT,
    year NUMERIC,
    description TEXT,
    rating NUMERIC,
    category TEXT
);

-- CREATE TABLE category (
--     id SERIAL PRIMARY KEY,
--     users_id SERIAL,
--     games_id SERIAL,
--     description TEXT
-- );

CREATE DATABASE eventsdb;

USE eventsdb;

CREATE TABLE events (
    id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    date VARCHAR(255) NOT NULL,
    time VARCHAR(255) NOT NULL
);

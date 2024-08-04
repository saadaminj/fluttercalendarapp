CREATE DATABASE eventsdb;

USE eventsdb;

CREATE TABLE events (
    id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    date VARCHAR(255) NOT NULL,
    time VARCHAR(255) NOT NULL
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- to go to mysql shell
-- mysql -u root -p
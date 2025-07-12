CREATE DATABASE IF NOT EXISTS transitdb;

USE transitdb;
SELECT DATABASE();

CREATE TABLE Trains (
  id INT PRIMARY KEY
);

CREATE TABLE Stations (
  id INT PRIMARY KEY,
  station_name VARCHAR(50),
  city VARCHAR(50),
  state VARCHAR(50)
);

CREATE TABLE TrainSchedules (
  transit_line_name VARCHAR(50) PRIMARY KEY,
  train_id INT,
  origin_station_id INT,
  destination_station_id INT,
  num_stops INT,
  departure_datetime DATETIME,
  arrival_datetime DATETIME,
  travel_time INT,
  fixed_fare FLOAT,
  fare_per_stop FLOAT,
  line_type VARCHAR(50),
  discount_type VARCHAR(50),
  discount_percentage FLOAT,
  FOREIGN KEY (train_id) REFERENCES Trains(id),
  FOREIGN KEY (origin_station_id) REFERENCES Stations(id),
  FOREIGN KEY (destination_station_id) REFERENCES Stations(id)
);

CREATE TABLE Customers (
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(50),
  username VARCHAR(50) PRIMARY KEY,
  customer_password VARCHAR(50)
);

CREATE TABLE Employees (
  ssn VARCHAR(11) PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  username VARCHAR(50) UNIQUE,
  employee_password VARCHAR(50)
);

CREATE TABLE Reservations (
  reservation_number INT PRIMARY KEY,
  customer_id VARCHAR(50),
  origin_station_id INT,
  destination_station_id INT,
  transit_line_name VARCHAR(50),
  departure_datetime DATETIME,
  arrival_datetime DATETIME,
  reservation_date DATE,
  total_fare DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES Customers(username),
  FOREIGN KEY (origin_station_id) REFERENCES Stations(id),
  FOREIGN KEY (destination_station_id) REFERENCES Stations(id),
  FOREIGN KEY (transit_line_name) REFERENCES TrainSchedules(transit_line_name)
);

CREATE TABLE Stops_At (
  id INT,
  transit_line_name VARCHAR(50),
  departure_datetime DATETIME,
  arrival_datetime DATETIME,
  PRIMARY KEY (id, transit_line_name),
  FOREIGN KEY (id) REFERENCES Stations(id),
  FOREIGN KEY (transit_line_name) REFERENCES TrainSchedules(transit_line_name)
);


SHOW TABLES;

-- Connect to PostgreSQL and create the salon database
CREATE DATABASE salon;

-- Connect to the salon database
\c salon

-- Create customers table
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  phone VARCHAR UNIQUE NOT NULL
);

-- Create services table
CREATE TABLE services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL
);

-- Create appointments table
CREATE TABLE appointments (
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(customer_id),
  service_id INT REFERENCES services(service_id),
  time VARCHAR NOT NULL
);

-- Insert sample services
INSERT INTO services (name) VALUES 
  ('Cut'), 
  ('Color'), 
  ('Style');

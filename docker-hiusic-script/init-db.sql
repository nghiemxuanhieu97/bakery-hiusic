-- Create databases for Hiusic microservices
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'auth-hiusic-service')
BEGIN
    CREATE DATABASE [auth-hiusic-service];
END
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'product-hiusic-service')
BEGIN
    CREATE DATABASE [product-hiusic-service];
END
GO

-- Switch to auth-hiusic-service database and create basic structure if needed
USE [auth-hiusic-service];
GO

-- Switch to product-hiusic-service database and create basic structure if needed
USE [product-hiusic-service];
GO

PRINT 'Databases created successfully!'

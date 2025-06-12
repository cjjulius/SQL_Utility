/*

Creates a Deadlock for testing purposes

Instructions:
	1. Create three connections to an instance. 
	2. Copy/past the code into all three instances. 
	3. Execute the code in the order given.

*/

--Connection 1
--Two global temp tables with sample data for demo purposes.


--	[1] Run everything in Connection 1

CREATE TABLE ##Employees (
    EmpId INT IDENTITY,
    EmpName VARCHAR(16),
    Phone VARCHAR(16)
)
GO

INSERT INTO ##Employees (EmpName, Phone)
VALUES ('Martha', '800-555-1212'), ('Jimmy', '619-555-8080')
GO

CREATE TABLE ##Suppliers(
    SupplierId INT IDENTITY,
    SupplierName VARCHAR(64),
    Fax VARCHAR(16)
)
GO

INSERT INTO ##Suppliers (SupplierName, Fax)
VALUES ('Acme', '877-555-6060'), ('Rockwell', '800-257-1234')
GO



--Connection 2
--Update Suppliers, then Employees

BEGIN TRAN;				-- [2] Open the transaction but do nothing

UPDATE ##Suppliers		--
SET Fax = N'555-1212'	-- [4] Update Suppliers but do not commit.
WHERE supplierid = 1	--



UPDATE ##Employees		--
SET phone = N'555-9999'	-- [6] Update Employees but do not commit.
WHERE empid = 1			--

ROLLBACK TRAN;			--[10] Roll back will fail


--Connection 3
--Update Employees, and then Suppliers

BEGIN TRAN;				-- [3] Open the transaction but do nothing


UPDATE ##Employees		--
SET phone = N'555-9999'	-- [5] Update Employees but do not commit.
WHERE empid = 1			--


UPDATE ##Suppliers		--
SET Fax = N'555-1212'	-- [7] Update Suppliers but do not commit.
WHERE supplierid = 1	--


ROLLBACK TRAN;			--[11] Rollback will succeed.


--[9] Deadlock should occur and the Connection 3 transaction will most likely be killed
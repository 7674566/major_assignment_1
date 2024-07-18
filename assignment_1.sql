 Drop the Employee_Hierarchy table if it exists
DROP TABLE IF EXISTS Employee_Hierarchy;

-- Create the Employee_Hierarchy table
CREATE TABLE Employee_Hierarchy (
    EMPLOYEEID VARCHAR(20),
    REPORTINGTO TEXT,
    EMAILID TEXT,
    LEVEL INT,
    FIRSTNAME TEXT,
    LASTNAME TEXT
);

-- Sample data insertion
DROP TABLE IF EXISTS EMPLOYEE_MASTER;

CREATE TABLE EMPLOYEE_MASTER (
    EMPLOYEEID VARCHAR(20),
    REPORTINGTO TEXT,
    EMAILID TEXT
);

INSERT INTO EMPLOYEE_MASTER (EMPLOYEEID, REPORTINGTO, EMAILID) VALUES
('H1', NULL, 'john.doe@example.com'),
('H2', NULL, 'jane.smith@example.com'),
('H3', 'H1', 'alice.jones@example.com'),
('H4', 'H1', 'bob.white@example.com'),
('H5', 'H3', 'charlie.brown@example.com'),
('H6', 'H3', 'david.green@example.com'),
('H7', 'H4', 'emily.gray@example.com'),
('H8', 'H4', 'frank.wilson@example.com'),
('H9', 'H5', 'george.harris@example.com'),
('H10', 'H5', 'hannah.taylor@example.com'),
('H11', 'H6', 'irene.martin@example.com'),
('H12', 'H6', 'jack.roberts@example.com'),
('H13', 'H7', 'kate.evans@example.com'),
('H14', 'H7', 'laura.hall@example.com'),
('H15', 'H8', 'mike.anderson@example.com'),
('H16', 'H8', 'natalie.clark@example.com'),
('H17', 'H9', 'oliver.davis@example.com'),
('H18', 'H9', 'peter.edwards@example.com'),
('H19', 'H10', 'quinn.fisher@example.com'),
('H20', 'H10', 'rachel.garcia@example.com'),
('H21', 'H11', 'sarah.hernandez@example.com'),
('H22', 'H11', 'thomas.lee@example.com'),
('H23', 'H12', 'ursula.lopez@example.com'),
('H24', 'H12', 'victor.martinez@example.com'),
('H25', 'H13', 'william.nguyen@example.com'),
('H26', 'H13', 'xavier.ortiz@example.com'),
('H27', 'H14', 'yvonne.perez@example.com'),
('H28', 'H14', 'zoe.quinn@example.com'),
('H29', 'H15', 'adam.robinson@example.com'),
('H30', 'H15', 'barbara.smith@example.com');

-- Recursive CTE to generate the hierarchy
WITH RECURSIVE HierarchyCTE AS (
    -- Anchor member: Employees who do not report to anyone (ReportingTo is NULL)
    SELECT 
        EMPLOYEEID,
        REPORTINGTO,
        EMAILID,
        0 AS LEVEL -- Root level
    FROM 
        EMPLOYEE_MASTER
    WHERE 
        REPORTINGTO IS NULL

    UNION ALL

    -- Recursive member: Employees who report to someone
    SELECT 
        e.EMPLOYEEID,
        e.REPORTINGTO,
        e.EMAILID,
        h.LEVEL + 1 AS LEVEL
    FROM 
        EMPLOYEE_MASTER e
    INNER JOIN 
        HierarchyCTE h ON e.REPORTINGTO = h.EMPLOYEEID
)

-- Insert the hierarchical data into Employee_Hierarchy table
INSERT INTO Employee_Hierarchy (EMPLOYEEID, REPORTINGTO, EMAILID, LEVEL, FIRSTNAME, LASTNAME)
SELECT 
    EMPLOYEEID,
    REPORTINGTO,
    EMAILID,
    LEVEL,
    SUBSTR(EMAILID, 1, INSTR(EMAILID, '.') - 1) AS FIRSTNAME,
    SUBSTR(
        SUBSTR(EMAILID, INSTR(EMAILID, '.') + 1), 
        1, 
        INSTR(SUBSTR(EMAILID, INSTR(EMAILID, '.') + 1), '@') - 1
    ) AS LASTNAME
FROM 
    HierarchyCTE;
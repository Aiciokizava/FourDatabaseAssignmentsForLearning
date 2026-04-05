WITH RECURSIVE
    subordinates AS(
    SELECT
        EmployeeID AS ManagerRoot,
        EmployeeID,
        ManagerID
    FROM
        Employees
    WHERE
        RoleID = 1
    UNION ALL
SELECT
    s.ManagerRoot,
    e.EmployeeID,
    e.ManagerID
FROM
    Employees e
JOIN subordinates s ON
    e.ManagerID = s.EmployeeID
WHERE
    e.EmployeeID != s.ManagerRoot
),
total_sub AS(
    SELECT
        ManagerRoot,
        COUNT(*) AS TotalSubordinates
    FROM
        subordinates
    WHERE
        EmployeeID != ManagerRoot
    GROUP BY
        ManagerRoot
)
SELECT
    e.EmployeeID,
    e.Name AS EmployeeName,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName,
    GROUP_CONCAT(
        DISTINCT p.ProjectName
    ORDER BY
        p.ProjectName SEPARATOR ', '
    ) AS ProjectNames,
    GROUP_CONCAT(
        DISTINCT t.TaskName
    ORDER BY
        t.TaskName SEPARATOR ', '
    ) AS TaskNames,
    ts.TotalSubordinates
FROM
    Employees e
JOIN Departments d ON
    e.DepartmentID = d.DepartmentID
JOIN Roles r ON
    e.RoleID = r.RoleID
JOIN total_sub ts ON
    e.EmployeeID = ts.ManagerRoot
LEFT JOIN Projects p ON
    e.DepartmentID = p.DepartmentID
LEFT JOIN Tasks t ON
    e.EmployeeID = t.AssignedTo
WHERE
    ts.TotalSubordinates > 0
GROUP BY
    e.EmployeeID,
    e.Name,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName,
    ts.TotalSubordinates
ORDER BY
    e.Name;
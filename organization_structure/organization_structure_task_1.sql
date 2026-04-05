WITH RECURSIVE
    subordinates AS(
    SELECT
        EmployeeID,
        NAME,
        ManagerID,
        DepartmentID,
        RoleID
    FROM
        Employees
    WHERE
        EmployeeID = 1
    UNION ALL
SELECT
    e.EmployeeID,
    e.Name,
    e.ManagerID,
    e.DepartmentID,
    e.RoleID
FROM
    Employees e
JOIN subordinates s ON
    e.ManagerID = s.EmployeeID
)
SELECT
    s.EmployeeID,
    s.Name AS EmployeeName,
    s.ManagerID,
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
    ) AS TaskNames
FROM
    subordinates s
JOIN Departments d ON
    s.DepartmentID = d.DepartmentID
JOIN Roles r ON
    s.RoleID = r.RoleID
LEFT JOIN Projects p ON
    s.DepartmentID = p.DepartmentID
LEFT JOIN Tasks t ON
    s.EmployeeID = t.AssignedTo
GROUP BY
    s.EmployeeID,
    s.Name,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName
ORDER BY
    s.Name;
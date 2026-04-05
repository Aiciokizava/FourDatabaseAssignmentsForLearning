SELECT
    c.name AS car_name,
    c.class AS car_class,
    AVG(r.position) AS average_position,
    COUNT(r.race) AS race_count,
    cl.country AS car_country
FROM
    Cars c
JOIN Results r ON
    c.name = r.car
JOIN Classes cl ON
    c.class = cl.class
GROUP BY
    c.name,
    c.class,
    cl.country
HAVING
    AVG(r.position) <(
    SELECT
        AVG(r2.position)
    FROM
        Cars c2
    JOIN Results r2 ON
        c2.name = r2.car
    WHERE
        c2.class = c.class
) AND(
    SELECT
        COUNT(DISTINCT c3.name)
    FROM
        Cars c3
    JOIN Results r3 ON
        c3.name = r3.car
    WHERE
        c3.class = c.class
) >= 2
ORDER BY
    car_class ASC,
    average_position ASC;
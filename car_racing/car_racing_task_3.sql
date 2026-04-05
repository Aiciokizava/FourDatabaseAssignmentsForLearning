SELECT
    c.name AS car_name,
    c.class AS car_class,
    AVG(r.position) AS average_position,
    COUNT(r.race) AS race_count,
    cl.country AS car_country,
    (
    SELECT
        COUNT(r3.race)
    FROM
        Cars c3
    JOIN Results r3 ON
        c3.name = r3.car
    WHERE
        c3.class = c.class
) AS total_races
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
    c.class IN(
    SELECT
        class_avg.car_class
    FROM
        (
        SELECT
            c2.class AS car_class,
            AVG(r2.position) AS avg_pos
        FROM
            Cars c2
        JOIN Results r2 ON
            c2.name = r2.car
        GROUP BY
            c2.class
    ) AS class_avg
WHERE
    class_avg.avg_pos =(
    SELECT
        MIN(avg_pos2)
    FROM
        (
        SELECT
            AVG(r3.position) AS avg_pos2
        FROM
            Cars c3
        JOIN Results r3 ON
            c3.name = r3.car
        GROUP BY
            c3.class
    ) AS min_avg
)
)
ORDER BY
    average_position;
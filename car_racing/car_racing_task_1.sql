SELECT
    ca.car_name,
    ca.car_class,
    ca.average_position,
    ca.race_count
FROM
    (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM
        Cars c
    JOIN Results r ON
        c.name = r.car
    GROUP BY
        c.name,
        c.class
) ca
WHERE
    ca.average_position =(
    SELECT
        MIN(avg_pos)
    FROM
        (
        SELECT
            c2.name,
            c2.class,
            AVG(r2.position) AS avg_pos
        FROM
            Cars c2
        JOIN Results r2 ON
            c2.name = r2.car
        GROUP BY
            c2.name,
            c2.class
    ) class_avgs
WHERE
    class_avgs.class = ca.car_class
)
ORDER BY
    ca.average_position,
    ca.car_name;
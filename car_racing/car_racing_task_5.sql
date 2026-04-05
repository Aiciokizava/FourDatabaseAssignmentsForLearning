WITH
    car_avg AS(
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
),
low_pos_count AS(
    SELECT
        car_class,
        COUNT(*) AS low_position_count
    FROM
        car_avg
    WHERE
        average_position >= 3.0
    GROUP BY
        car_class
),
low_pos_cars AS(
    SELECT
        *
    FROM
        car_avg
    WHERE
        average_position > 3.0
),
total_races_per_class AS(
    SELECT
        c.class AS car_class,
        COUNT(r.race) AS total_races
    FROM
        Cars c
    JOIN Results r ON
        c.name = r.car
    GROUP BY
        c.class
)
SELECT
    lc.car_name,
    lc.car_class,
    lc.average_position,
    lc.race_count,
    cl.country AS car_country,
    tr.total_races,
    lpc.low_position_count
FROM
    low_pos_cars lc
JOIN low_pos_count lpc ON
    lc.car_class = lpc.car_class
JOIN Classes cl ON
    lc.car_class = cl.class
JOIN total_races_per_class tr ON
    lc.car_class = tr.car_class
ORDER BY
    lpc.low_position_count
DESC
    ,
    lc.car_class ASC,
    lc.average_position
DESC
    ;
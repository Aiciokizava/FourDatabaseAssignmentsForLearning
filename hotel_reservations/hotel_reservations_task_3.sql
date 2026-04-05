WITH
    hotel_category AS(
    SELECT
        h.ID_hotel,
        h.name,
        CASE WHEN AVG(r.price) < 175 THEN 'Дешевый' WHEN AVG(r.price) <= 300 THEN 'Средний' ELSE 'Дорогой'
END AS category
FROM
    Hotel h
JOIN Room r ON
    h.ID_hotel = r.ID_hotel
GROUP BY
    h.ID_hotel,
    h.name
),
customer_hotels AS(
    SELECT DISTINCT
        c.ID_customer,
        c.name,
        h.ID_hotel,
        hc.category,
        h.name AS hotel_name
    FROM
        Customer c
    JOIN Booking b ON
        c.ID_customer = b.ID_customer
    JOIN Room r ON
        b.ID_room = r.ID_room
    JOIN Hotel h ON
        r.ID_hotel = h.ID_hotel
    JOIN hotel_category hc ON
        h.ID_hotel = hc.ID_hotel
)
SELECT
    ch.ID_customer,
    ch.name,
    CASE WHEN MAX(ch.category = 'Дорогой') = 1 THEN 'Дорогой' WHEN MAX(ch.category = 'Средний') = 1 THEN 'Средний' ELSE 'Дешевый'
END AS preferred_hotel_type,
GROUP_CONCAT(
    DISTINCT ch.hotel_name
ORDER BY
    ch.hotel_name SEPARATOR ','
) AS visited_hotels
FROM
    customer_hotels ch
GROUP BY
    ch.ID_customer,
    ch.name
ORDER BY
    FIELD(
        CASE WHEN MAX(ch.category = 'Дорогой') = 1 THEN 'Дорогой' WHEN MAX(ch.category = 'Средний') = 1 THEN 'Средний' ELSE 'Дешевый'
    END,
    'Дешевый',
    'Средний',
    'Дорогой'
),
ch.ID_customer;
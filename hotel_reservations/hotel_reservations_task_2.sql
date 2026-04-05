SELECT
    q1.ID_customer,
    q1.name,
    q1.total_bookings,
    q1.total_spent,
    q1.unique_hotels
FROM
    (
    SELECT
        c.ID_customer,
        c.name,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS unique_hotels,
        SUM(r.price) AS total_spent
    FROM
        Customer c
    JOIN Booking b ON
        c.ID_customer = b.ID_customer
    JOIN Room r ON
        b.ID_room = r.ID_room
    JOIN Hotel h ON
        r.ID_hotel = h.ID_hotel
    GROUP BY
        c.ID_customer,
        c.name
    HAVING
        COUNT(b.ID_booking) > 2 AND COUNT(DISTINCT h.ID_hotel) > 1
) q1
INNER JOIN(
    SELECT c.ID_customer,
        SUM(r.price) AS total_spent
    FROM
        Customer c
    JOIN Booking b ON
        c.ID_customer = b.ID_customer
    JOIN Room r ON
        b.ID_room = r.ID_room
    GROUP BY
        c.ID_customer
    HAVING
        SUM(r.price) > 500
) q2
ON
    q1.ID_customer = q2.ID_customer
ORDER BY
    q1.total_spent ASC;
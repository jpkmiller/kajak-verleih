DROP TABLE reservations;

# Create table reservations
CREATE TABLE IF NOT EXISTS reservations
(
    reservation_id   INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name             VARCHAR(30) NOT NULL,
    email            VARCHAR(50) NOT NULL,
    phone            VARCHAR(20) NOT NULL,
    address          VARCHAR(80) NOT NULL,
    date             DATE        NOT NULL,
    reservation_date DATE        NOT NULL,
    from_time        TIME        NOT NULL,
    to_time          TIME        NOT NULL,
    price            NUMERIC     NOT NULL DEFAULT 0,
    archived         BOOLEAN     NOT NULL DEFAULT FALSE,
    cancelled        BOOLEAN     NOT NULL DEFAULT FALSE,
    CONSTRAINT NAME_CHECK CHECK (REGEXP_LIKE(name, '^[A-ZäÄöÖüÜßa-z]+ [A-ZäÄöÖüÜßa-z]+$'))
);

# Fill table reservations'
INSERT INTO reservations (name, email, phone, address, date, reservation_date, from_time, to_time, archived, cancelled)
VALUES ('Paul Aner', 'lol@123.de', 'Max-Straße 8', '123456789', '2019-01-01', '2022-12-01', '10:00:00', '11:00:00',
        FALSE, FALSE),
       ('Spe Zi', 'foo@bar.de', 'Max-Straße 9', '987654321', '2019-01-01', '2018-12-02', '9:00:00', '14:00:00', FALSE,
        FALSE),
       ('Scheiß Verein', '123@123.de', 'Nice-Straße 1', '123498765', '2019-01-02', '2016-10-13', '12:00:00', '15:00:00',
        FALSE, FALSE),
       ('Olivia Bolivia', '123@123.de', 'Nice-Straße 1', '123498765', '2019-01-02', '2016-10-13', '12:00:00',
        '15:00:00', FALSE, FALSE);

# Create table kajaks
DROP TABLE kajaks;

CREATE TABLE IF NOT EXISTS kajaks
(
    kajak_name VARCHAR(30)  NOT NULL PRIMARY KEY,
    kind       VARCHAR(30)  NOT NULL,
    seats      INT          NOT NULL DEFAULT 0,
    available  BOOLEAN      NOT NULL DEFAULT TRUE,
    comment    VARCHAR(200) NOT NULL DEFAULT ''
);

# Fill table kajaks
INSERT INTO kajaks (kajak_name, kind, seats)
VALUES ('Horst', 'quint_kajak', 5),
       ('Gertrud', 'single_kajak', 1),
       ('Marte', 'double_kajak', 2),
       ('Legolas', 'nice_kajak', 200),
       ('Horst2', 'single_kajak', 1);

# Create table for kajak-reservation
CREATE TABLE IF NOT EXISTS kajak_reservation
(
    reservation_id INT         NOT NULL,
    kajak_name     VARCHAR(30) NOT NULL,
    PRIMARY KEY (reservation_id, kajak_name)
);

# Fill table kajak-reservation
INSERT INTO kajak_reservation (kajak_name, reservation_id)
VALUES ('Horst', 1),
       ('Gertrud', 1),
       ('Gertrud', 2),
       ('Horst', 3),
       ('Marte', 3),
       ('Legolas', 3),
       ('Horst2', 3);

SELECT *
FROM reservations;

# Select all reservations for a given date
SELECT COUNT(kajaks.kind) as amount
FROM ((kajak_reservation
    INNER JOIN reservations
       ON reservations.reservation_id = kajak_reservation.reservation_id)
    LEFT JOIN kajaks ON kajak_reservation.kajak_name = kajaks.kajak_name)
WHERE reservations.date = '2019-01-01'
  AND kajaks.kind = 'single_kajak'
  AND (reservations.from_time BETWEEN '9:00:00' AND '17:59:59'
    OR reservations.to_time BETWEEN '9:00:00' AND '17:59:59');

# Select free kajaks on 2019-01-01
SELECT *
FROM kajak_reservation
         INNER JOIN reservations
                    ON reservations.reservation_id = kajak_reservation.reservation_id
WHERE reservations.date = '2019-01-01'
  AND (reservations.from_time BETWEEN '9:00:00' AND '17:59:59'
    OR reservations.to_time BETWEEN '9:00:00' AND '17:59:59');

SELECT kajak_name
FROM kajaks
WHERE kajak_name NOT IN (SELECT kajak_reservation.kajak_name
                         FROM kajak_reservation
                                  INNER JOIN reservations
                                             ON reservations.reservation_id = kajak_reservation.reservation_id
                         WHERE reservations.date = '2019-01-01'
                           AND (reservations.from_time BETWEEN '9:00:00' AND '17:59:59'
                             OR reservations.to_time BETWEEN '9:00:00' AND '17:59:59'))
  AND kajaks.kind = 'single_kajak';


SELECT DISTINCT(kind)
FROM kajaks;

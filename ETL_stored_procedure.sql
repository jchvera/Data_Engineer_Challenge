create
    definer = admin@`%` procedure agg_data()
BEGIN
SELECT v.id vehicle_ide,
       v.brand vehicle_brand,
       v.description vehicle_model,
       v.category vehicle_category,
       v.color vehicle_category,
       v.transmission vehicle_transmission,
       AVG(t.rental_days) AS rental_average_time,
       COUNT(ft.id)          times_rented,
       ll.description location
FROM car_rental.vehicle v
         LEFT JOIN car_rental.fact_table ft
                   ON ft.vehicle_id = v.id
         LEFT JOIN car_rental.transaction t
                   ON t.id = ft.transaction_id
         LEFT JOIN car_rental.lu_location ll
                   ON ll.id = ft.start_office_id
GROUP BY v.brand, v.description, ft.start_office_id
ORDER BY times_rented DESC;
END;


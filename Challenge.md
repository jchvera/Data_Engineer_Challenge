# Data Engineer Challenge
por Juan Carlos Hernández Vera
## DDL
**El siguiente modelo de datos fue generado sobre una base de datos MySQL utilizando el servicio de AWS-RDS.**


### Creación de la base de datos:

```sql
CREATE DATABASE car_rental;
```

### Creación de las tablas
**El modelo de datos esta compuesto por seis tablas pensado para un negocio de renta de coches. Se adjuntan algunos archivos csv que se generaron con datos de prueba.**

Las tablas son:


### customer
Esta tabla es un catálogo de clientes, además de su llave primaria cuenta con el nombre y apellido del cliente,
así como algunos datos de contacto como email y número de teléfono, además de la fecha en la cuál fue registrado dicho cliente.
```sql
create table if not exists customer
(
    id            bigint auto_increment
        primary key,
    first_name    varchar(255) null,
    last_name     varchar(255) null,
    num_phone     varchar(100) null,
    email         varchar(255) null,
    register_date date         null
);
```
**Archivo csv:** [customer.csv](https://github.com/jchvera/Data_Engineer_Challenge/files/8054825/customer.csv)

### lu_location
Esta tabla es un catálogo de oficinas (lugares donde se rentan los vehículos), además de su llave primaria cuenta con el detalle sobre el nombre de la oficina 
e información sobre la ubicación de esta, país, estado, ciudad, localidad y código postal.
```sql
create table if not exists lu_location
(
    id          bigint auto_increment
        primary key,
    description varchar(255) null,
    country     varchar(40)  null,
    state       varchar(100) null,
    city        varchar(100) null,
    location    varchar(255) null,
    zipcode     int          null
);
```
**Archivo csv:** [location.csv](https://github.com/jchvera/Data_Engineer_Challenge/files/8054829/location.csv)

### km
Esta tabla se creó con la intención de poder llevar un control del kilometraje de los vehículos en renta, 
de esta forma se actualiza cada vez que se ha rentado el vehículo y registra un nuevo kilometraje sin afectar así el catálogo de vehículos existentes.
```sql
create table if not exists km
(
    id         bigint auto_increment
        primary key,
    current_km bigint null
);
```
**Archivo csv:** [km.csv](https://github.com/jchvera/Data_Engineer_Challenge/files/8054837/km.csv)


### vehicle
Esta tabla es un catálogo de los vehículos con los que se cuenta actualmente, así como sus características más relevantes tales como año, marca, modelo,
categoría, tipo de transmisión, color y el kilometraje.
```sql
create table if not exists vehicle
(
    id           bigint auto_increment
        primary key,
    model_year   int          null,
    brand        varchar(100) null,
    description  varchar(255) null,
    category     varchar(40)  null,
    color        varchar(40)  null,
    transmission char(2)      null,
    km_id        bigint       null,
    constraint km_id
        foreign key (id) references km (id)
);
```
**Archivo csv:** [vehicle.csv](https://github.com/jchvera/Data_Engineer_Challenge/files/8054840/vehicle.csv)

### fact_table
En esta tabla se registran las transacciones de renta de los vehículos, así como algunas características relevantes sobre dichas transacciones tales como: 
fecha de inicio y fin de la renta, elid del vehículo en renta así como el estado de este, el cliente que lo renta, en que oficina o localidad se renta, 
además del kilometraje y el combustible.
```sql
create table if not exists fact_table
(
    id                    bigint auto_increment
        primary key,
    transaction_id        bigint null,
    start_date            date   null,
    end_date              date   null,
    vehicle_id            bigint null,
    vehicle_status        char   null,
    customer_id           bigint null,
    start_office_id       bigint null,
    end_office_id         bigint null,
    start_km              bigint null,
    end_km                bigint null,
    start_fuel_percentage double null,
    end_fuel_percentage   double null
);
```
**Archivo csv:** [fact_table.csv](https://github.com/jchvera/Data_Engineer_Challenge/files/8054842/fact_table.csv)


### transaction
Esta tabla es un catálogo de oficinas (lugares donde se rentan los vehículos), además de su llave primaria cuenta con el detalle sobre el nombre de la oficina 
e información sobre la ubicación de esta, país, estado, ciudad, localidad y código postal.
```sql
create table if not exists transaction
(
    id               bigint auto_increment
        primary key,
    transaction_type varchar(40) null,
    transaction_time timestamp   null,
    transaction_km   bigint      null,
    km_fee           double      null,
    rate_fee         double      null,
    rental_days      bigint      null,
    fuel_fee         double      null,
    insurance_fee    double      null,
    other_fees       double      null,
    total_fee        double      null,
    payment_type     varchar(40) null
);
```
**Archivo csv:** [transaction2.txt](https://github.com/jchvera/Data_Engineer_Challenge/files/8054849/transaction2.txt)

## ETL (stored procedure)
Se crea un store procedure para obtener una tabla agregada por vehículo y oficina de renta, que nos muestra los vechículos más rentados,
así como el tiempo promedio de renta para dichos vehículos.

```sql
CREATE PROCEDURE agg_data()
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
```

Se llama el stored procedure para poder ver el resultado:

```sql
CALL agg_data();
```





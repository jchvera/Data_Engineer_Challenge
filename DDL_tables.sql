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

create table if not exists km
(
    id         bigint auto_increment
        primary key,
    current_km bigint null
);

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
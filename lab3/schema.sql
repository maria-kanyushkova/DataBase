create table author
(
    id         serial not null
        constraint author_pk
            primary key,
    name       varchar(255),
    surname    varchar(255),
    patronymic varchar(255),
    birth_year date,
    country    varchar(255)
);

alter table author
    owner to root;

create table city
(
    id        serial not null
        constraint city_pk
            primary key,
    title     varchar(255),
    latitude  double precision,
    longitude double precision,
    timezone  smallint
);

alter table city
    owner to root;

create table book_store
(
    id      serial       not null
        constraint book_store_pk
            primary key,
    name    varchar(255) not null,
    address varchar(255),
    city_id integer
        constraint book_store_city_id_fk
            references city
            on delete cascade,
    phone   varchar(15),
    email   varchar(255)
);

alter table book_store
    owner to root;

create table publisher
(
    id      serial not null
        constraint publisher_pk
            primary key,
    title   varchar(255),
    address varchar(255),
    city_id integer
        constraint publisher_city_id_fk
            references city,
    phone   varchar(15),
    email   varchar(255)
);

alter table publisher
    owner to root;

create table book
(
    id           serial not null
        constraint book_pk
            primary key,
    isbn         varchar(13),
    title        varchar(255),
    description  text,
    publishing   date,
    publisher_id integer
        constraint book_publisher_id_fk
            references publisher,
    min_price    integer default 0
);

alter table book
    owner to root;

create table all_book
(
    store_id integer not null
        constraint all_book_book_store_id_fk
            references book_store,
    book_id  integer not null
        constraint all_book_book_id_fk
            references book,
    count    integer default 0,
    constraint all_book_pk
        primary key (book_id, store_id)
);

alter table all_book
    owner to root;

create table book_author
(
    book_id   integer not null
        constraint book_author_book_id_fk
            references book
            on delete cascade,
    author_id integer not null
        constraint book_author_author_id_fk
            references author
            on delete cascade,
    constraint book_author_pk
        primary key (book_id, author_id)
);

alter table book_author
    owner to root;


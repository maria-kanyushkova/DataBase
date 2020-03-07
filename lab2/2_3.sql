create table cinema
(
    id   serial       not null
        constraint cinema_pk
            primary key,
    name varchar(255) not null,
    city varchar(255) not null
);

alter table cinema
    owner to postgres;

create table hall
(
    id        serial       not null
        constraint hall_pk
            primary key,
    cinema_id integer      not null
        constraint hall_cinema_id_fk
            references cinema
            on delete cascade,
    schema    json         not null,
    title     varchar(255) not null,
    type      varchar(255) not null
);

alter table hall
    owner to postgres;

create table format
(
    id   serial       not null
        constraint format_pk
            primary key,
    name varchar(255) not null
);

alter table format
    owner to postgres;

create table supported_format
(
    hall_id   integer not null
        constraint supported_format_hall_id_fk
            references hall
            on delete cascade,
    format_id integer not null
        constraint supported_format_format_id_fk
            references format
            on delete cascade,
    constraint supported_format_pk
        primary key (hall_id, format_id)
);

alter table supported_format
    owner to postgres;

create table genre
(
    id   serial       not null
        constraint genre_pk
            primary key,
    name varchar(255) not null
);

alter table genre
    owner to postgres;

create table film
(
    id                serial           not null
        constraint film_pk
            primary key,
    category          varchar(255)     not null,
    genre_id          integer
        constraint film_genre_id_fk
            references genre
            on delete set null,
    age_qualification integer          not null,
    description       text             not null,
    title             text             not null,
    rating            double precision not null,
    duration          smallint         not null
);

alter table film
    owner to postgres;

create table session
(
    id         serial    not null
        constraint session_pk
            primary key,
    format_id  integer
        constraint session_format_id_fk
            references format
            on delete set null,
    start_time timestamp not null,
    price      integer   not null,
    show_date  date      not null,
    film_id    integer   not null
        constraint session_film_id_fk
            references film
            on delete cascade
);

alter table session
    owner to postgres;

create table timetable
(
    hall_id    integer not null
        constraint timetable_hall_id_fk
            references hall
            on delete cascade,
    session_id integer not null
        constraint timetable_session_id_fk
            references session
            on delete cascade,
    constraint timetable_pk
        primary key (hall_id, session_id)
);

alter table timetable
    owner to postgres;


create table subscriber
(
    id               serial       not null
        constraint subscriber_pk
            primary key,
    name             varchar(255) not null,
    surname          varchar(255) not null,
    delivery_address text         not null
);

alter table subscriber
    owner to postgres;

create table edition
(
    id          serial       not null
        constraint edition_pk
            primary key,
    name        varchar(255) not null,
    type        varchar(255) not null,
    circulation integer      not null,
    year_issue  date         not null,
    description text
);

alter table edition
    owner to postgres;

create table posting
(
    subscriber_id integer not null
        constraint posting_subscriber_id_fk
            references subscriber
            on delete cascade,
    edition_id    integer not null
        constraint posting_edition_id_fk
            references edition
            on delete cascade,
    date          timestamp,
    count         integer default 1,
    constraint posting_pk
        primary key (subscriber_id, edition_id)
);

alter table posting
    owner to postgres;


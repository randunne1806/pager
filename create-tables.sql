drop schema if exists pager cascade;

create schema if not exists pager;

set
    search_path to pager;

create table if not exists pager.message (
    id serial unique not null,
    content varchar(2000) not null,
    primary key (id)
);

create table if not exists pager.capcode (
    base_id char(3) not null,
    pager_id char(4) not null,
    base_id_name varchar(255) not null,
    pager_id_name varchar(255) not null,
    primary key (base_id, pager_id)
);

create table if not exists pager.log (
    id serial not null,
    message_id serial not null,
    base_id char(3) not null,
    pager_id char(4) not null,
    send_date timestamp not null,
    sent_successfully boolean not null,
    foreign key (base_id, pager_id) references pager.capcode(base_id, pager_id),
    foreign key (message_id) references pager.message(id),
    primary key (id)
);

insert into
    pager.capcode
values
    ('003', '0001', 'Area 3', 'John');

insert into
    pager.capcode
values
    ('001', '0001', 'Area 1', 'Mark');

insert into
    pager.capcode
values
    ('002', '0001', 'Area 2', 'Adam');

insert into
    pager.capcode
values
    ('001', '0002', 'Area 1', 'James');
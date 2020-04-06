# 1. Добавить внешние ключи

alter table booking
	add constraint booking_client_id_client_fk
		foreign key (id_client) references client;

alter table room_in_booking
	add constraint room_in_booking_booking_id_booking_fk
		foreign key (id_booking) references booking;

alter table room_in_booking
	add constraint room_in_booking_room_id_room_fk
		foreign key (id_room) references room;

alter table room
	add constraint room_hotel_id_hotel_fk
		foreign key (id_hotel) references hotel;

alter table room
	add constraint room_room_category_id_room_category_fk
		foreign key (id_room_category) references room_category;

# 2. Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах категории “Люкс” на 1 апреля 2019г.

select client.name, client.phone
from booking
         left join client on client.id_client = booking.id_client
         left join room_in_booking on room_in_booking.id_booking = booking.id_booking
         left join room on room.id_room = room_in_booking.id_room
         left join room_category on room_category.id_room_category = room.id_room_category
         left join hotel on hotel.id_hotel = room.id_hotel
where checkin_date <= CAST('2019-04-01' as DATE)
  and checkout_date >= CAST('2019-04-01' as DATE)
  and hotel.name = 'Космос'
  and room_category.name = 'Люкс'

#3. Дать список свободных номеров всех гостиниц на 22 апреля 
# (из множества всех комнат которые есть, вычитаем комнаты которые заняты на 22 апреля)

select * from room
except
select room.*
        from room
                 left outer join room_in_booking on room_in_booking.id_room = room.id_room
        where checkin_date <= CAST('2019-04-22' as DATE)
           and checkout_date >= CAST('2019-04-22' as DATE)

#4. Дать количество проживающих в гостинице “Космос” на 23 марта по каждой категории номеров

select count(id_client), room_category.name
from booking
         left join room_in_booking on room_in_booking.id_booking = booking.id_booking
         left join room on room.id_room = room_in_booking.id_room
         left join room_category on room_category.id_room_category = room.id_room_category
         left join hotel on hotel.id_hotel = room.id_hotel
where checkin_date <= CAST('2019-03-23' as DATE)
  and checkout_date >= CAST('2019-03-23' as DATE)
  and hotel.name = 'Космос'
group by room_category.id_room_category

#5. Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, выехавшим в апреле с указанием даты выезда

select client.name, t.id_room, t.date
from (
         select max(checkout_date) over (partition by id_room) as date, id_room, id_booking, checkout_date
         from room_in_booking
         where checkout_date >= CAST('2019-04-01' as DATE)
           and checkout_date <= CAST('2019-04-30' as DATE)
     ) as t
         left join booking on t.id_booking = booking.id_booking
         left join client on client.id_client = booking.id_client
         left join room on room.id_room = t.id_room
         left join hotel on hotel.id_hotel = room.id_hotel
where date = t.checkout_date
  and hotel.name = 'Космос'

#6. Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, которые заселились 10 мая.

update room_in_booking
set checkout_date = checkout_date + interval '2 days'
where room_in_booking.id_room_in_booking in (
          select room_in_booking.id_room_in_booking
          from room_in_booking
                   left join booking on room_in_booking.id_booking = booking.id_booking
                   left join room on room.id_room = room_in_booking.id_room
                   left join room_category on room_category.id_room_category = room.id_room_category
                   left join hotel on hotel.id_hotel = room.id_hotel
          where checkin_date = CAST('2019-05-10' as DATE)
            and hotel.name = 'Космос'
            and room_category.name = 'Бизнес'
      )

#7. Найти все "пересекающиеся" варианты проживания. Правильное состояние:не может быть забронирован один номер на одну дату несколько раз, т.к. нельзя заселиться нескольким клиентам в один номер. Записи в таблице room_in_booking с id_room_in_booking = 5 и 2154 являются примером неправильного с остояния, которые необходимо найти. Результирующий кортеж выборки должен содержать информацию о двух конфликтующих номерах.



#8. Создать бронирование в транзакции.

begin transaction;
	insert into booking (id_booking, id_client, booking_date)
	values (10000, 4, now());
	insert into room_in_booking (id_room_in_booking, id_booking, id_room, checkin_date, checkout_date)
	values (10000, 10000, 1, date('2020-05-01'), date('2020-05-10'));
commit;



#9. Добавить необходимые индексы для всех таблиц


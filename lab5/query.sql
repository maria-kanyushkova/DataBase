# 1. Добавить внешние ключи
alter table lab5.order
	add constraint order_dealer_id_dealer_fk
		foreign key (id_dealer) references lab5.dealer;

alter table lab5.order
	add constraint order_pharmacy_id_pharmacy_fk
		foreign key (id_pharmacy) references lab5.pharmacy;

alter table lab5.order
	add constraint order_production_id_production_fk
		foreign key (id_production) references lab5.production;

alter table lab5.production
	add constraint production_company_id_company_fk
		foreign key (id_company) references lab5.company;

alter table lab5.production
	add constraint production_medicine_id_medicine_fk
		foreign key (id_medicine) references lab5.medicine;

alter table lab5.dealer
	add constraint dealer_company_id_company_fk
		foreign key (id_company) references lab5.company;


# 2. Выдать информацию по всем заказам лекарства "Кордерон" компании "Аргус" с
#    указанием названий аптек, дат, объема заказов.
-- в dump.sql "Кордерон" в csv таблицах "Кордеон"
-- данные инсертила с csv
SELECT pharmacy.name,
       "order".date,
       "order".quantity
FROM "order"
         LEFT JOIN pharmacy ON "order".id_pharmacy = pharmacy.id_pharmacy
         LEFT JOIN production ON "order".id_production = production.id_production
         LEFT JOIN company ON production.id_company = company.id_company
         LEFT JOIN medicine ON production.id_medicine = medicine.id_medicine
WHERE medicine.name = 'Кордеон'
  AND company.name = 'Аргус'

# 3. Дать список лекарств компании "Фарма", на которые не были сделаны заказы
#    до 25 января.
// todo: добавить новое лекарство в Фарму и убедиться что при выполнении запроса это лекарство есть
SELECT medicine.name
FROM medicine
    EXCEPT
SELECT medicine.name
FROM medicine
         LEFT JOIN production ON medicine.id_medicine = production.id_medicine
         LEFT JOIN company ON production.id_company = company.id_company
         LEFT JOIN "order" ON production.id_production = "order".id_production
WHERE company.name = 'Фарма'
GROUP BY medicine.name
HAVING MIN("order".date) < CAST('2019-01-25' AS DATE)

# 4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая
#    оформила не менее 120 заказов.
SELECT company.name,
       MIN(production.rating) AS min_rating,
       MAX(production.rating) AS max_rating
FROM production
         LEFT JOIN company ON production.id_company = company.id_company
         LEFT JOIN "order" ON production.id_production = "order".id_production
GROUP BY company.id_company, company.name
HAVING COUNT("order".id_order) >= 120

# 5. Дать списки сделавших заказы аптек по всем дилерам компании "AstraZeneca".
#    Если у дилера нет заказов, в названии аптеки проставить NULL.
SELECT dealer.id_dealer,
       dealer.name,
       pharmacy.name
FROM dealer
         LEFT JOIN company ON dealer.id_company = company.id_company
         LEFT JOIN "order" ON "order".id_dealer = dealer.id_dealer
         LEFT JOIN pharmacy ON pharmacy.id_pharmacy = "order".id_pharmacy
WHERE company.name = 'AstraZeneca'
ORDER BY dealer.id_dealer

# 6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а
#    длительность лечения не более 7 дней.
UPDATE production
SET price = price * 0.8
WHERE production.id_production IN (
    SELECT production.id_production
    FROM production
             LEFT JOIN medicine ON production.id_medicine = medicine.id_medicine
    WHERE production.price > CAST(3000 AS MONEY) AND medicine.cure_duration <= CAST(7 AS SMALLINT)
)

# 7. Добавить необходимые индексы.
create index dealer_id_company_index
	on lab5.dealer (id_company);

create index production_id_company_index
	on lab5.production (id_company);

create index production_id_medicine_index
	on lab5.production (id_medicine);

create index production_rating_index
	on lab5.production (rating);

create index order_date_index
	on lab5."order" (date);

create index order_id_dealer_index
	on lab5."order" (id_dealer);

create index order_id_pharmacy_index
	on lab5."order" (id_pharmacy);

create index order_id_production_index
	on lab5."order" (id_production);

create index company_name_index
	on lab5.company (name);

create index medicine_name_index
	on lab5.medicine (name);


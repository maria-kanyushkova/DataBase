# 1. Добавить внешние ключи
alter table lab6.student
	add constraint student_group_id_group_fk
		foreign key (id_group) references lab6."group";

alter table lab6.lesson
	add constraint lesson_group_id_group_fk
		foreign key (id_group) references lab6."group";

alter table lab6.lesson
	add constraint lesson_subject_id_subject_fk
		foreign key (id_subject) references lab6.subject;

alter table lab6.lesson
	add constraint lesson_teacher_id_teacher_fk
		foreign key (id_teacher) references lab6.teacher;

alter table lab6.mark
	add constraint mark_lesson_id_lesson_fk
		foreign key (id_lesson) references lab6.lesson;

alter table lab6.mark
	add constraint mark_student_id_student_fk
		foreign key (id_student) references lab6.student;

# 2. Выдать оценки студентов по информатике если они обучаются данному
#    предмету. Оформить выдачу данных с использованием view.
CREATE VIEW students_mark AS
SELECT student.name,
       mark.mark
FROM mark
         LEFT JOIN lesson on mark.id_lesson = lesson.id_lesson
         LEFT JOIN student on mark.id_student = student.id_student
         LEFT JOIN subject on lesson.id_subject = subject.id_subject
WHERE subject.name = 'Информатика'

# 3. Дать информацию о должниках с указанием фамилии студента и названия
#    предмета. Должниками считаются студенты, не имеющие оценки по предмету,
#    который ведется в группе. Оформить в виде процедуры, на входе
#    идентификатор группы.
CREATE OR REPLACE FUNCTION debtor_info(identifier varchar)
    RETURNS TABLE
            (
                name    varchar,
                subject varchar
            )
    LANGUAGE SQL
AS
$$
SELECT student.name,
       subject.name
FROM student
         INNER JOIN "group" ON "group".id_group = student.id_group
         INNER JOIN lesson ON lesson.id_group = "group".id_group
         LEFT JOIN mark ON mark.id_student = student.id_student AND mark.id_lesson = lesson.id_lesson
         INNER JOIN subject ON subject.id_subject = lesson.id_subject
WHERE "group".name = identifier
GROUP BY student.name, subject.name
HAVING COUNT(mark.mark) = 0
ORDER BY student.name
$$;


SELECT *
FROM debtor_info('ПС');
SELECT *
FROM debtor_info('ИВТ');
SELECT *
FROM debtor_info('ВМ');
SELECT *
FROM debtor_info('БИ');

# 4. Дать среднюю оценку студентов по каждому предмету для тех предметов, по
#    которым занимается не менее 35 студентов.
SELECT subject.name,
       AVG(mark.mark)
FROM mark
         LEFT JOIN lesson ON mark.id_lesson = lesson.id_lesson
         LEFT JOIN subject ON lesson.id_subject = subject.id_subject
         LEFT JOIN student ON mark.id_student = student.id_student
GROUP BY subject.name
HAVING (COUNT(DISTINCT student.id_student) >= 35)

# 5. Дать оценки студентов специальности ВМ по всем проводимым предметам с
#    указанием группы, фамилии, предмета, даты. При отсутствии оценки заполнить
#    значениями NULL поля оценки.
SELECT subject.name AS subject_name,
       "group".name AS group_name,
       student.name AS student_name,
       mark.mark,
       lesson.date
FROM student
         LEFT JOIN "group" ON student.id_group = "group".id_group
         LEFT JOIN lesson ON lesson.id_group = "group".id_group
         LEFT JOIN subject ON lesson.id_subject = subject.id_subject
         LEFT JOIN mark ON (lesson.id_lesson = mark.id_lesson AND student.id_student = mark.id_student)
WHERE "group".name = 'ВМ'
ORDER BY subject.name

# 6. Всем студентам специальности ПС, получившим оценки меньшие 5 по предмету
#    БД до 12.05, повысить эти оценки на 1 балл.
UPDATE mark
SET mark = (mark + 1)
WHERE mark.id_student IN (
    SELECT student.id_student
    FROM student
             LEFT JOIN "group" ON student.id_group = "group".id_group
    WHERE "group".name = 'ПС')
  AND mark.id_lesson IN (
    SELECT lesson.id_lesson
    FROM lesson
             LEFT JOIN "group" ON "group".id_group = lesson.id_group
             LEFT JOIN student ON "group".id_group = student.id_group
             LEFT JOIN subject ON lesson.id_subject = subject.id_subject
             LEFT JOIN mark ON (mark.id_student = student.id_student AND mark.id_lesson = lesson.id_lesson)
    WHERE lesson.date < CAST('2019-05-12' AS date)
      AND subject.name = 'БД'
)
  AND mark.mark < 5

# 7. Добавить необходимые индексы.
create index group_name_index
	on lab6."group" (name);

create index lesson_id_group_index
	on lab6.lesson (id_group);

create index lesson_id_subject_index
	on lab6.lesson (id_subject);

create index lesson_id_teacher_index
	on lab6.lesson (id_teacher);

create index mark_id_lesson_index
	on lab6.mark (id_lesson);

create index mark_id_student_index
	on lab6.mark (id_student);

create index mark_mark_index
	on lab6.mark (mark);
	
create index student_id_group_index
	on lab6.student (id_group);

create index student_name_index
	on lab6.student (name);

create index subject_name_index
	on lab6.subject (name);

create index teacher_name_index
	on lab6.teacher (name);


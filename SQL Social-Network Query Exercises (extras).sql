## Q1
# For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C.
select H1.name,H1.grade,H2.name,H2.grade,H3.name,H3.grade
from Highschooler H1 join Likes L1 join Highschooler H2 join Likes L2 join Highschooler H3
where H1.ID=L1.ID1 and H2.ID=L1.ID2 and L2.ID2=H3.ID and L1.ID2=L2.ID1
and L1.ID1 not in (select L.ID2 from Likes L where L1.ID2=L.ID1);

## Q2
# Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 
select H1.name, H1.grade
from Highschooler H1 join Friend F on F.ID1=H1.ID
where H1.grade not in (select H2.grade 
	                   from Highschooler H2 join Friend F2 on F2.ID2=H2.ID
				       where F.ID1=F2.ID1);
## actually, only need to go through H,first from join is not needed!
select H1.name, H1.grade
from Highschooler H1
where H1.grade not in (select H2.grade 
	                   from Highschooler H2 join Friend F on F.ID2=H2.ID
				       where H1.ID=F.ID1);
					   
## Q3
# What is the average number of friends per student? (Your result should be just one number.) 
select avg(n)
from (select count(*) as n from Friend group by ID1);

## Q4
# Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 
select count(distinct ID2)
from (select ID2
from Friend F
where F.ID1 in (select ID from Highschooler where name='Cassandra')
union
select F2.ID2 as ID2
from Friend F1 join Friend F2 on F1.ID2=F2.ID1
where F1.ID1=(select ID from Highschooler where name='Cassandra')
and F2.ID2<>F1.ID1);

## Q5
# Find the name and grade of the student(s) with the greatest number of friends. 
select distinct H.name, H.grade
from Highschooler H join Friend on ID=ID1
group by ID1
having count(*) = (select max(n) from (select count(*) n from Friend group by ID1));

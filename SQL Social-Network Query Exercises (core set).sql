## Q1
# Find the names of all students who are friends with someone named Gabriel. 
select distinct name
from (select ID2 as ID
from Friend join Highschooler on Friend.ID1=Highschooler.ID
where name='Gabriel'
union
select ID1 as ID
from Friend join Highschooler on Friend.ID2=Highschooler.ID
where name='Gabriel') join Highschooler using(ID);

## Q2
# For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 
select L1.name, L1.grade, H.name, H.grade
from ((Likes join Highschooler H on Likes.ID1=H.ID) L1
join
Highschooler H on L1.ID2=H.ID)
where L1.grade-H.grade>=2;

## Q3
# For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.
select distinct R1.name, R1.grade, H.name, H.grade
from (((select L1.ID1,L1.ID2
from Likes L1 join Likes L2 on L1.ID2=L2.ID1
where L1.ID1=L2.ID2) LL join Highschooler H on LL.ID1=H.ID) R1
join
Highschooler H on R1.ID2=H.ID)
where R1.name<H.name;

## Q4
# Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.
select name, grade
from Highschooler H
where H.ID not in (select ID1 as ID from Likes union select ID2 as ID from Likes)
order by grade, name;

## Q5
# For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 
select L1.name,L1.grade,H.name,H.grade
from (select H.name, H.grade, Likes.ID2
from Highschooler H join Likes on H.ID=Likes.ID1
where Likes.ID2 not in (select ID1 from Likes)) L1 join Highschooler H on L1.ID2=H.ID;

## Q6
# Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 
select H.name, H.grade
from Highschooler H
where ID not in
(select ID1 as ID from (select F.ID1, F.ID2
from Highschooler H1 join Friend F join Highschooler H2
where H1.ID=F.ID1 and H2.ID=F.ID2 and H1.grade<>H2.grade))
order by grade, name;

## Q7
# For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 
select H1.name, H1.grade, H2.name, H2.grade, H3.name,H3.grade
from Highschooler H1 join 
(select distinct NF.ID1 as ID1,NF.ID2 as ID2,F1.ID2 as ID3
from Friend F1 join (select * from Likes except select * from Friend) NF join Friend F2
where F1.ID1=NF.ID1 and F2.ID1=NF.ID2 and F1.ID2=F2.ID2) T 
join Highschooler H2 join Highschooler H3
where H1.ID=T.ID1 and H2.ID=T.ID2 and H3.ID=T.ID3;
## other solution found online
select distinct H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Highschooler H1, Likes, Highschooler H2, Highschooler H3, Friend F1, Friend F2
where H1.ID = Likes.ID1 and Likes.ID2 = H2.ID and
  H2.ID not in (select ID2 from Friend where ID1 = H1.ID) and
  H1.ID = F1.ID1 and F1.ID2 = H3.ID and
  H3.ID = F2.ID1 and F2.ID2 = H2.ID;
  
## Q8
# Find the difference between the number of students in the school and the number of different first names. 
select abs(count(*)-(select count(*) from Highschooler))
from (select * from Highschooler group by name);
#count(distinct name)

## Q9
# Find the name and grade of all students who are liked by more than one other student. 
select distinct H.name,H.grade
from Highschooler H join Likes L on H.ID=L.ID2
where L.ID2 in (select L.ID2 from Likes L group by L.ID2 having count(*)>1);

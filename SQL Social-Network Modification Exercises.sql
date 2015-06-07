## Q1
# It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
delete from highschooler
	where grade=12;

## Q2
# If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
delete from Likes 
where ID2 in (select ID2 from Friend F where F.ID1=Likes.ID1)
and ID1 not in (select L.ID2 from Likes L where L.ID1=Likes.ID2);
# specify Likes when ambiguous

## Q3
# For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself.
Insert into Friend
select distinct F1.ID1, F2.ID2
from Friend F1 join Friend F2 on F1.ID2=F2.ID1
where F2.ID2<>F1.ID1
and F2.ID2 not in (select ID2 from Friend where ID1=F1.ID1);


## Q1
# Find the names of all reviewers who rated Gone with the Wind.
select distinct name
from Movie natural join Rating natural join Reviewer
where title='Gone with the Wind';

## Q2
# For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
select name, title, stars
from Movie natural join (Reviewer natural join Rating)
where director=name;

## Q3
# Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 
select *
from (select name
from Reviewer
union
select title as name
from Movie)
order by name;

## Q4
# Find the titles of all movies not reviewed by Chris Jackson. 
select title
from Movie
where mID not in
(select mID
from Reviewer natural join Rating
where name='Chris Jackson');

## Q5
# For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.
select distinct R1.name, R2.name
from (Rating natural join Reviewer) R1, (Rating natural join Reviewer) R2
where R1.mID=R2.mID and R1.name<R2.name;

## Q6
# For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.
select name, title, stars
from Movie natural join (Reviewer natural join Rating)
where stars in (select min(stars)
from Rating);

## Q7
# List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 
select title, stars
from Movie natural join
(select mID,avg(stars) as stars
from Rating
group by mID)
order by stars desc, title;

## Q8
# Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 
select name
from Reviewer natural join
(select rID
from Rating
group by rID
having count(*)>=3);
## extra challenge -- found answer online
select name
from Reviewer, (
  select distinct R1.rID
  from Rating R1, Rating R2, Rating R3
  where R1.rID = R2.rID and (R1.mID <> R2.mID or R1.ratingDate <> R2.ratingDate)
  and R1.rID = R3.rID and (R1.mID <> R3.mID or R1.ratingDate <> R3.ratingDate)
  and R3.rID = R2.rID and (R3.mID <> R2.mID or R3.ratingDate <> R2.ratingDate)
) ActiveUser
where Reviewer.rID = ActiveUser.rID
;

## Q9
# Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 
select title, director
from Movie natural join (select director
from Movie
group by director
having count(*)>1)
order by director, title;
## extra challenge
select title, director
from Movie natural join 
(select distinct M1.director as director
from Movie M1, Movie M2
where M1.director=M2.director and M1.mID < M2.mID)
order by director, title;

## Q10
# Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
select title, avgstars
from Movie natural join
(select mID, avgstars
from (select mID, avg(stars) as avgstars
from Rating
group by mID) AR
where avgstars in (select max(avgstars)	
from (select mID, avg(stars) as avgstars
from Rating
group by mID)
));
## slightly better solution found online
select m.title, avg(r.stars) as strs from rating r
join movie m on m.mid = r.mid group by r.mid
having strs = (select max(s.stars) as stars from 
(select mid, avg(stars) as stars from rating
group by mid) as s
);
## another
select title, av
from (select title, avg(stars) as av 
      from rating join movie using(mid) 
      group by mid) a
where av in (select max(av) 
             from (select title, avg(stars) as av 
                   from rating join movie using(mid) 
                   group by mid));

## Q11
# Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
select title, avg(stars) as avg
from Movie join Rating using(mID)
group by mID
having avg in 
(select min(avg)
from (select avg(stars) as avg
from Rating
group by mID));

## Q12
# For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.
select distinct director, title, stars
from (Movie join Rating using(mID)) join
(select director, max(stars) as stars
from Movie join Rating using(mID)
group by director
having director is not NULL) using(director,stars);
## better solution found online!!!!
select distinct director, title, stars
from (movie join rating using (mid)) m
where stars in (select max(stars) 
                from rating join movie using (mid) 
                where m.director = director);











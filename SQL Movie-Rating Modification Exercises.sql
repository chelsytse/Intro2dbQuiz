## Q1
# Add the reviewer Roger Ebert to your database, with an rID of 209.
Insert into Reviewer values(209, "Roger Ebert");

## Q2
# Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL.
Insert into Rating 
select (select rID from Reviewer where name='James Cameron'), mID, 5, NULL
from Movie;

## Q3
# For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.)
update Movie
	set year=year+25
	where mID in (select mID from Rating group by mID having avg(stars)>=4);
	
## Q4
# Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.	
Delete from Rating
where mID in (select mID
	from Movie join Rating using(mID)
	where (year<1970 or year>2000))
	and stars < 4;	

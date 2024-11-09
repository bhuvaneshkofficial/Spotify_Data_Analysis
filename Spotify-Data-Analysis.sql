-- CREATE TABLE -- 
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- EDA --

Select * from spotify;

Select Count(*) From spotify;

Select Count(Distinct artist) From spotify;

Select Distinct album_type From spotify;

Select Max(Duration_min) From spotify;

Select Min(Duration_min) From spotify;

Select * From spotify
Where duration_min = 0;

Delete From spotify
Where duration_min = 0;

Select Distinct channel From spotify;

Select Distinct most_played_on From spotify;	

-- DATA ANALYSIS - EASY LEVEL -- 

-- 1. Retrieve the names of all tracks that have more than 1 billion streams.

Select * from spotify;

Select Distinct track, stream from spotify
Where stream > 1000000000;

-- 2. List all albums along with their respective artists.

Select * from spotify;

Select distinct artist from spotify;

Select distinct album from spotify;

Select album, artist from spotify 
order by artist;

-- 3. Get the total number of comments for tracks where `licensed = TRUE`.

Select Count(comments) from spotify
Where licensed = 'true';

Select Sum(comments) as total_no_comments from spotify
Where licensed = 'true';

-- 4. Find all tracks that belong to the album type `single`.

Select * from spotify;

Select Distinct Album_type from spotify;

Select count(track) from spotify
Where album_type = 'single';

Select track from spotify 
Where album_type = 'single';

-- 5. Count the total number of tracks by each artist.

Select * from spotify;

Select Distinct Artist from spotify;

Select artist, Count(track) as count from spotify
Group by artist
Order by 2 desc;

-- MEDIUM LEVEL -- 

-- 6. Calculate the average danceability of tracks in each album.

Select * from spotify;

Select count( Distinct album) from spotify;

Select count( Distinct track) from spotify;

Select album, avg(danceability) as Avg from spotify
Group by album
order by avg desc;

-- 7. Find the top 5 tracks with the highest energy values.

Select track, energy from spotify
order by 2 desc
limit 5;

-- 8. List all tracks along with their views and likes where `official_video = TRUE`.

Select * from spotify;

Select track,
sum(views) as sum_views, sum(likes) as sum_likes from spotify
Where official_video = 'true'
group by 1
order by 2 desc;

-- 9. For each album, calculate the total views of all associated tracks.

Select * from spotify;

Select album, track,
sum(views) as sum_views from spotify
Group by 1, 2
order by 1;

--10. Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM
(Select 
	track,
	--most_played_on,
	COALESCE(SUM(CASE WHEN  most_played_on = 'Youtube' THEN stream END),0) as streamed_on_youtube,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) as streamed_on_spotify
from spotify
Group by 1) AS TABLE1
WHERE 
	streamed_on_spotify > streamed_on_youtube
	and
	streamed_on_youtube > 0
order by streamed_on_spotify desc;

-- Advanced Level --
-- 11. Find the top 3 most-viewed tracks for each artist using window functions.

Select * from spotify;

with rank_of_artists as 
(Select artist, track, sum(views) as total_viewes,
dense_rank() over(partition by artist order by sum(views) desc) as rank
from spotify
group by 1 , 2
order by 1, 3 desc)
Select * from rank_of_artists 
Where rank <= 3;

-- 12. Write a query to find tracks where the liveness score is above the average.

Select * from spotify;

Select Avg(liveness) from spotify;

Select track, liveness from spotify
Where liveness > (Select Avg(liveness) from spotify)
order by track desc;

-- 13.Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.

Select * from spotify;

With diff_cal
as
(Select 
	album,
	Max(energy) as Highest_energy,
	Min(energy) as Lowest_energy
from spotify
Group by 1
)
Select album, Highest_energy - Lowest_energy as energy_diff from diff_cal 
order by 2 desc;

-- 14. Find tracks where the energy-to-liveness ratio is greater than 1.2.

Select * from spotify;

Select track, energy, liveness
from spotify;

-- Energy-to-liveness ratio = Energy/Liveness
With cte as 
(Select 
	track,
	energy,
	liveness,
	energy/liveness as Eng_to_liv_ratio
from spotify)
Select track, Eng_to_liv_ratio from cte
where Eng_to_liv_ratio > 1.2
order by track;

SELECT 
	track,
	energy / liveness AS energy_to_liveness_ratio
FROM Spotify 
	WHERE energy / liveness > 1.2
order by track;

-- 15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

Select * from spotify;

Select track, likes, views from spotify
order by views;

Select 
	track,
	sum(likes) over (order by views) as Cumulative_likes
from spotify
order by views;

-- Query Optimization --
Explain Analyze -- ET is 5.014 ms and PT is 1.839 ms
Select 
	artist,
	track,
	views
From spotify
Where artist = 'Gorillaz'
	and
	  most_played_on = 'Youtube'
Order by stream Desc
Limit 25;

Create Index artist_index on spotify (artist);

DROP INDEX artist_index;







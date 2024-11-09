# Spotify Data Analysis and Query Optimization P3 - Intermediate Level
Project Category: Intermediate
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![Spotify Logo](https://github.com/bhuvaneshkofficial/Spotify_Data_Analysis/blob/main/Spotify-logo.png)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
-- create table
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
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 4. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

#### Easy Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Medium Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.

### 5. Query Optimization
In advanced stages, the focus shifts to improving query performance. Some optimization strategies include:
- **Indexing**: Adding indexes on frequently queried columns.
- **Query Execution Plan**: Using `EXPLAIN ANALYZE` to review and refine query performance.
  
---

## 15 Practice Questions

### Easy Level
1. Retrieve the names of all tracks that have more than 1 billion streams.
```sql
Select * from spotify;

Select Distinct track, stream from spotify
Where stream > 1000000000;
```
2. List all albums along with their respective artists.
```sql
Select * from spotify;

Select distinct artist from spotify;

Select distinct album from spotify;

Select album, artist from spotify 
order by artist;
```
3. Get the total number of comments for tracks where `licensed = TRUE`.
```sql
Select Count(comments) from spotify
Where licensed = 'true';

Select Sum(comments) as total_no_comments from spotify
Where licensed = 'true';
```
4. Find all tracks that belong to the album type `single`.
```sql
Select * from spotify;

Select Distinct Album_type from spotify;

Select count(track) from spotify
Where album_type = 'single';

Select track from spotify 
Where album_type = 'single';
```
5. Count the total number of tracks by each artist.
```sql
Select * from spotify;

Select Distinct Artist from spotify;

Select artist, Count(track) as count from spotify
Group by artist
Order by 2 desc;
```

### Medium Level
1. Calculate the average danceability of tracks in each album.
```sql
Select * from spotify;

Select count( Distinct album) from spotify;

Select count( Distinct track) from spotify;

Select album, avg(danceability) as Avg from spotify
Group by album
order by avg desc;
```

2. Find the top 5 tracks with the highest energy values.
```sql
Select track, energy from spotify
order by 2 desc
limit 5;
```

3. List all tracks along with their views and likes where `official_video = TRUE`.
```sql
Select * from spotify;

Select track,
sum(views) as sum_views, sum(likes) as sum_likes from spotify
Where official_video = 'true'
group by 1
order by 2 desc;
```

4. For each album, calculate the total views of all associated tracks.
```sql
Select * from spotify;

Select album, track,
sum(views) as sum_views from spotify
Group by 1, 2
order by 1;
```

5. Retrieve the track names that have been streamed on Spotify more than YouTube.
```sql
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
```

### Advanced Level
1. Find the top 3 most-viewed tracks for each artist using window functions.
```sql
Select * from spotify;

with rank_of_artists as 
(Select artist, track, sum(views) as total_viewes,
dense_rank() over(partition by artist order by sum(views) desc) as rank
from spotify
group by 1 , 2
order by 1, 3 desc)
Select * from rank_of_artists 
Where rank <= 3;
```

2. Write a query to find tracks where the liveness score is above the average.
```sql
Select * from spotify;

Select Avg(liveness) from spotify;

Select track, liveness from spotify
Where liveness > (Select Avg(liveness) from spotify)
order by track desc;
```

3. Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.
```sql
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
```
   
4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
```sql
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
```

5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
```sql
Select * from spotify;

Select track, likes, views from spotify
order by views;

Select 
	track,
	sum(likes) over (order by views) as Cumulative_likes
from spotify
order by views;
```


## Query Optimization Technique 

To improve query performance, we carried out the following optimization process:

- **Initial Query Performance Analysis Using `EXPLAIN`**
    - I began by analyzing the performance of a query using the `EXPLAIN` function.
    - The query retrieved tracks based on the `artist` column, and the performance metrics were as follows:
        - Execution time (E.T.): **5.014 ms**
        - Planning time (P.T.): **1.839 ms**
    - Below is the **screenshot** of the `EXPLAIN` result before optimization:
      ![EXPLAIN Before Index](https://github.com/bhuvaneshkofficial/Spotify_Data_Analysis/blob/main/Spotify%20Explain%20Before%20Index.png)

- **Index Creation on the `artist` Column**
    - To optimize the query performance, we created an index on the `artist` column. This ensures faster retrieval of rows where the artist is queried.
    - **SQL command** for creating the index:
      ```sql
      CREATE INDEX idx_artist ON spotify_tracks(artist);
      ```

- **Performance Analysis After Index Creation**
    - After creating the index, we ran the same query again and observed significant improvements in performance:
        - Execution time (E.T.): **0.689 ms**
        - Planning time (P.T.): **0.184 ms**
    - Below is the **screenshot** of the `EXPLAIN` result after index creation:
      ![EXPLAIN After Index](https://github.com/bhuvaneshkofficial/Spotify_Data_Analysis/blob/main/Spotify%20Explain%20After%20Index.png)

- **Graphical Performance Comparison**
    - A graph illustrating the comparison between the initial query execution time and the optimized query execution time after index creation.
    - **Graph view** shows the significant drop in both execution and planning times:
      ![Performance Graph](https://github.com/bhuvaneshkofficial/Spotify_Data_Analysis/blob/main/Graphical%20View%201.png)
      ![Performance Graph](https://github.com/bhuvaneshkofficial/Spotify_Data_Analysis/blob/main/Graphical%20view%202.png)
      ![Performance Graph](https://github.com/bhuvaneshkofficial/Spotify_Data_Analysis/blob/main/Graphical%20View%203.png)

This optimization shows how indexing can drastically reduce query time, improving the overall performance of our database operations in the Spotify project.
---

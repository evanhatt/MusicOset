Use million_songs_df;

SELECT *
FROM songs s;

SET SQL_SAFE_UPDATES = 0;  -- Disable safe mode temporarily

UPDATE songs 
SET artist_name = TRIM(REPLACE(REPLACE(SUBSTRING_INDEX(billboard, ',', -1), '(', ''), ')', ''));  -- Remove parentheses and trim whitespace
  -- Extract the artist name

SET SQL_SAFE_UPDATES = 1;  -- Re-enable safe mode


SELECT artist_name, COUNT(song_name) AS number_of_songs_per_artist
FROM songs s
GROUP BY artist_name;

SELECT song_id, artist_name, song_name, popularity
FROM songs
ORDER BY popularity DESC
LIMIT 20;

SELECT s.song_id, s.artist_name, s.song_name, s.popularity, 
       a.duration_ms, a.key, a.energy, a.instrumentalness, a.mode
FROM songs s
JOIN acoustic_features a ON s.song_id = a.song_id  -- Adjust the column names if they differ
ORDER BY s.popularity DESC
LIMIT 20;


-- I joined by the Acoustic Features table so that I could see the mode, key, duration, 
-- energy, and instrumentalness 
-- I wondered if there were any correlations in the most popular songs. 
SELECT s.song_id, s.artist_name, s.song_name, s.popularity, 
       a.duration_ms, a.key, a.energy, a.instrumentalness, 
       ar.genres, a.tempo
FROM songs s
JOIN acoustic_features a ON s.song_id = a.song_id
JOIN artists ar ON TRIM(LOWER(s.artist_name)) = TRIM(LOWER(ar.name))  -- Ensuring case and space consistency
ORDER BY s.popularity DESC
LIMIT 20;

-- I am not seeing any returned data which means I might be joining the tables based on uncomparable data. 
-- Let's find out. 
SELECT s.artist_name, ar.name
FROM songs s
LEFT JOIN artists ar ON TRIM(LOWER(s.artist_name)) = TRIM(LOWER(ar.name))
WHERE ar.name IS NULL
LIMIT 20;

-- Looks likes Icannot join the artists table with the songs table using artist_name or name

Select *
FROM acoustic_features;



-- Now I want to see the genres of these popular artists songs 
Select * 
FROm artists; 

SELECT name, genres, main_genre
FROM artists
WHERE name IN ('Post Malone & Swae Lee', 'Halsey', 'Billie Eilish', 'Ariana Grande', 
               'Panic! At The Disco', 'Imagine Dragons', 'Post Malone', 
               'Ava Max', 'Travis Scott', 'Ed Sheeran');

-- Looks like the main_genre for these artists is mainly pop with subgenres in pop with only a few 
-- like Imagine Dragons "modern rock' and Post malone 'dfw rap' being the outliers.

-- What about followers? Does the number of followers correspod with the most popular songs or the Pop charts? 
SELECT name, followers, popularity
FROM artists
WHERE name IN ('Post Malone & Swae Lee', 'Halsey', 'Billie Eilish', 'Ariana Grande', 
               'Panic! At The Disco', 'Imagine Dragons', 'Post Malone', 
               'Ava Max', 'Travis Scott', 'Ed Sheeran')
ORDER BY followers DESC;  -- Order by followers in descending order

-- Interesting, more followers does not necessarily make you the most popular
--  or make your song the most popular. 


-- Now I would like to figure out Weeks_on_ Charts for the popular artists and songs and albums 

SELECT ac.rank_score, ac.weeks_on_chart,  
       a.name, a.artists, a.total_tracks, a.popularity
FROM album_chart ac
JOIN albums a ON ac.album_id = a.album_id  -- Corrected join condition
ORDER BY a.popularity DESC  -- Order by albums' popularity
LIMIT 20;


/* We want to reward the user who has been around the longest, Find the 5 oldest users. */
select * from users order by created_at limit 5 ;

/* To understand when to run the ad campaign, figure out the day of the  week most users register on? */
select dayname(created_at) as NameOfDay, count(*) as Total_Register  from users group by   dayname(created_at) 
order by Total_Register desc   ;   

/* To target inactive users in an email ad campaign, find the users who have never posted a photo.*/
select users.id, users.username, photos.id as PhotoId, photos.image_url from users left join photos on users.id = photos.user_id 
where users.id not in ( select photos.user_id from photos ) ;

/* 5. Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?*/
select users.username, likes.user_id, likes.photo_id, count(*) as Total_Likes from users inner join likes 
on users.id = likes.user_id inner join photos on photos.id = likes.photo_id group by likes.photo_id order by 
Total_Likes desc limit 1 ;

/* 6. The investors want to know how many times does the average user post.*/
select users.username, photos.image_url, count(photos.image_url) as total_image_posted_by_user 
from users inner join photos on users.id = photos.user_id group by users.id order by photos.image_url desc ;

/* A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.*/
select tags.id, tags.tag_name, count(tags.tag_name) as Tag_Used_toal_times from tags inner join 
photo_tags on tags.id = photo_tags.tag_id group by photo_tags.tag_id order by Tag_Used_toal_times desc limit 5 ;

/* To find out if there are bots, find users who have liked every single photo on the site.*/
select users.username, likes.user_id, likes.photo_id, count(likes.user_id) as Total_liked_photo_Count from 
likes inner join users on users.id = likes.user_id group by likes.user_id having  Total_liked_photo_Count = 
(select count(distinct photos.id) from photos) ;

/* To know who the celebrities are, find users who have never commented on a photo.*/
select users.username, users.id from users left join comments on users.id = comments.user_id where 
users.id not in ( select distinct comments.user_id from comments ) ;

/* Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo*/

select tableA.total_A as 'Number Of Users who never commented on any photo',  tableB.total_B as 'Number of Users who commented on every photos'
from
(
select count(*) as total_A from
 
(select users.id,  users.username  from users left join comments on users.id = comments.user_id where users.id 
not in ( select distinct comments.user_id from comments )) 
 
as total_number_of_users_without_comments
) as tableA
    
              JOIN
    
(
select count(*) as total_B from
 
( select users.username, comments.user_id, comments.photo_id, count(comments.user_id) as 
Total_commented_on_photo_Count, comments.comment_text from comments inner join users on 
users.id = comments.user_id group by comments.user_id having 
Total_commented_on_photo_Count = (select count(distinct photos.id) from photos) )
 
as total_number_users_commented_on_every_photos
 
) as tableB;






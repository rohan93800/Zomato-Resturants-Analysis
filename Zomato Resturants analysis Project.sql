#1. Build a country Map Table 
CREATE TABLE CountryMap (
						CountryCode int primary key ,
						CountryName VARCHAR(100) )
                        ;
 insert into countryMap values (1 ,"india" ), (14,"australia") , (94,"Indonesia"),
								(30,"Brazil")  , (37,"Canada")  , (148,"New Zealand")  , (162,"philippines")                      
								, (166,"Qatar")  , (184,"Singapore")  , (189,"South Afirca")  , (191,"Sri Lanka")  ,
								(208,"Turkey")  , (214,"United Arab Emirates")  , (215,"United Kingdom")  , (216,"United Staes of America") ;
 select * from countrymap;                               
----------------------------------------------------------------------------------------------------------------
#2. Build a Calendar Table using the Column Datekey
select year(Datekey_Opening) years,
month(Datekey_Opening)  months,
day(datekey_opening) day ,
monthname(Datekey_Opening) monthname,
concat(year(Datekey_Opening),'-',monthname(Datekey_Opening)) yearmonth, 
weekday(Datekey_Opening) weekday,
dayname(datekey_opening)dayname, 

case when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q1'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q2'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q3'
else  'Q4' end as quarters,

case 
when monthname(datekey_opening)='April'then'FM4'
when monthname(datekey_opening)='May' then 'FM5'
when monthname(datekey_opening)='June' then 'FM6'
when monthname(datekey_opening)='July' then 'FM7'
when monthname(datekey_opening)='August' then 'FM8'
when monthname(datekey_opening)='September' then 'FM9'
when monthname(datekey_opening)='October' then 'FM10'
when monthname(datekey_opening)='November' then 'FM11'
when monthname(datekey_opening)='December'then 'FM12'
when monthname(datekey_opening)='January' then 'FM1'
when monthname(datekey_opening)='February' then 'FM2'
when monthname(datekey_opening)='March' then 'FM3'
end Financial_months,

case 
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'FQ1'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'FQ2'
when monthname(datekey_opening) in ('October' ,'November' ,'December' )then 'FQ3'
else  'FQ4' end as financial_quarters
from resturants;
----------------------------------------------------------------------------------------------------------------

#3. Numbers of Resturants based on  Country 
select c.CountryName ,count(restaurantid) as no_restaurants from resturants r
join countrymap c on r.country_code=c.CountryCode
group by c.CountryName;

-- Numbers of Resturants based on  City
select  r.city ,count(restaurantid) as no_restaurants from resturants r
join countrymap c on r.country_code=c.CountryCode
group by r.city 
limit 10;
----------------------------------------------------------------------------------------------------------------

#4.Numbers of Resturants opening based on Year , , 
select year(datekey_opening)as years, count(restaurantid) as no_restaurants from resturants 
group by year(datekey_opening)
order by years ;

#Numbers of Resturants opening based on Month
 select monthname(datekey_opening)as Month_name, count(restaurantid) as no_restaurants from resturants 
group by monthname(datekey_opening)
order by no_restaurants desc ;

#.Numbers of Resturants opening based on  Quarter
select quarter(datekey_opening)as quarters, count(restaurantid) as no_restaurants from resturants 
group by quarter(datekey_opening)
order by quarters ;
 
 ----------------------------------------------------------------------------------------------------------------
#5. Count of Resturants based on Average Ratings
select case 
			when  Rating <=2 then "1-2" 
			when rating >2 and rating <=3 then "2.1-3"
			when rating >3 and rating <=4 then "3.1-4"
			when rating <=5  then "4.1-5"
			end as avg_rating,
            
count(restaurantid) as no_restaurants from resturants
group by Avg_rating
order by avg_rating ;

----------------------------------------------------------------------------------------------------------------
#6. Creating buckets based on  Price range  of reasonable size and  the finding no of  resturants falls in each buckets
select case
			when price_range =1 then "0-2000"
			when price_range =2 then "2001-5000"
			when price_range =3 then "5001-8000"
			when price_range =4 then  ">10000"
			end as buckets,
            count(restaurantid) as no_restaurants
			from resturants 
group by buckets 
order by  no_restaurants desc ;
-----------------------------------------------------------------------------------------------------------------------
#7.Percentage of Resturants based on "Has_Table_booking"
select Has_Table_booking ,count(restaurantid) as No_restaurants ,
concat(round(count(has_table_booking)/(select count(has_table_booking) from resturants)*100 , 2),"%") as  percentage 
from resturants
group by Has_Table_booking
order by percentage ;


-----------------------------------------------------------------------------------------------------------------------
#8.Percentage of Resturants based on "Has_Online_delivery"
select has_online_delivery, count(restaurantid) as No_Restaurants ,
concat(round(count(has_online_delivery)/(select count(has_online_delivery ) from resturants)*100 , 2),"%") percentage
from resturants
group by Has_Online_delivery
order by percentage ;

-----------------------------------------------------------------------------------------------------------------------
#9 No of resturants by most popular cuisines
SELECT Cuisines, COUNT(*) AS restaurant_count
FROM resturants
GROUP BY Cuisines
ORDER BY restaurant_count DESC
LIMIT 10;

----------------------------------------------------------------------------------------------------------------------
-- 10 top 10 cities with higest no of restaurants
SELECT City, COUNT(*) AS total_restaurants
FROM resturants
GROUP BY City
ORDER BY total_restaurants DESC
LIMIT 10;
	 
----------------------------------------------------------------------------------------------------------------------
-- 11 highest rated top 10 restaurants  country wise 
select c.countryname, max(r.restaurantname) Restaurants_name, max(r.rating ) rating  from resturants r
join countrymap c on r.country_code=c.CountryCode
group by c.CountryName 
having rating>4.8
;

----------------------------------------------------------------------------------------------------------------------
-- 14  Top 5 Most Popular Cuisines by Votes
select sum(votes) total_votes ,Cuisines from resturants 
group by Cuisines
order by total_votes desc 
limit 5
;

----------------------------------------------------------------------------------------------------------------------
 -- 15 Createing  a Star Rating Bucket 
SELECT 
  RestaurantName,City,rating,
  CASE
    WHEN rating >= 4.5 THEN '★★★★★'
    WHEN rating >= 4.0 THEN '★★★★'
    WHEN rating >= 3.0 THEN '★★★'
    WHEN rating >= 2.0 THEN '★★'
    ELSE '★'
  END AS star_rating
FROM resturants
order by rating desc
 ;
 
----------------------------------------------------------------------------------------------------------------------
-- 16  first 5 opening  resturants name  by date 
 select restaurantname ,datekey_opening from  
						(select * ,row_number() over(order by datekey_opening) 
                        as First_opening_resturants
						from resturants )  x 
where First_opening_resturants <6 ;  

 # recent  openings resturants by date
select restaurantname  ,last_value(Datekey_Opening) 
over(order by Datekey_Opening desc )as recent_opening_date from resturants
limit 5;
----------------------------------------------------------------------------------------------------------------------


create database co2;
use co2;
-- import data to the workbench from the dataset
select * from ce;
-- create duplicate table and insert the values in case of  data loss during data cleaning
create table energy like ce;  -- use the duplicate table for data cleaning
insert into energy select * from ce;
 select * from energy;
 -- add a new column as an unique index to insert country code for the countries
 alter table energy add column iso_code varchar(20) first;
 -- insert country code for each countries(other sheet)
  select * from energy where iso_code = "others"; -- named the places others which are not country
  
-- deleting the States/Province/Regions/cities/other place which are not country but entered as a country in the dataset(4800 rows)
delete from energy where iso_code = "others";
select * from energy;
-- change the counrty name (as per powerbi Requirment)
update energy 
set country = case
	when country = "Burma" then "Myanmar"
    when country = "United States" then "United States of America"
    else country -- to keep the other rows unchanged
    end ;
-- chech the result 
select distinct(country) from energy;
-- create a continent column for the corresponding countries 
alter table energy add column Continent varchar(30) after country ;
-- insert continents to the continent column 
UPDATE energy
SET Continent = CASE 
    WHEN Country IN ('Algeria', 'Angola', 'Benin', 'Botswana', 'Burkina Faso', 'Burundi', 
                     'Cabo Verde', 'Cameroon', 'Central African Republic', 'Chad', 'Comoros', 
                     'Djibouti', 'Egypt', 'Equatorial Guinea', 'Eritrea', 'Eswatini', 'Ethiopia', 
                     'Gabon', 'Gambia', 'Ghana', 'Guinea', 'Guinea-Bissau', 'Ivory Coast', 'Kenya', 
                     'Lesotho', 'Liberia', 'Libya', 'Madagascar', 'Malawi', 'Mali', 'Mauritania', 
                     'Mauritius', 'Morocco', 'Mozambique', 'Namibia', 'Niger', 'Nigeria', 'Rwanda', 
                     'Sao Tome and Principe', 'Senegal', 'Seychelles', 'Sierra Leone', 'Somalia', 
                     'South Africa', 'South Sudan', 'Sudan', 'Tanzania', 'Togo', 'Tunisia', 'Uganda', 
                     'Zambia', 'Zimbabwe') 
    THEN 'Africa'
    WHEN Country IN ('Afghanistan', 'Armenia', 'Azerbaijan', 'Bahrain', 'Bangladesh', 'Bhutan', 
                     'Brunei', 'Myanmar', 'Cambodia', 'China', 'Cyprus', 'Georgia', 'India', 
                     'Indonesia', 'Iran', 'Iraq', 'Israel', 'Japan', 'Jordan', 'Kazakhstan', 
                     'Kuwait', 'Kyrgyzstan', 'Laos', 'Lebanon', 'Malaysia', 'Maldives', 'Mongolia', 
                     'Nepal', 'North Korea', 'Oman', 'Pakistan', 'Palestine', 'Philippines', 'Qatar', 
                     'Saudi Arabia', 'Singapore', 'South Korea', 'Sri Lanka', 'Syria', 'Taiwan', 
                     'Tajikistan', 'Thailand', 'Timor-Leste', 'Turkey', 'Turkmenistan', 'United Arab Emirates', 
                     'Uzbekistan', 'Vietnam', 'Yemen') 
    THEN 'Asia'
    WHEN Country IN ('Albania', 'Austria', 'Belarus', 'Belgium', 'Bosnia and Herzegovina', 
                     'Bulgaria', 'Croatia', 'Czech Republic', 'Denmark', 'Estonia', 'Finland', 'France', 
                     'Germany', 'Greece', 'Hungary', 'Iceland', 'Ireland', 'Italy', 'Latvia', 
                     'Lithuania', 'Luxembourg', 'Malta', 'Moldova', 'Montenegro', 
                     'Netherlands', 'North Macedonia', 'Norway', 'Poland', 'Portugal', 'Romania', 
                     'Russia', 'Serbia', 'Slovakia', 'Slovenia', 'Spain', 'Sweden', 
                     'Switzerland', 'Ukraine', 'United Kingdom') 
    THEN 'Europe'
    WHEN Country IN ('Antigua and Barbuda', 'Bahamas', 'Barbados', 'Belize', 'Canada', 'Costa Rica', 
                     'Cuba', 'Dominica', 'Dominican Republic', 'El Salvador', 'Grenada', 'Guatemala', 
                     'Haiti', 'Honduras', 'Jamaica', 'Mexico', 'Nicaragua', 'Panama', 'Puerto Rico', 
                     'Saint Kitts and Nevis', 'Saint Lucia', 'Trinidad and Tobago', 'United States of America') 
    THEN 'North America'
    WHEN Country IN ('Argentina', 'Bolivia', 'Brazil', 'Chile', 'Colombia', 'Ecuador', 'Guyana', 
                     'Paraguay', 'Peru', 'Suriname', 'Uruguay', 'Venezuela') 
    THEN 'South America'
    WHEN Country IN ('Australia', 'Fiji', 'Kiribati', 'Marshall Islands', 'Micronesia', 'Nauru', 
                     'New Zealand', 'Palau', 'Papua New Guinea', 'Samoa', 'Solomon Islands', 'Tonga', 
                     'Tuvalu', 'Vanuatu') 
    THEN 'Oceania'
    ELSE 'Others'
END;

-- Query to import the required columns to PowerBI
select iso_code, Country, Continent, year, energy_type as Emission_Type,
sum(co2_emission) as Total_Emission
from energy
where CO2_emission is not null -- to avoide the null values
group by iso_code,year,country, energy_type, Continent;
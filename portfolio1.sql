select name,milliseconds
from track 
where milliseconds > (select avg(milliseconds) as avg_mill from track)
order by milliseconds desc
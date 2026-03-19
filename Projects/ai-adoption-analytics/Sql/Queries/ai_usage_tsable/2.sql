/*Question 2
What is the average number of prompts per session?*/


SELECT 
      ROUND(AVG(prompts_count),2) as AVG_Prompts_per_session
FROM ai_usage;

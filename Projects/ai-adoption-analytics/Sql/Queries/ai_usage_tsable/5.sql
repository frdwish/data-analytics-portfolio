/*Which AI tool generates the most prompts overall?*/


SELECT tool_used AS AI_tool,
SUM(prompts_count) as most_prompt
FROM ai_usage
GROUP BY tool_used
ORDER BY most_prompt DESC;


SELECT tool_used,
SUM(prompts_count) AS total_prompts
FROM ai_usage
GROUP BY tool_used
ORDER BY total_prompts DESC;
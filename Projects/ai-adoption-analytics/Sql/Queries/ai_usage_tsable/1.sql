/*Which AI tool is used the most?*/


SELECT tool_used, COUNT(*) AS usage_count
FROM ai_usage
GROUP BY tool_used
ORDER BY usage_count DESC;

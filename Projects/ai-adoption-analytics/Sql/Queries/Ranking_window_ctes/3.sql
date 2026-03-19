--For each employee, which task type do they perform most efficiently?(Partition + Ranking)



WITH task_efficiency AS (
    SELECT 
        employee_id,
        task_type,
        ROUND(AVG(estimated_time_min - actual_time_min),2) AS avg_time_saved
    FROM tasks
    GROUP BY employee_id, task_type
)

SELECT *
FROM (
    SELECT *,
    RANK() OVER (PARTITION BY employee_id ORDER BY avg_time_saved DESC) AS rank
    FROM task_efficiency
) ranked
WHERE rank = 1;


/*employee_id.    task_type.    avg_time_saved  rank

1	"Code Review"	39.50	1
2	"Research"	    30.00	1
3	"Data Analysis"	38.33	1
4	"Code Review"	28.33	1
5	"Code Review"	42.00	1
6	"Documentation"	32.00	1
7	"Code Review"	40.00	1
8	"Bug Fixing"	41.00	1
9	"Data Analysis"	19.00	1
10	"Bug Fixing"	30.60	1
11	"Research"	    22.00	1
12	"Data Analysis"	35.33	1
13	"Data Analysis"	31.50	1
14	"Code Review"	40.00	1
15	"Bug Fixing"	33.00	1
16	"Research"	    31.50	1
17	"Code Review"	34.00	1
18	"Data Analysis"	30.00	1
19	"Code Review"	34.50	1
20	"Documentation"	37.00	1
21	"Bug Fixing"	35.00	1
22	"Research"	    43.80	1
23	"Research"	    26.00	1
24	"Research"	    28.33	1
25	"Bug Fixing"	26.33	1
26	"Research"	    31.33	1
27	"Research"	    35.00	1
28	"Bug Fixing"	28.00	1
29	"Documentation"	37.00	1
30	"Bug Fixing"	32.33	1
31	"Client Communication"	29.33	1
32	"Research"	    40.33	1
33	"Planning"	    19.00	1
34	"Planning"	    37.00	1
35	"Presentation"	28.00	1
36	"Planning"	    32.00	1
37	"Research"	    19.00	1
38	"Presentation"	40.50	1
39	"Client Communication"	31.00	1
40	"Client Communication"	28.67	1
41	"Report Writing"	23.00	1
42	"Research"	    19.50	1
43	"Presentation"	36.50	1
44	"Planning"	    29.00	1
45	"Client Communication"	35.00	1
46	"Report Writing"	31.00	1
47	"Presentation"	33.00	1
48	"Presentation"	34.50	1
49	"Research"	    36.00	1
50	"Planning"	    36.00	1
51	"Report Writing"	34.00	1
52	"Data Analysis"	    28.25	1
53	"Report Writing"	40.50	1
54	"Report Writing"	30.00	1
55	"Data Entry"	    30.00	1
56	"Report Writing"	13.50	1
57	"Report Writing"	23.00	1
58	"Data Entry"	    39.00	1
59	"Report Writing"	45.00	1
60	"Report Writing"	11.00	1
61	"Data Analysis"	    43.00	1
62	"Data Entry"	    16.00	1
63	"Report Writing"	34.00	1
64	"Data Analysis"	    26.00	1
65	"Report Writing"	25.00	1
66	"Email Drafting"	17.25	1
67	"Presentation"	    32.25	1
68	"Email Drafting"	35.50	1
69	"Meeting Prep"	    35.00	1
70	"Client Communication"	23.33	1
71	"Client Communication"	25.00	1
72	"Meeting Prep"	34.50	1
73	"Client Communication"	42.00	1
74	"Report Writing"	18.50	1
75	"Report Writing"	15.00	1
76	"Client Communication"	26.00	1
77	"Presentation"	22.00	1
78	"Meeting Prep"	21.33	1
79	"Meeting Prep"	21.40	1
80	"Client Communication"	36.00	1
81	"Documentation"	20.67	1
82	"Meeting Prep"	18.00	1
83	"Email Drafting"	32.50	1
84	"Meeting Prep"	29.00	1
85	"Email Drafting"	20.50	1
86	"Email Drafting"	15.75	1
87	"Planning"	45.00	1
88	"Email Drafting"	5.33	1
89	"Planning"	25.00	1
90	"Planning"	20.50	1
91	"Email Drafting"	20.50	1
92	"Research"	28.00	1
93	"Client Communication"	32.75	1
94	"Presentation"	18.00	1
95	"Email Drafting"	3.67	1
96	"Email Drafting"	31.33	1
97	"Research"	14.00	1
98	"Presentation"	36.00	1
99	"Client Communication"	25.33	1
100	"Presentation"	28.60	1
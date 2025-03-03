-- Understanding the sleep variables, their types from the table STUDY_METRIC_SLEEP. 

SELECT * FROM ROADMAP.STUDY_METRIC_SLEEP;

SELECT * FROM ROADMAP.sleep_summary;

SELECT DISTINCT(STUDY_METRIC_TYP_ID) FROM ROADMAP.STUDY_METRIC_SLEEP;

SELECT DISTINCT(sleep_data_type) FROM ROADMAP.study_metric_sleep

WITH cte AS (
  SELECT 
    PRTCPT_DVC_ID,
    STUDY_METRIC_SLEEP_DATE,
    STUDY_METRIC_TYP_ID,
    STUDY_METRIC_SLEEP_VALUE
  FROM ROADMAP.STUDY_METRIC_SLEEP
  WHERE STUDY_METRIC_TYP_ID IN (1, 19)
)
SELECT 
  a.PRTCPT_DVC_ID,
  a.STUDY_METRIC_SLEEP_DATE,
  MAX(CASE WHEN a.STUDY_METRIC_TYP_ID = 1 THEN a.STUDY_METRIC_SLEEP_VALUE END) AS TYPE_1_VALUE,
  MAX(CASE WHEN b.STUDY_METRIC_TYP_ID = 19 THEN b.STUDY_METRIC_SLEEP_VALUE END) AS TYPE_19_VALUE
FROM cte a
LEFT JOIN cte b ON 
  a.PRTCPT_DVC_ID = b.PRTCPT_DVC_ID AND 
  a.STUDY_METRIC_SLEEP_DATE = b.STUDY_METRIC_SLEEP_DATE AND 
  b.STUDY_METRIC_TYP_ID = 19
WHERE a.STUDY_METRIC_TYP_ID = 1
GROUP BY a.PRTCPT_DVC_ID, a.STUDY_METRIC_SLEEP_DATE
ORDER BY a.PRTCPT_DVC_ID, a.STUDY_METRIC_SLEEP_DATE;

/*-------------------------------------------------------------------------*/
WITH cte AS (
  SELECT 
    PRTCPT_DVC_ID,
    STUDY_METRIC_SLEEP_DATE,
    STUDY_METRIC_TYP_ID,
    TO_NUMBER(STUDY_METRIC_SLEEP_VALUE) AS STUDY_METRIC_SLEEP_VALUE
  FROM ROADMAP.STUDY_METRIC_SLEEP
  WHERE STUDY_METRIC_TYP_ID IN (1, 19)
),
comparison AS (
  SELECT 
    a.PRTCPT_DVC_ID,
    a.STUDY_METRIC_SLEEP_DATE,
    MAX(CASE WHEN a.STUDY_METRIC_TYP_ID = 1 THEN a.STUDY_METRIC_SLEEP_VALUE END) AS TYPE_1_VALUE,
    MAX(CASE WHEN b.STUDY_METRIC_TYP_ID = 19 THEN b.STUDY_METRIC_SLEEP_VALUE END) AS TYPE_19_VALUE
  FROM cte a
  LEFT JOIN cte b ON 
    a.PRTCPT_DVC_ID = b.PRTCPT_DVC_ID AND 
    a.STUDY_METRIC_SLEEP_DATE = b.STUDY_METRIC_SLEEP_DATE AND 
    b.STUDY_METRIC_TYP_ID = 19
  WHERE a.STUDY_METRIC_TYP_ID = 1
  GROUP BY a.PRTCPT_DVC_ID, a.STUDY_METRIC_SLEEP_DATE
)
SELECT 
  PRTCPT_DVC_ID,
  STUDY_METRIC_SLEEP_DATE,
  TYPE_1_VALUE,
  TYPE_19_VALUE,
  (TYPE_1_VALUE - TYPE_19_VALUE) AS DIFFERENCE,
  CASE 
    WHEN (TYPE_1_VALUE - TYPE_19_VALUE) != 0 THEN 1 
    ELSE 0 
  END AS IS_NON_ZERO_DIFF
FROM comparison
WHERE TYPE_1_VALUE IS NOT NULL AND TYPE_19_VALUE IS NOT NULL
ORDER BY PRTCPT_DVC_ID, STUDY_METRIC_SLEEP_DATE;

/*--------------------------------------------------------------------------------------------------------------------*/

SELECT 
    STUDY_METRIC_TYP_ID,
    LISTAGG(DISTINCT sleep_data_type, ', ') WITHIN GROUP (ORDER BY sleep_data_type) AS sleep_data_types
FROM 
    ROADMAP.STUDY_METRIC_SLEEP
GROUP BY 
    STUDY_METRIC_TYP_ID
ORDER BY 
    STUDY_METRIC_TYP_ID;

/*--------------------------------------------------------------------------------------------------------------------*/
SELECT 
    NVL(sleep_data_type, 'NULL') AS sleep_data_type,
    LISTAGG(DISTINCT STUDY_METRIC_TYP_ID, ', ') WITHIN GROUP (ORDER BY STUDY_METRIC_TYP_ID) AS STUDY_METRIC_TYP_IDs
FROM 
    ROADMAP.STUDY_METRIC_SLEEP
GROUP BY 
    sleep_data_type
ORDER BY 
    sleep_data_type;

-- Rank the best successful run for each experiment using a task-specific
-- primary metric. Demonstrates CTEs, joins, CASE logic, and window functions.

WITH scored_runs AS (
    SELECT
        p.name AS project_name,
        e.name AS experiment_name,
        r.run_name,
        r.model_name,
        r.framework,
        m.metric_name,
        m.metric_value,
        ROW_NUMBER() OVER (
            PARTITION BY e.experiment_id
            ORDER BY
                CASE
                    WHEN m.metric_name IN ('bleu_4', 'accuracy', 'mean_iou') THEN m.metric_value
                    WHEN m.metric_name = 'path_cost' THEN -m.metric_value
                    ELSE NULL
                END DESC
        ) AS metric_rank
    FROM projects p
    JOIN experiments e ON e.project_id = p.project_id
    JOIN runs r ON r.experiment_id = e.experiment_id
    JOIN metrics m ON m.run_id = r.run_id
    WHERE r.run_status = 'succeeded'
      AND m.split IN ('validation', 'test')
      AND m.metric_name IN ('bleu_4', 'accuracy', 'mean_iou', 'path_cost')
)
SELECT
    project_name,
    experiment_name,
    run_name,
    model_name,
    framework,
    metric_name,
    metric_value
FROM scored_runs
WHERE metric_rank = 1
ORDER BY project_name, experiment_name;

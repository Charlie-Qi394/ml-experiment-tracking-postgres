-- Inspect failed or cancelled model runs with their hyperparameters.
-- Useful for debugging and experiment governance.

SELECT
    p.name AS project_name,
    e.name AS experiment_name,
    r.run_name,
    r.model_name,
    r.run_status,
    r.started_at,
    r.completed_at,
    r.notes,
    JSONB_OBJECT_AGG(h.param_name, h.param_value ORDER BY h.param_name) AS hyperparameters
FROM projects p
JOIN experiments e ON e.project_id = p.project_id
JOIN runs r ON r.experiment_id = e.experiment_id
LEFT JOIN hyperparameters h ON h.run_id = r.run_id
WHERE r.run_status IN ('failed', 'cancelled')
GROUP BY
    p.name,
    e.name,
    r.run_name,
    r.model_name,
    r.run_status,
    r.started_at,
    r.completed_at,
    r.notes
ORDER BY r.started_at DESC;

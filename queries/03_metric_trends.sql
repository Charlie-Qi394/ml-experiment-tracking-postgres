-- Return metric history for successful runs.
-- The synthetic seed data records final metrics only, but this query supports
-- multi-step training logs when more rows are added.

SELECT
    e.name AS experiment_name,
    r.run_name,
    m.metric_name,
    m.split,
    m.step,
    m.metric_value,
    m.metric_value - LAG(m.metric_value) OVER (
        PARTITION BY r.run_id, m.metric_name, m.split
        ORDER BY m.step
    ) AS change_from_previous_step
FROM experiments e
JOIN runs r ON r.experiment_id = e.experiment_id
JOIN metrics m ON m.run_id = r.run_id
WHERE r.run_status = 'succeeded'
ORDER BY e.name, r.run_name, m.metric_name, m.split, m.step;

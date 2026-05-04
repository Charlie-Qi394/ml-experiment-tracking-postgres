-- Compare model families across experiments using aggregate metrics.
-- Demonstrates grouping, filtered joins, and derived duration calculations.

SELECT
    p.domain,
    e.name AS experiment_name,
    r.model_family,
    COUNT(*) AS run_count,
    COUNT(*) FILTER (WHERE r.run_status = 'succeeded') AS succeeded_runs,
    COUNT(*) FILTER (WHERE r.run_status = 'failed') AS failed_runs,
    ROUND(AVG(EXTRACT(EPOCH FROM (r.completed_at - r.started_at)) / 60), 2) AS avg_runtime_minutes,
    ROUND(AVG(m.metric_value) FILTER (WHERE m.metric_name IN ('accuracy', 'mean_iou', 'bleu_4')), 4) AS avg_quality_metric
FROM projects p
JOIN experiments e ON e.project_id = p.project_id
JOIN runs r ON r.experiment_id = e.experiment_id
LEFT JOIN metrics m ON m.run_id = r.run_id
GROUP BY p.domain, e.name, r.model_family
ORDER BY p.domain, e.name, r.model_family;

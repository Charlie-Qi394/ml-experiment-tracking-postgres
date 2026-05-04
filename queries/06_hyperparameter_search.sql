-- Compare selected hyperparameters against final quality metrics.
-- Demonstrates pivot-style aggregation using conditional MAX expressions.

SELECT
    e.name AS experiment_name,
    r.run_name,
    r.model_name,
    MAX(h.param_value) FILTER (WHERE h.param_name = 'learning_rate') AS learning_rate,
    MAX(h.param_value) FILTER (WHERE h.param_name = 'batch_size') AS batch_size,
    MAX(h.param_value) FILTER (WHERE h.param_name = 'optimizer') AS optimizer,
    MAX(m.metric_value) FILTER (WHERE m.metric_name IN ('accuracy', 'mean_iou', 'bleu_4')) AS final_quality_metric
FROM experiments e
JOIN runs r ON r.experiment_id = e.experiment_id
LEFT JOIN hyperparameters h ON h.run_id = r.run_id
LEFT JOIN metrics m ON m.run_id = r.run_id AND m.split IN ('validation', 'test')
WHERE r.run_status = 'succeeded'
GROUP BY e.name, r.run_name, r.model_name
ORDER BY e.name, final_quality_metric DESC NULLS LAST;

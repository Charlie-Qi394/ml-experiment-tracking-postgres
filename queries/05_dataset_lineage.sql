-- Show dataset-to-experiment-to-run lineage for reproducibility.

SELECT
    p.name AS project_name,
    d.name AS dataset_name,
    d.version AS dataset_version,
    d.source_type,
    e.name AS experiment_name,
    r.run_name,
    r.model_name,
    r.git_commit,
    a.artifact_type,
    a.artifact_name,
    a.uri
FROM projects p
JOIN datasets d ON d.project_id = p.project_id
JOIN experiments e ON e.dataset_id = d.dataset_id
JOIN runs r ON r.experiment_id = e.experiment_id
LEFT JOIN artifacts a ON a.run_id = r.run_id
WHERE r.run_status = 'succeeded'
ORDER BY p.name, d.name, e.name, r.run_name, a.artifact_type;

-- Find runs by tag, showing many-to-many relationships.

SELECT
    t.tag_name,
    p.name AS project_name,
    e.name AS experiment_name,
    r.run_name,
    r.model_family,
    r.run_status
FROM tags t
JOIN run_tags rt ON rt.tag_id = t.tag_id
JOIN runs r ON r.run_id = rt.run_id
JOIN experiments e ON e.experiment_id = r.experiment_id
JOIN projects p ON p.project_id = e.project_id
WHERE t.tag_name IN ('best-model', 'failed-run', 'nlp', 'computer-vision')
ORDER BY t.tag_name, project_name, experiment_name, run_name;

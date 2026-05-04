-- Synthetic seed data for the ML experiment tracking database.
-- The examples are inspired by common AI/ML portfolio workflows and do not
-- include coursework datasets, private data, or restricted material.

INSERT INTO projects (name, domain, description) VALUES
('Seq2Seq Recipe Generation', 'NLP', 'Ingredient-to-recipe text generation using LSTM encoder-decoder models.'),
('Computer Vision Classification and Segmentation', 'Computer Vision', 'Image classification and semantic segmentation experiments.'),
('Graph Search Algorithm Evaluation', 'AI Fundamentals', 'Comparison of graph-search strategies over weighted graph inputs.');

INSERT INTO datasets (project_id, name, version, source_type, row_count, feature_count, target_name, license_note)
SELECT project_id, 'synthetic_recipe_pairs', 'v1.0', 'synthetic', 12000, 2, 'recipe_steps', 'Synthetic demo records for portfolio SQL examples.'
FROM projects WHERE name = 'Seq2Seq Recipe Generation';

INSERT INTO datasets (project_id, name, version, source_type, row_count, feature_count, target_name, license_note)
SELECT project_id, 'cifar100_summary_features', 'v1.0', 'public', 60000, 3072, 'class_label', 'Public dataset reference; raw images are not redistributed.'
FROM projects WHERE name = 'Computer Vision Classification and Segmentation';

INSERT INTO datasets (project_id, name, version, source_type, row_count, feature_count, target_name, license_note)
SELECT project_id, 'pascal_voc_mask_summary', 'v1.0', 'public', 2913, 3, 'segmentation_mask', 'Public dataset reference; raw images and masks are not redistributed.'
FROM projects WHERE name = 'Computer Vision Classification and Segmentation';

INSERT INTO datasets (project_id, name, version, source_type, row_count, feature_count, target_name, license_note)
SELECT project_id, 'synthetic_weighted_graphs', 'v1.0', 'synthetic', 80, 5, 'shortest_path_cost', 'Synthetic graph examples for search algorithm comparison.'
FROM projects WHERE name = 'Graph Search Algorithm Evaluation';

INSERT INTO experiments (project_id, dataset_id, name, objective, owner, status, started_at, completed_at)
SELECT p.project_id, d.dataset_id, 'attention_comparison', 'Compare baseline Seq2Seq and attention-based decoder performance.', 'Charlie Qi', 'completed', '2026-03-01 09:00+11', '2026-03-10 18:00+11'
FROM projects p JOIN datasets d ON d.project_id = p.project_id
WHERE p.name = 'Seq2Seq Recipe Generation' AND d.name = 'synthetic_recipe_pairs';

INSERT INTO experiments (project_id, dataset_id, name, objective, owner, status, started_at, completed_at)
SELECT p.project_id, d.dataset_id, 'cifar100_cnn_comparison', 'Compare baseline and tuned CNN models for image classification.', 'Charlie Qi', 'completed', '2026-03-15 10:00+11', '2026-03-22 17:00+11'
FROM projects p JOIN datasets d ON d.project_id = p.project_id
WHERE p.name = 'Computer Vision Classification and Segmentation' AND d.name = 'cifar100_summary_features';

INSERT INTO experiments (project_id, dataset_id, name, objective, owner, status, started_at, completed_at)
SELECT p.project_id, d.dataset_id, 'voc_segmentation_architectures', 'Compare FCN, U-Net, and FPN-style segmentation models.', 'Charlie Qi', 'completed', '2026-03-25 10:00+11', '2026-04-05 16:00+11'
FROM projects p JOIN datasets d ON d.project_id = p.project_id
WHERE p.name = 'Computer Vision Classification and Segmentation' AND d.name = 'pascal_voc_mask_summary';

INSERT INTO experiments (project_id, dataset_id, name, objective, owner, status, started_at, completed_at)
SELECT p.project_id, d.dataset_id, 'search_strategy_comparison', 'Compare BFS, DFS, Greedy Best-First Search, and A* over graph examples.', 'Charlie Qi', 'completed', '2026-04-08 09:30+10', '2026-04-12 14:30+10'
FROM projects p JOIN datasets d ON d.project_id = p.project_id
WHERE p.name = 'Graph Search Algorithm Evaluation' AND d.name = 'synthetic_weighted_graphs';

INSERT INTO runs (experiment_id, run_name, model_family, model_name, framework, git_commit, run_status, started_at, completed_at, notes)
SELECT experiment_id, 'baseline_lstm_seq2seq', 'Seq2Seq', 'LSTM Encoder-Decoder', 'PyTorch', 'a13f9bc', 'succeeded', '2026-03-02 10:00+11', '2026-03-02 16:30+11', 'Baseline model without attention.'
FROM experiments WHERE name = 'attention_comparison';

INSERT INTO runs (experiment_id, run_name, model_family, model_name, framework, git_commit, run_status, started_at, completed_at, notes)
SELECT experiment_id, 'masked_attention_lstm', 'Seq2Seq', 'LSTM with Masked Attention', 'PyTorch', 'c42e018', 'succeeded', '2026-03-04 09:00+11', '2026-03-04 18:45+11', 'Attention model with packed encoder sequences and beam search.'
FROM experiments WHERE name = 'attention_comparison';

INSERT INTO runs (experiment_id, run_name, model_family, model_name, framework, git_commit, run_status, started_at, completed_at, notes)
SELECT experiment_id, 'baseline_cnn', 'CNN', 'Baseline CNN', 'TensorFlow/Keras', 'b65d201', 'succeeded', '2026-03-16 09:00+11', '2026-03-16 13:10+11', 'Initial CNN classification run.'
FROM experiments WHERE name = 'cifar100_cnn_comparison';

INSERT INTO runs (experiment_id, run_name, model_family, model_name, framework, git_commit, run_status, started_at, completed_at, notes)
SELECT experiment_id, 'tuned_cnn_dropout_aug', 'CNN', 'Tuned CNN with Augmentation', 'TensorFlow/Keras', 'd09a4ef', 'succeeded', '2026-03-18 09:15+11', '2026-03-18 17:35+11', 'Improved CNN run with regularisation and augmentation.'
FROM experiments WHERE name = 'cifar100_cnn_comparison';

INSERT INTO runs (experiment_id, run_name, model_family, model_name, framework, git_commit, run_status, started_at, completed_at, notes)
SELECT experiment_id, 'fcn_baseline', 'Segmentation', 'FCN Baseline', 'TensorFlow/Keras', 'f71cd22', 'succeeded', '2026-03-26 10:00+11', '2026-03-26 17:20+11', 'FCN baseline for semantic segmentation.'
FROM experiments WHERE name = 'voc_segmentation_architectures';

INSERT INTO runs (experiment_id, run_name, model_family, model_name, framework, git_commit, run_status, started_at, completed_at, notes)
SELECT experiment_id, 'unet_variant', 'Segmentation', 'U-Net Variant', 'TensorFlow/Keras', 'e18ca99', 'succeeded', '2026-03-29 10:00+11', '2026-03-29 18:15+11', 'U-Net style segmentation architecture.'
FROM experiments WHERE name = 'voc_segmentation_architectures';

INSERT INTO runs (experiment_id, run_name, model_family, model_name, framework, git_commit, run_status, started_at, completed_at, notes)
SELECT experiment_id, 'fpn_attention_failed', 'Segmentation', 'FPN Attention Variant', 'TensorFlow/Keras', 'ab0239d', 'failed', '2026-04-01 11:00+11', '2026-04-01 11:42+11', 'Failed due to memory pressure during training.'
FROM experiments WHERE name = 'voc_segmentation_architectures';

INSERT INTO runs (experiment_id, run_name, model_family, model_name, framework, git_commit, run_status, started_at, completed_at, notes)
SELECT experiment_id, 'astar_zero_heuristic', 'Graph Search', 'A* Search', 'Python', '9dc51aa', 'succeeded', '2026-04-09 09:30+10', '2026-04-09 09:35+10', 'A* with zero heuristic for uniform-cost-style comparison.'
FROM experiments WHERE name = 'search_strategy_comparison';

INSERT INTO runs (experiment_id, run_name, model_family, model_name, framework, git_commit, run_status, started_at, completed_at, notes)
SELECT experiment_id, 'greedy_heuristic', 'Graph Search', 'Greedy Best-First Search', 'Python', '31fd6ca', 'succeeded', '2026-04-09 10:00+10', '2026-04-09 10:04+10', 'Greedy strategy prioritising heuristic distance.'
FROM experiments WHERE name = 'search_strategy_comparison';

INSERT INTO hyperparameters (run_id, param_name, param_value, param_type)
SELECT run_id, param_name, param_value, param_type
FROM runs
CROSS JOIN LATERAL (
    VALUES
    ('learning_rate', '0.001', 'numeric'),
    ('batch_size', '64', 'integer'),
    ('epochs', '20', 'integer')
) AS hp(param_name, param_value, param_type)
WHERE run_name IN ('baseline_lstm_seq2seq', 'masked_attention_lstm', 'baseline_cnn', 'tuned_cnn_dropout_aug');

INSERT INTO hyperparameters (run_id, param_name, param_value, param_type)
SELECT run_id, param_name, param_value, param_type
FROM runs
CROSS JOIN LATERAL (
    VALUES
    ('optimizer', 'adam', 'text'),
    ('input_size', '224', 'integer'),
    ('epochs', '15', 'integer')
) AS hp(param_name, param_value, param_type)
WHERE model_family = 'Segmentation';

INSERT INTO hyperparameters (run_id, param_name, param_value, param_type)
SELECT run_id, param_name, param_value, param_type
FROM runs
CROSS JOIN LATERAL (
    VALUES
    ('uses_heuristic', CASE WHEN run_name = 'greedy_heuristic' THEN 'true' ELSE 'false' END, 'boolean'),
    ('graph_count', '80', 'integer')
) AS hp(param_name, param_value, param_type)
WHERE model_family = 'Graph Search';

INSERT INTO metrics (run_id, metric_name, metric_value, split, step)
SELECT run_id, metric_name, metric_value, split, 20
FROM runs
JOIN LATERAL (
    VALUES
    ('bleu_4', CASE run_name WHEN 'masked_attention_lstm' THEN 0.0653 ELSE 0.0412 END, 'test'),
    ('meteor', CASE run_name WHEN 'masked_attention_lstm' THEN 0.2308 ELSE 0.1984 END, 'test'),
    ('ingredient_coverage', CASE run_name WHEN 'masked_attention_lstm' THEN 20.7500 ELSE 15.3000 END, 'test')
) AS m(metric_name, metric_value, split) ON TRUE
WHERE run_name IN ('baseline_lstm_seq2seq', 'masked_attention_lstm');

INSERT INTO metrics (run_id, metric_name, metric_value, split, step)
SELECT run_id, metric_name, metric_value, split, 20
FROM runs
JOIN LATERAL (
    VALUES
    ('accuracy', CASE run_name WHEN 'tuned_cnn_dropout_aug' THEN 0.7418 ELSE 0.6025 END, 'test'),
    ('loss', CASE run_name WHEN 'tuned_cnn_dropout_aug' THEN 0.8940 ELSE 1.4320 END, 'test')
) AS m(metric_name, metric_value, split) ON TRUE
WHERE run_name IN ('baseline_cnn', 'tuned_cnn_dropout_aug');

INSERT INTO metrics (run_id, metric_name, metric_value, split, step)
SELECT run_id, metric_name, metric_value, split, 15
FROM runs
JOIN LATERAL (
    VALUES
    ('mean_iou', CASE run_name WHEN 'unet_variant' THEN 0.6120 WHEN 'fcn_baseline' THEN 0.5440 ELSE 0.0000 END, 'validation'),
    ('pixel_accuracy', CASE run_name WHEN 'unet_variant' THEN 0.8420 WHEN 'fcn_baseline' THEN 0.8030 ELSE 0.0000 END, 'validation')
) AS m(metric_name, metric_value, split) ON TRUE
WHERE run_name IN ('fcn_baseline', 'unet_variant', 'fpn_attention_failed');

INSERT INTO metrics (run_id, metric_name, metric_value, split, step)
SELECT run_id, metric_name, metric_value, split, 1
FROM runs
JOIN LATERAL (
    VALUES
    ('path_cost', CASE run_name WHEN 'astar_zero_heuristic' THEN 124.0000 ELSE 141.0000 END, 'test'),
    ('nodes_expanded', CASE run_name WHEN 'astar_zero_heuristic' THEN 37.0000 ELSE 18.0000 END, 'test')
) AS m(metric_name, metric_value, split) ON TRUE
WHERE run_name IN ('astar_zero_heuristic', 'greedy_heuristic');

INSERT INTO artifacts (run_id, artifact_type, artifact_name, uri, file_size_kb)
SELECT run_id, artifact_type, artifact_name, uri, file_size_kb
FROM runs
JOIN LATERAL (
    VALUES
    ('report', run_name || '_summary.md', 'artifacts/reports/' || run_name || '_summary.md', 24),
    ('plot', run_name || '_metrics.png', 'artifacts/plots/' || run_name || '_metrics.png', 156)
) AS a(artifact_type, artifact_name, uri, file_size_kb) ON TRUE
WHERE run_status = 'succeeded';

INSERT INTO tags (tag_name) VALUES
('nlp'), ('computer-vision'), ('postgresql'), ('portfolio'), ('failed-run'), ('best-model'), ('baseline');

INSERT INTO run_tags (run_id, tag_id)
SELECT r.run_id, t.tag_id
FROM runs r
JOIN tags t ON
    (r.run_name LIKE '%baseline%' AND t.tag_name = 'baseline')
    OR (r.run_name IN ('masked_attention_lstm', 'tuned_cnn_dropout_aug', 'unet_variant') AND t.tag_name = 'best-model')
    OR (r.run_status = 'failed' AND t.tag_name = 'failed-run')
    OR (r.model_family = 'Seq2Seq' AND t.tag_name = 'nlp')
    OR (r.model_family IN ('CNN', 'Segmentation') AND t.tag_name = 'computer-vision')
    OR (t.tag_name IN ('postgresql', 'portfolio'));

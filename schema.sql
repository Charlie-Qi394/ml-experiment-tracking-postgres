-- PostgreSQL schema for a synthetic ML experiment tracking portfolio project.
-- It models datasets, experiments, model runs, hyperparameters, metrics,
-- artifacts, and tags commonly used in AI/ML workflows.

DROP TABLE IF EXISTS run_tags CASCADE;
DROP TABLE IF EXISTS tags CASCADE;
DROP TABLE IF EXISTS artifacts CASCADE;
DROP TABLE IF EXISTS metrics CASCADE;
DROP TABLE IF EXISTS hyperparameters CASCADE;
DROP TABLE IF EXISTS runs CASCADE;
DROP TABLE IF EXISTS experiments CASCADE;
DROP TABLE IF EXISTS datasets CASCADE;
DROP TABLE IF EXISTS projects CASCADE;

CREATE TABLE projects (
    project_id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    domain TEXT NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE datasets (
    dataset_id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    version TEXT NOT NULL,
    source_type TEXT NOT NULL CHECK (source_type IN ('public', 'synthetic', 'internal_demo')),
    row_count INTEGER CHECK (row_count IS NULL OR row_count >= 0),
    feature_count INTEGER CHECK (feature_count IS NULL OR feature_count >= 0),
    target_name TEXT,
    license_note TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (project_id, name, version)
);

CREATE TABLE experiments (
    experiment_id BIGSERIAL PRIMARY KEY,
    project_id BIGINT NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    dataset_id BIGINT REFERENCES datasets(dataset_id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    objective TEXT NOT NULL,
    owner TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('planned', 'running', 'completed', 'archived')),
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (project_id, name),
    CHECK (completed_at IS NULL OR started_at IS NULL OR completed_at >= started_at)
);

CREATE TABLE runs (
    run_id BIGSERIAL PRIMARY KEY,
    experiment_id BIGINT NOT NULL REFERENCES experiments(experiment_id) ON DELETE CASCADE,
    run_name TEXT NOT NULL,
    model_family TEXT NOT NULL,
    model_name TEXT NOT NULL,
    framework TEXT NOT NULL,
    git_commit CHAR(7),
    run_status TEXT NOT NULL CHECK (run_status IN ('queued', 'running', 'succeeded', 'failed', 'cancelled')),
    started_at TIMESTAMPTZ NOT NULL,
    completed_at TIMESTAMPTZ,
    notes TEXT,
    UNIQUE (experiment_id, run_name),
    CHECK (completed_at IS NULL OR completed_at >= started_at)
);

CREATE TABLE hyperparameters (
    hyperparameter_id BIGSERIAL PRIMARY KEY,
    run_id BIGINT NOT NULL REFERENCES runs(run_id) ON DELETE CASCADE,
    param_name TEXT NOT NULL,
    param_value TEXT NOT NULL,
    param_type TEXT NOT NULL CHECK (param_type IN ('integer', 'numeric', 'text', 'boolean')),
    UNIQUE (run_id, param_name)
);

CREATE TABLE metrics (
    metric_id BIGSERIAL PRIMARY KEY,
    run_id BIGINT NOT NULL REFERENCES runs(run_id) ON DELETE CASCADE,
    metric_name TEXT NOT NULL,
    metric_value NUMERIC(12, 6) NOT NULL,
    split TEXT NOT NULL CHECK (split IN ('train', 'validation', 'test')),
    step INTEGER NOT NULL DEFAULT 0 CHECK (step >= 0),
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (run_id, metric_name, split, step)
);

CREATE TABLE artifacts (
    artifact_id BIGSERIAL PRIMARY KEY,
    run_id BIGINT NOT NULL REFERENCES runs(run_id) ON DELETE CASCADE,
    artifact_type TEXT NOT NULL CHECK (artifact_type IN ('model', 'plot', 'report', 'sample_output', 'confusion_matrix', 'mask_preview')),
    artifact_name TEXT NOT NULL,
    uri TEXT NOT NULL,
    file_size_kb INTEGER CHECK (file_size_kb IS NULL OR file_size_kb >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (run_id, artifact_name)
);

CREATE TABLE tags (
    tag_id BIGSERIAL PRIMARY KEY,
    tag_name TEXT NOT NULL UNIQUE
);

CREATE TABLE run_tags (
    run_id BIGINT NOT NULL REFERENCES runs(run_id) ON DELETE CASCADE,
    tag_id BIGINT NOT NULL REFERENCES tags(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (run_id, tag_id)
);

CREATE INDEX idx_datasets_project ON datasets(project_id);
CREATE INDEX idx_experiments_project_status ON experiments(project_id, status);
CREATE INDEX idx_runs_experiment_status ON runs(experiment_id, run_status);
CREATE INDEX idx_runs_model_family ON runs(model_family);
CREATE INDEX idx_metrics_name_split_value ON metrics(metric_name, split, metric_value DESC);
CREATE INDEX idx_metrics_run_name_split ON metrics(run_id, metric_name, split);
CREATE INDEX idx_artifacts_run_type ON artifacts(run_id, artifact_type);

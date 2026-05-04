# ML Experiment Tracking with PostgreSQL

PostgreSQL portfolio project modelling a lightweight machine-learning experiment tracking database. It demonstrates relational schema design, SQL analytics, joins, CTEs, window functions, indexing, reproducibility metadata, and Python database access for AI/ML workflows.

The dataset in this repository is fully synthetic or public-dataset metadata only. It does not include private data, raw coursework datasets, submitted assignments, or restricted course material.

## Project Goals

- Design a normalized PostgreSQL schema for ML experiment tracking.
- Store datasets, experiments, model runs, hyperparameters, metrics, artifacts, and tags.
- Query best-performing runs across NLP, computer vision, and graph-search examples.
- Demonstrate SQL skills relevant to AI/ML, data analyst, data engineering, and software roles.
- Show practical Python access to PostgreSQL using `psycopg`.

## Schema Overview

```text
projects
  -> datasets
  -> experiments
      -> runs
          -> hyperparameters
          -> metrics
          -> artifacts
          -> run_tags -> tags
```

Key design choices:

- `projects`, `datasets`, `experiments`, and `runs` separate portfolio domains from individual model attempts.
- `metrics` stores multiple metric names, splits, and training steps for flexible model evaluation.
- `hyperparameters` stores run-level settings without changing the schema for each model family.
- `artifacts` records reports, plots, sample outputs, masks, and model files without storing binary objects in PostgreSQL.
- `tags` and `run_tags` support many-to-many categorisation such as `best-model`, `failed-run`, `nlp`, and `computer-vision`.

## Technologies

- PostgreSQL
- SQL
- Docker Compose
- Python
- `psycopg`

## PostgreSQL Skills Demonstrated

- Relational schema design
- Primary keys and foreign keys
- Constraints and checks
- One-to-many and many-to-many relationships
- Joins
- CTEs
- Window functions
- Conditional aggregation
- JSON aggregation
- Indexing
- Reproducibility and dataset lineage queries
- Python database connection and result reporting

## Folder Structure

```text
ml-experiment-tracking-postgres/
  README.md
  schema.sql
  seed.sql
  docker-compose.yml
  Makefile
  requirements.txt
  queries/
    01_best_runs.sql
    02_compare_experiments.sql
    03_metric_trends.sql
    04_failed_runs.sql
    05_dataset_lineage.sql
    06_hyperparameter_search.sql
    07_tagged_runs.sql
  python/
    summarize_experiments.py
```

## Quick Start

Start PostgreSQL with Docker:

```bash
docker compose up -d
```

The container automatically loads `schema.sql` and `seed.sql` on first startup.

Connect with `psql`:

```bash
psql postgresql://postgres:postgres@localhost:5432/ml_experiments
```

Run an example query:

```bash
psql postgresql://postgres:postgres@localhost:5432/ml_experiments \
  -f queries/01_best_runs.sql
```

Or use the Makefile:

```bash
make up
make run-query QUERY=queries/01_best_runs.sql
```

## Python Summary Script

Create a virtual environment and install dependencies:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Run the summary script:

```bash
export DATABASE_URL=postgresql://postgres:postgres@localhost:5432/ml_experiments
python python/summarize_experiments.py
```

Example output:

```text
Best ML Experiment Runs
========================
- Computer Vision Classification and Segmentation / cifar100_cnn_comparison: tuned_cnn_dropout_aug ...
- Computer Vision Classification and Segmentation / voc_segmentation_architectures: unet_variant ...
- Graph Search Algorithm Evaluation / search_strategy_comparison: astar_zero_heuristic ...
- Seq2Seq Recipe Generation / attention_comparison: masked_attention_lstm ...
```

## Example Queries

`queries/01_best_runs.sql`

Ranks the best successful model run for each experiment using task-specific metrics. Demonstrates CTEs and `ROW_NUMBER()`.

`queries/02_compare_experiments.sql`

Compares model families across experiments using joins, aggregate functions, filtered counts, and runtime calculations.

`queries/03_metric_trends.sql`

Shows how metric values can be tracked across training steps using `LAG()`.

`queries/04_failed_runs.sql`

Finds failed runs and aggregates hyperparameters into JSON for debugging.

`queries/05_dataset_lineage.sql`

Links datasets to experiments, runs, commits, and artifacts for reproducibility.

`queries/06_hyperparameter_search.sql`

Compares hyperparameter values against final quality metrics.

`queries/07_tagged_runs.sql`

Queries many-to-many tag relationships for best models, failed runs, NLP, and computer-vision runs.

## Sample Portfolio Positioning

Resume bullet:

```text
Designed a PostgreSQL ML experiment-tracking database with normalized tables for datasets, experiments, runs, hyperparameters, metrics and artifacts; wrote SQL queries using joins, CTEs, window functions, indexing and Python access via psycopg.
```

GitHub description:

```text
PostgreSQL portfolio project modelling ML experiment tracking with schema design, metrics queries, CTEs, window functions, indexing and Python database access.
```

## Reset The Database

If using Docker Compose:

```bash
docker compose down -v
docker compose up -d
```

Or:

```bash
make reset
```

## Notes

This project is educational portfolio work. It is intentionally compact, readable, and designed to demonstrate database fundamentals in an AI/ML context rather than replace production experiment-tracking tools such as MLflow, Weights & Biases, or Neptune.

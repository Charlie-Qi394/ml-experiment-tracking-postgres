"""Print a concise summary of ML experiment results from PostgreSQL.

Set DATABASE_URL before running, for example:
    export DATABASE_URL=postgresql://postgres:postgres@localhost:5432/ml_experiments
"""

from __future__ import annotations

import os
import sys
from decimal import Decimal

import psycopg
from psycopg.rows import dict_row


SUMMARY_QUERY = """
WITH ranked_runs AS (
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
                END DESC
        ) AS rank_in_experiment
    FROM projects p
    JOIN experiments e ON e.project_id = p.project_id
    JOIN runs r ON r.experiment_id = e.experiment_id
    JOIN metrics m ON m.run_id = r.run_id
    WHERE r.run_status = 'succeeded'
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
FROM ranked_runs
WHERE rank_in_experiment = 1
ORDER BY project_name, experiment_name;
"""


def format_metric(value: Decimal) -> str:
    """Render decimals cleanly for terminal output."""
    return f"{value:.4f}".rstrip("0").rstrip(".")


def main() -> int:
    database_url = os.getenv("DATABASE_URL")
    if not database_url:
        print("DATABASE_URL is not set.", file=sys.stderr)
        print(
            "Example: export DATABASE_URL=postgresql://postgres:postgres@localhost:5432/ml_experiments",
            file=sys.stderr,
        )
        return 1

    with psycopg.connect(database_url, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(SUMMARY_QUERY)
            rows = cur.fetchall()

    if not rows:
        print("No successful experiment runs found.")
        return 0

    print("Best ML Experiment Runs")
    print("=" * 24)
    for row in rows:
        print(
            f"- {row['project_name']} / {row['experiment_name']}: "
            f"{row['run_name']} ({row['model_name']}, {row['framework']}) "
            f"{row['metric_name']}={format_metric(row['metric_value'])}"
        )

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

DATABASE_URL ?= postgresql://postgres:postgres@localhost:5432/ml_experiments

.PHONY: up down reset psql load-schema load-seed run-query summarize

up:
	docker compose up -d

down:
	docker compose down

reset:
	docker compose down -v
	docker compose up -d

psql:
	psql "$(DATABASE_URL)"

load-schema:
	psql "$(DATABASE_URL)" -f schema.sql

load-seed:
	psql "$(DATABASE_URL)" -f seed.sql

run-query:
	psql "$(DATABASE_URL)" -f "$(QUERY)"

summarize:
	DATABASE_URL="$(DATABASE_URL)" python python/summarize_experiments.py

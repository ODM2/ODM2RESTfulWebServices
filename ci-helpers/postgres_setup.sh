#!/bin/bash

psql -U postgres -c "create extension postgis"
psql -U postgres -q  -f ./tests/data/envirodiy_postgres_odm2.sql

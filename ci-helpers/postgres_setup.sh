#!/bin/bash

psql -U postgres -c "create extension postgis"
psql -U postgres -q  -f ./tests/data/odm2samples_dump.sql

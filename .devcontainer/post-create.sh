#!/bin/sh
set -eu
npm ci
pre-commit install

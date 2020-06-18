#!/bin/bash
DOCKER_BUILDKIT=1 docker build -t reisner/r_data_science:latest .
docker push reisner/r_data_science:latest

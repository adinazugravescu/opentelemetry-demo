#!/bin/bash

docker kill tempo grafana 2>/dev/null || true
docker rm tempo grafana 2>/dev/null || true

docker run --rm -d --name grafana --network host \
  -e "GF_SECURITY_ADMIN_USER=admin" \
  -e "GF_SECURITY_ADMIN_PASSWORD=admin" \
  -e "GF_AUTH_ANONYMOUS_ENABLED=true" \
  -e "GF_AUTH_ANONYMOUS_ORG_ROLE=Admin" \
  -e "GF_FEATURE_TOGGLES_ENABLE=traceToProfiles,correlations" \
  grafana/grafana:10.4.0

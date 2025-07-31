#!/bin/bash
source "$(dirname "$0")/.env"
python3 -m mcp_proxy -H Authorization "Bearer $HOMEASSISTANT_TOKEN" "$SSE_URL"
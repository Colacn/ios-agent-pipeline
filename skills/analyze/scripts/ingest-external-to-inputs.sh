#!/usr/bin/env bash
# 兼容入口：统一转发到 .cursor/scripts 权威实现。
set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$script_dir/../../../scripts/ingest-external-to-inputs.sh" "$@"

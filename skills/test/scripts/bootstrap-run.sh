#!/usr/bin/env bash
# 转发至 .cursor/scripts 的权威实现（创建 runs/<slug>/{inputs,outputs}）。
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/../../../scripts/bootstrap-run.sh" "$@"

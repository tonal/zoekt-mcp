#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Launch zoekt-mcp in MCP stdio mode, independent of the caller's working directory.
#
# Why this exists: Claude Code (at least through 2.1.x) does not apply the stdio
# MCP server config's `cwd` field — the child process inherits the parent's cwd.
# Since the server is started with `python -m src.main`, it must run from this
# repo root or `src/` won't be importable (ModuleNotFoundError -> -32000 Connection closed).
# This wrapper always cd's into the repo before exec'ing python.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"
# Режим транспорта задаём явно: без --stdio main.py запускает HTTP/SSE-режим,
# а не stdio, и сервер молчит в протоколе (пустой stdout -> -32000).
exec "$HERE/venv/bin/python3" -m src.main --stdio "$@"

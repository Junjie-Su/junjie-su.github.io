#!/usr/bin/env bash
set -euo pipefail

if command -v brew >/dev/null 2>&1; then
  RUBY_PREFIX="$(brew --prefix ruby@3.2 2>/dev/null || true)"
  if [[ -n "${RUBY_PREFIX}" && -x "${RUBY_PREFIX}/bin/bundle" ]]; then
    export PATH="${RUBY_PREFIX}/bin:${PATH}"
  fi
fi

bundle exec jekyll serve "$@"

#!/usr/bin/env bash
# Run:  ~/databricks/.scripts/.sync-ai-rag-internal-documentation-dir.sh --clean
set -euo pipefail

###############################################################################
# CONFIGURABLE PATHS
###############################################################################
relative_path="AI RAG - Internal Documentation"
local_root="$HOME/OneDrive - Shell/databricks/emob_dev/$relative_path"
remote_root="/Shared/AI Roadmap/$relative_path"
clean_ignore_dir=".nvim-workspace"

###############################################################################
# OPTIONAL CLEAN-SYNC
###############################################################################
if [[ "${1:-}" == "--clean" ]]; then
  echo "You have passed the --clean flag, which will recursively wipe: $local_root"
  read -rp "Press 'y' to confirm (y/n): " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    find "$local_root" -mindepth 1 \
      ! -path "$local_root/$clean_ignore_dir" \
      ! -path "$local_root/$clean_ignore_dir/*" \
      -exec rm -rf -- {} +
    echo "Local folder cleaned."
  else
    echo "Clean aborted."
  fi
fi

###############################################################################
# RECURSIVE EXPORT
###############################################################################
export_object() {
  local db_path="$1" # Workspace object path
  local fs_path="$2" # Local mirror (base filename, no ext)

  # ── 1. Identify object type (DIRECTORY | NOTEBOOK | OTHER) ─────────────────
  local obj_type
  obj_type="$(databricks workspace get-status "$db_path" -o json | jq -r '.object_type')"

  case "$obj_type" in
  DIRECTORY)
    mkdir -p "$fs_path"
    # Recurse over children
    while IFS= read -r child; do
      export_object "$child" "$fs_path/$(basename "$child")"
    done < <(databricks workspace list "$db_path" -o json | jq -r '.[].path')
    ;;

  NOTEBOOK)
    mkdir -p "$(dirname "$fs_path")"

    # Make a data pipeline for parsing the databricks format into a normal ipython format, with debugging intermediary files.

    # TODO: Make it clear that currently this can only deal with notebook formats and md from databricks.
    tmp_src="${fs_path}.databricks.py"             # Raw Databricks-source export
    clean_src="${fs_path}.clean_1.py"              # After stages 1–2
    final_src_pre_jupytext="${fs_path}.clean_2.py" # After stages 1–2
    final_src="${fs_path}.py"                      # Percent-format notebook

    # ➊ Export Databricks SOURCE
    databricks workspace export --file "$tmp_src" --format AUTO "$db_path"

    # ➋  Stage-A ─ replace Databricks markdown marker
    #     '# MAGIC %md'  →  '# %% [markdown]'
    sed 's/^[[:space:]]*#[[:space:]]*MAGIC[[:space:]]*%md[[:space:]]*$/# %% [markdown]/' \
      "$tmp_src" >"$clean_src"

    # ➋ Stage-B ─ add Python markers except when the first real line
    #             already contains  ‘%% [markdown]’
    awk '
      BEGIN { newcell = 1 }

      # Skip the banner
      NR==1 && $0 ~ /^[[:space:]]*# Databricks notebook source[[:space:]]*$/ { next }

      # Cell separator
      /^[[:space:]]*# COMMAND[[:space:]]*-+/ { newcell = 1; next }

      # First non-blank line after a separator …
      newcell && $0 !~ /^[[:space:]]*$/ {
          # If it includes  %% [markdown]  don’t add a python marker
          if ($0 !~ /%%[[:space:]]*\[markdown]/) {
              print "# %% [python]"
          }
          newcell = 0
      }

      { print }   # emit current line
    ' "$clean_src" >"$final_src_pre_jupytext"

    # ➌ Convert to Jupytext percent format
    jupytext --to py:percent "$final_src_pre_jupytext" --output "$final_src"

    # ➍-➎ Remove %md markers and all MAGIC tokens (BSD-compatible sed)
    sed -i '' -e '/^[[:space:]]*#[:space:]*MAGIC[:space:]*%md/d' \
      -e 's/^[[:space:]]*#[[:space:]]*MAGIC[[:space:]]*%md[[:space:]]*//g' \
      -e 's/# MAGIC[[:space:]]//g' \
      -e 's/# MAGIC//g' \
      "$final_src"

    rm -f "$tmp_src" "$clean_src" "$final_src_pre_jupytext"
    ;;

  *)
    # Any non-notebook artefact – export verbatim
    mkdir -p "$(dirname "$fs_path")"
    databricks workspace export --file "$fs_path" "$db_path"
    ;;
  esac
}

export_object "$remote_root" "$local_root"
echo "Workspace sync complete."

#!/bin/bash

set -e          # Exit on error
set -o pipefail # Exit on pipeline error

if [ ! -d "$INPUT_OUTPUT_DIR" ]; then
	echo "Creating output directory $INPUT_OUTPUT_DIR"
	mkdir -p "$INPUT_OUTPUT_DIR"
fi

if [ -n "$INPUT_SOURCE_DIR" ]; then
	PACK_ARGS=()
	if [ "$INPUT_FORCE" = "true" ]; then PACK_ARGS+=(--force); fi
	if [ -n "$INPUT_EXTRA_SOURCE" ]; then
		while IFS= read -r source; do
			# Trim whitespace
			source=$(echo "$source" | xargs)
			if [ -n "$source" ]; then
				PACK_ARGS+=(--extra-source "$source")
			fi
		done <<<"$INPUT_EXTRA_SOURCE"
	fi
	if [ -n "$INPUT_GETTEXT_DOMAIN" ]; then PACK_ARGS+=(--gettext-domain "$INPUT_GETTEXT_DOMAIN"); fi
	if [ -n "$INPUT_OUTPUT_DIR" ]; then PACK_ARGS+=(--out-dir "$INPUT_OUTPUT_DIR"); fi
	if [ -n "$INPUT_PODIR" ]; then PACK_ARGS+=(--podir "$INPUT_PODIR"); fi
	if [ -n "$INPUT_SCHEMA" ]; then PACK_ARGS+=(--schema "$INPUT_SCHEMA"); fi
	gnome-extensions pack "${PACK_ARGS[@]}" "$INPUT_SOURCE_DIR"
fi

ZIP_FILE=$(find "$INPUT_OUTPUT_DIR" -maxdepth 1 -name "*.shell-extension.zip" -print -quit)
if [ -z "$ZIP_FILE" ]; then
	echo "Error: No .shell-extension.zip file found in $INPUT_OUTPUT_DIR"
	exit 1
else
	echo "zip-file=$ZIP_FILE" >>$GITHUB_OUTPUT
fi

if [ -n "$INPUT_USERNAME" ] && [ -n "$INPUT_PASSWORD" ]; then
	UPLOAD_ARGS=()
	UPLOAD_ARGS+=(--user "$INPUT_USERNAME")
	UPLOAD_ARGS+=(--password "$INPUT_PASSWORD")
	if [ "$INPUT_ACCEPT_TOS" = "true" ]; then UPLOAD_ARGS+=(--accept-tos); fi
	gnome-extensions upload "${UPLOAD_ARGS[@]}" "$ZIP_FILE"
fi

SHELL := /bin/bash
ROOT := $$(git rev-parse --show-toplevel)

.PHONY: docs hooks

docs:
	@terraform-docs markdown table --output-file "$(ROOT)/README.md" --output-mode inject "$(ROOT)"

## Configure git to use the hooks in .githooks/
hooks:
	git config core.hooksPath .githooks

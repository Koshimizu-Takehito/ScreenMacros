.PHONY: setup sync lint format format-check test build clean help

# Default target
.DEFAULT_GOAL := help

# ============================================================================
# Setup
# ============================================================================

setup: ## Install Mint (if needed) and dependencies via Mint
	@echo "📦 Checking Mint installation..."
	@if ! command -v mint >/dev/null 2>&1; then \
		if command -v brew >/dev/null 2>&1; then \
			echo "🍺 Mint not found. Installing via Homebrew..."; \
			brew install mint; \
		else \
			echo "❌ Mint is not installed and Homebrew is not available."; \
			echo "   Please install Mint manually: https://github.com/yonaskolb/Mint"; \
			exit 1; \
		fi; \
	fi
	@echo "📦 Installing packages from Mintfile..."
	@mint bootstrap
	@echo "✅ Setup complete!"

sync: ## Pull latest changes and update all dependencies
	@echo "🔄 Pulling latest changes..."
	@git pull
	@echo "📦 Updating Mint packages..."
	@mint bootstrap
	@echo "📦 Resolving Swift packages..."
	@swift package resolve
	@echo "✅ Sync complete!"

# ============================================================================
# Linting & Formatting
# ============================================================================

lint: ## Run SwiftLint
	@echo "🔍 Running SwiftLint..."
	@mint run swiftlint lint

format: ## Format code with SwiftFormat
	@echo "✨ Formatting code..."
	@mint run swiftformat Sources Tests
	@echo "✅ Formatting complete!"

format-check: ## Check code formatting (no changes)
	@echo "🔍 Checking code format..."
	@mint run swiftformat Sources Tests --lint

# ============================================================================
# Build & Test
# ============================================================================

build: ## Build the package
	@echo "🔨 Building..."
	@swift build

test: ## Run tests
	@echo "🧪 Running tests..."
	@swift test

# ============================================================================
# CI
# ============================================================================

ci: lint format-check test ## Run all CI checks (lint, format-check, test)
	@echo "✅ All CI checks passed!"

# ============================================================================
# Utilities
# ============================================================================

clean: ## Clean build artifacts
	@echo "🧹 Cleaning..."
	@swift package clean
	@rm -rf .build
	@echo "✅ Clean complete!"

# ============================================================================
# Help
# ============================================================================

help: ## Show this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'


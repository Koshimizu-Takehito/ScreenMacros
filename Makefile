.PHONY: setup lint format format-check test build clean help

# Default target
.DEFAULT_GOAL := help

# ============================================================================
# Setup
# ============================================================================

setup: ## Install dependencies (Mint and packages)
	@echo "📦 Installing Mint..."
	@which mint > /dev/null || brew install mint
	@echo "📦 Installing packages from Mintfile..."
	@mint bootstrap
	@echo "✅ Setup complete!"

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


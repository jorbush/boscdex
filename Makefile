.PHONY: help setup format format-check lint test-unit test-integration test-e2e test-all test-coverage check build-runner clean run build-apk build-ios zip-mushrooms zip-trees zip-datasets

# Default target
.DEFAULT_GOAL := help

# Colors for terminal output
CYAN  := $(shell printf '\033[36m')
GREEN := $(shell printf '\033[32m')
RESET := $(shell printf '\033[0m')

help: ## Show this help message
	@echo "$(CYAN)Boscdex Development Automation Commands:$(RESET)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-18s$(RESET) %s\n", $$1, $$2}'
	@echo ""

setup: ## Install dependencies and run code generation
	@echo "$(CYAN)Installing dependencies...$(RESET)"
	flutter pub get
	@echo "$(CYAN)Running build_runner...$(RESET)"
	flutter pub run build_runner build --delete-conflicting-outputs

format: ## Format all Dart files
	@echo "$(CYAN)Formatting Dart files...$(RESET)"
	dart format .

format-check: ## Verify that all Dart code is properly formatted
	@echo "$(CYAN)Checking Dart code formatting...$(RESET)"
	dart format --output=none --set-exit-if-changed .

lint: ## Run static code analysis (linter)
	@echo "$(CYAN)Running Flutter analyzer...$(RESET)"
	flutter analyze

test-unit: ## Run the unit test suite
	@echo "$(CYAN)Running Unit Tests...$(RESET)"
	flutter test test/unit_tests/

test-integration: ## Run the integration test suite
	@echo "$(CYAN)Running Integration Tests...$(RESET)"
	flutter test test/integration_tests/

test-e2e: ## Run the end-to-end (E2E) test suite
	@echo "$(CYAN)Running End-to-End Tests...$(RESET)"
	flutter test test/e2e_tests/

test-all: ## Run all test tiers (unit, integration, and E2E)
	@echo "$(CYAN)Executing all test tiers...$(RESET)"
	flutter test test/unit_tests/
	flutter test test/integration_tests/
	flutter test test/e2e_tests/

test-coverage: ## Run tests with code coverage output
	@echo "$(CYAN)Running tests with coverage...$(RESET)"
	flutter test --coverage

check: format-check lint test-all ## Run full local verification (format, lint, and all test tiers)
	@echo "$(GREEN)✓ All local CI checks passed successfully!$(RESET)"

build-runner: ## Re-run Drift code generation
	@echo "$(CYAN)Generating Drift database code...$(RESET)"
	flutter pub run build_runner build --delete-conflicting-outputs

clean: ## Clean Flutter build cache and artifacts
	@echo "$(CYAN)Cleaning build cache...$(RESET)"
	flutter clean
	rm -rf build/

run: ## Launch the app on a connected device/simulator
	@echo "$(CYAN)Launching Boscdex...$(RESET)"
	flutter run

build-apk: ## Build debug Android APK
	@echo "$(CYAN)Building Android debug APK...$(RESET)"
	flutter build apk --debug

build-ios: ## Build debug iOS app without codesigning
	@echo "$(CYAN)Building iOS debug bundle...$(RESET)"
	flutter build ios --no-codesign --debug

zip-mushrooms: ## Package mushroom test assets into clean boscdex_dataset.zip for Drive/Colab
	@echo "$(CYAN)Packaging mushroom dataset into boscdex_dataset.zip...$(RESET)"
	@rm -f boscdex_dataset.zip
	@(cd test/assets/mushrooms && zip -r ../../../boscdex_dataset.zip . -x "*.DS_Store" -x "*/.DS_Store" -x ".DS_Store" -x "__MACOSX*")
	@ls -lh boscdex_dataset.zip
	@echo "$(GREEN)✓ Created clean boscdex_dataset.zip for Google Drive (upload to MyDrive/ or MyDrive/boscdex/)$(RESET)"

zip-trees: ## Package indicator tree test assets into clean tree_dataset.zip for Drive/Colab
	@echo "$(CYAN)Packaging tree dataset into tree_dataset.zip...$(RESET)"
	@rm -f tree_dataset.zip
	@(cd test/assets/trees && zip -r ../../../tree_dataset.zip . -x "*.DS_Store" -x "*/.DS_Store" -x ".DS_Store" -x "__MACOSX*")
	@ls -lh tree_dataset.zip
	@echo "$(GREEN)✓ Created clean tree_dataset.zip for Google Drive (upload to MyDrive/ or MyDrive/boscdex/)$(RESET)"

zip-datasets: zip-mushrooms zip-trees ## Package both mushroom and tree datasets into zip archives


# Test-Driven Development Workflow

You are in TDD mode. Follow this systematic approach for verifiable changes:

## 1. WRITE TESTS FIRST
- Based on expected input/output pairs from requirements
- Create comprehensive test cases covering:
  - Happy path scenarios
  - Edge cases and error conditions  
  - Boundary conditions
- Use existing test frameworks and patterns in the codebase
- Be explicit about what you're testing and why

## 2. CONFIRM TESTS FAIL
- Run the test suite to verify new tests fail as expected
- This proves tests are actually testing the functionality
- Document the failure output for reference

## 3. COMMIT TESTS (if requested)
- Commit failing tests before implementing code
- Use clear commit message indicating test-only commit

## 4. IMPLEMENT CODE
- Write minimal code to make tests pass
- Avoid mock implementations or shortcuts
- Focus on making tests pass, not on perfect code initially
- Follow existing code patterns and conventions

## 5. VERIFY AND REFINE
- Ensure implementation isn't overfitting to tests
- Run full test suite to check for regressions
- Refactor code for clarity and maintainability
- Add additional tests if gaps are discovered

## 6. COMMIT CODE (if requested)
- Commit working implementation
- Use descriptive commit message explaining the feature/fix

Key Principles:
- Tests define the contract, code fulfills it
- Iterate between code and tests until both are robust
- Avoid changing tests once written unless requirements change
- Use independent verification through separate test runs
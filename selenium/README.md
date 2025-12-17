# Selenium Automated Testing for Task Manager

## Overview
This directory contains Selenium WebDriver automated tests for the Task Manager application. The tests validate frontend functionality, API integration, and user interactions.

## Prerequisites

### 1. Install Node.js and npm
```bash
node --version  # Should be 14.x or higher
npm --version
```

### 2. Install Dependencies
```bash
cd selenium
npm install
```

### 3. Install Browser Drivers

#### For Chrome:
- ChromeDriver is included in dependencies
- Or download manually from: https://chromedriver.chromium.org/

#### For Firefox:
- GeckoDriver is included in dependencies
- Or download manually from: https://github.com/mozilla/geckodriver/releases

## Test Cases

### Test Case 1: Homepage Load Verification
- Validates page loads successfully
- Checks page title and header
- Verifies task form is displayed

### Test Case 2: Task Creation
- Tests creating a new task
- Validates task appears in list
- Verifies form clears after submission

### Test Case 3: Task Interaction
- Tests task completion toggle
- Validates task deletion functionality

### Test Case 4: Frontend-Backend API Integration
- Verifies API connection
- Tests task loading from backend
- Validates error handling

### Test Case 5: UI Elements and Navigation
- Checks all UI components
- Tests form validation
- Verifies navigation elements

### Test Case 6: Performance Tests
- Measures page load time
- Tests rapid form submissions

## Running Tests

### Run all tests (default Chrome browser):
```bash
npm test
```

### Run with specific browser:
```bash
# Chrome
npm run test:chrome

# Firefox
npm run test:firefox
```

### Run in headless mode:
```bash
npm run test:headless
```

### Run with custom URL:
```bash
BASE_URL=http://your-app-url npm test
```

### Run with custom configuration:
```bash
BASE_URL=http://localhost:3000 BROWSER=chrome HEADLESS=true npm test
```

## Environment Variables

- `BASE_URL`: Application URL (default: http://localhost:3000)
- `BROWSER`: Browser to use (chrome/firefox, default: chrome)
- `HEADLESS`: Run in headless mode (true/false, default: false)

## Test Output

Tests will display:
- ✅ Success indicators for passed tests
- ❌ Error messages for failed tests
- 📝 Test descriptions and progress
- ⏱️ Execution times

### Example Output:
```
🚀 Starting Selenium tests with chrome browser (headless: false)
✅ WebDriver initialized successfully

  Task Manager - Selenium Automated Tests
    Test Case 1: Homepage Load Verification
📝 Test 1: Loading homepage...
✅ Page title verified: Cloud Pipeline Task Manager
      ✓ should load the homepage successfully (1234ms)
      ✓ should display the main header (234ms)
      ✓ should display the task form (156ms)

    Test Case 2: Task Creation
📝 Test 2: Creating a new task...
✅ Entered task title: Test Task 1234567890
      ✓ should create a new task successfully (2345ms)

  6 passing (15s)
```

## Screenshots on Failure

The test suite can be configured to capture screenshots on test failures. Screenshots will be saved in the `selenium/screenshots/` directory.

## Troubleshooting

### WebDriver Issues:
```bash
# Update drivers
npm update chromedriver geckodriver
```

### Browser not found:
- Ensure Chrome or Firefox is installed
- Check browser version matches driver version

### Connection errors:
- Verify application is running on specified BASE_URL
- Check firewall settings

### Timeout errors:
- Increase timeout in test configuration
- Check application performance

## Integration with CI/CD

### GitHub Actions Example:
```yaml
- name: Run Selenium Tests
  run: |
    npm start &
    sleep 10
    cd selenium
    npm install
    npm run test:headless
```

### Jenkins Example:
```groovy
stage('Selenium Tests') {
    steps {
        sh '''
            npm start &
            sleep 10
            cd selenium
            npm install
            npm run test:headless
        '''
    }
}
```

## Best Practices

1. **Always run tests in headless mode in CI/CD**
2. **Use explicit waits instead of sleep when possible**
3. **Keep test data isolated**
4. **Clean up test data after test execution**
5. **Run tests against a dedicated test environment**

## Maintenance

- Update browser drivers regularly
- Review and update selectors when UI changes
- Add new tests for new features
- Monitor test execution times

## Support

For issues or questions:
1. Check browser console for errors
2. Review Selenium WebDriver documentation
3. Verify application is running correctly
4. Check test logs for detailed error messages

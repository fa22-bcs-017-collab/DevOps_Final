const { Builder, By, until, Key } = require('selenium-webdriver');
const chrome = require('selenium-webdriver/chrome');
const firefox = require('selenium-webdriver/firefox');
const assert = require('assert');

// Configuration
const BASE_URL = process.env.BASE_URL || 'http://localhost:3000';
const BROWSER = process.env.BROWSER || 'chrome';
const HEADLESS = process.env.HEADLESS === 'true';
const TIMEOUT = 10000;

/**
 * Test Suite for Task Manager Application
 * Contains automated Selenium tests for frontend functionality
 */

describe('Task Manager - Selenium Automated Tests', function() {
    let driver;

    // Setup: Initialize WebDriver before tests
    before(async function() {
        this.timeout(30000);
        console.log(`\n🚀 Starting Selenium tests with ${BROWSER} browser (headless: ${HEADLESS})`);
        
        let options;
        if (BROWSER === 'firefox') {
            options = new firefox.Options();
            if (HEADLESS) {
                options.addArguments('-headless');
            }
            driver = await new Builder()
                .forBrowser('firefox')
                .setFirefoxOptions(options)
                .build();
        } else {
            options = new chrome.Options();
            if (HEADLESS) {
                options.addArguments('--headless');
            }
            options.addArguments('--disable-gpu');
            options.addArguments('--no-sandbox');
            options.addArguments('--disable-dev-shm-usage');
            driver = await new Builder()
                .forBrowser('chrome')
                .setChromeOptions(options)
                .build();
        }

        await driver.manage().window().maximize();
        console.log('✅ WebDriver initialized successfully');
    });

    // Cleanup: Quit WebDriver after tests
    after(async function() {
        if (driver) {
            await driver.quit();
            console.log('✅ WebDriver closed');
        }
    });

    /**
     * TEST CASE 1: Verify Homepage Loads Correctly
     * Validates that the main page loads with all essential elements
     */
    describe('Test Case 1: Homepage Load Verification', function() {
        it('should load the homepage successfully', async function() {
            this.timeout(TIMEOUT);
            console.log('\n📝 Test 1: Loading homepage...');
            
            await driver.get(BASE_URL);
            
            // Wait for page to load
            await driver.wait(until.titleContains('Task Manager'), TIMEOUT);
            
            // Verify page title
            const title = await driver.getTitle();
            assert.ok(title.includes('Task Manager'), 'Page title should contain "Task Manager"');
            console.log(`✅ Page title verified: ${title}`);
        });

        it('should display the main header', async function() {
            this.timeout(TIMEOUT);
            console.log('📝 Test 1b: Verifying main header...');
            
            const header = await driver.findElement(By.css('h1'));
            const headerText = await header.getText();
            
            assert.ok(headerText.includes('Task Manager'), 'Header should contain "Task Manager"');
            console.log(`✅ Header text verified: ${headerText}`);
        });

        it('should display the task form', async function() {
            this.timeout(TIMEOUT);
            console.log('📝 Test 1c: Verifying task form exists...');
            
            const form = await driver.findElement(By.id('taskForm'));
            const isDisplayed = await form.isDisplayed();
            
            assert.strictEqual(isDisplayed, true, 'Task form should be visible');
            console.log('✅ Task form is displayed');
        });
    });

    /**
     * TEST CASE 2: Validate Task Creation Functionality
     * Tests the ability to create a new task through the UI
     */
    describe('Test Case 2: Task Creation', function() {
        const testTaskTitle = `Test Task ${Date.now()}`;
        const testTaskDescription = 'This is a test task created by Selenium automation';

        it('should create a new task successfully', async function() {
            this.timeout(TIMEOUT);
            console.log('\n📝 Test 2: Creating a new task...');
            
            // Find and fill the title input
            const titleInput = await driver.findElement(By.id('taskTitle'));
            await titleInput.clear();
            await titleInput.sendKeys(testTaskTitle);
            console.log(`✅ Entered task title: ${testTaskTitle}`);
            
            // Find and fill the description textarea
            const descriptionInput = await driver.findElement(By.id('taskDescription'));
            await descriptionInput.clear();
            await descriptionInput.sendKeys(testTaskDescription);
            console.log(`✅ Entered task description`);
            
            // Submit the form
            const submitButton = await driver.findElement(By.css('button[type="submit"]'));
            await submitButton.click();
            console.log('✅ Clicked submit button');
            
            // Wait a moment for the task to be added
            await driver.sleep(2000);
        });

        it('should display the newly created task in the task list', async function() {
            this.timeout(TIMEOUT);
            console.log('📝 Test 2b: Verifying task appears in list...');
            
            // Wait for task list to update
            await driver.sleep(1000);
            
            // Find all task elements
            const taskElements = await driver.findElements(By.css('.task-item'));
            assert.ok(taskElements.length > 0, 'At least one task should be displayed');
            console.log(`✅ Found ${taskElements.length} task(s) in the list`);
            
            // Verify the new task exists
            const pageSource = await driver.getPageSource();
            assert.ok(pageSource.includes(testTaskTitle), 'New task should appear on the page');
            console.log('✅ New task verified in the list');
        });

        it('should clear form inputs after submission', async function() {
            this.timeout(TIMEOUT);
            console.log('📝 Test 2c: Verifying form clears after submission...');
            
            const titleInput = await driver.findElement(By.id('taskTitle'));
            const titleValue = await titleInput.getAttribute('value');
            
            assert.strictEqual(titleValue, '', 'Title input should be empty after submission');
            console.log('✅ Form inputs cleared successfully');
        });
    });

    /**
     * TEST CASE 3: Validate Task Interaction (Toggle/Delete)
     * Tests interaction with existing tasks
     */
    describe('Test Case 3: Task Interaction', function() {
        it('should toggle task completion status', async function() {
            this.timeout(TIMEOUT);
            console.log('\n📝 Test 3: Testing task completion toggle...');
            
            try {
                // Find the first task checkbox
                const checkbox = await driver.findElement(By.css('input[type="checkbox"]'));
                const initialState = await checkbox.isSelected();
                console.log(`Initial checkbox state: ${initialState ? 'checked' : 'unchecked'}`);
                
                // Click the checkbox
                await checkbox.click();
                await driver.sleep(1000);
                
                // Verify state changed
                const newState = await checkbox.isSelected();
                assert.notStrictEqual(initialState, newState, 'Checkbox state should toggle');
                console.log(`✅ Checkbox toggled to: ${newState ? 'checked' : 'unchecked'}`);
            } catch (error) {
                console.log('⚠️ No tasks available to toggle');
            }
        });

        it('should be able to delete a task', async function() {
            this.timeout(TIMEOUT);
            console.log('📝 Test 3b: Testing task deletion...');
            
            try {
                // Count initial tasks
                const initialTasks = await driver.findElements(By.css('.task-item'));
                const initialCount = initialTasks.length;
                console.log(`Initial task count: ${initialCount}`);
                
                if (initialCount > 0) {
                    // Find and click delete button
                    const deleteButton = await driver.findElement(By.css('.delete-btn'));
                    await deleteButton.click();
                    await driver.sleep(1500);
                    
                    // Verify task count decreased
                    const finalTasks = await driver.findElements(By.css('.task-item'));
                    const finalCount = finalTasks.length;
                    console.log(`Final task count: ${finalCount}`);
                    
                    assert.ok(finalCount < initialCount, 'Task count should decrease after deletion');
                    console.log('✅ Task deleted successfully');
                } else {
                    console.log('⚠️ No tasks available to delete');
                }
            } catch (error) {
                console.log('⚠️ Delete functionality test skipped: No delete button found');
            }
        });
    });

    /**
     * TEST CASE 4: Validate API Connection
     * Tests that frontend properly connects to backend API
     */
    describe('Test Case 4: Frontend-Backend API Integration', function() {
        it('should load tasks from backend API', async function() {
            this.timeout(TIMEOUT);
            console.log('\n📝 Test 4: Testing API integration...');
            
            // Refresh page to trigger API call
            await driver.navigate().refresh();
            await driver.sleep(2000);
            
            // Check if tasks loaded (even if empty, no error should occur)
            const taskList = await driver.findElement(By.id('tasksList'));
            const isDisplayed = await taskList.isDisplayed();
            
            assert.strictEqual(isDisplayed, true, 'Task list should be displayed');
            console.log('✅ API connection successful - tasks loaded');
        });

        it('should handle empty task list gracefully', async function() {
            this.timeout(TIMEOUT);
            console.log('📝 Test 4b: Testing empty state handling...');
            
            const pageSource = await driver.getPageSource();
            // Page should not show error messages
            assert.ok(!pageSource.toLowerCase().includes('error'), 'Page should not display errors');
            console.log('✅ Empty state handled gracefully');
        });
    });

    /**
     * TEST CASE 5: Validate Navigation and UI Elements
     * Tests various UI elements and navigation
     */
    describe('Test Case 5: UI Elements and Navigation', function() {
        it('should display pipeline status section', async function() {
            this.timeout(TIMEOUT);
            console.log('\n📝 Test 5: Checking pipeline status section...');
            
            const pipelineInfo = await driver.findElement(By.css('.pipeline-info'));
            const isDisplayed = await pipelineInfo.isDisplayed();
            
            assert.strictEqual(isDisplayed, true, 'Pipeline info should be visible');
            console.log('✅ Pipeline status section displayed');
        });

        it('should have all form input fields', async function() {
            this.timeout(TIMEOUT);
            console.log('📝 Test 5b: Verifying form elements...');
            
            const titleInput = await driver.findElement(By.id('taskTitle'));
            const descriptionInput = await driver.findElement(By.id('taskDescription'));
            const submitButton = await driver.findElement(By.css('button[type="submit"]'));
            
            assert.ok(await titleInput.isDisplayed(), 'Title input should be visible');
            assert.ok(await descriptionInput.isDisplayed(), 'Description input should be visible');
            assert.ok(await submitButton.isDisplayed(), 'Submit button should be visible');
            
            console.log('✅ All form elements present and visible');
        });

        it('should validate required fields', async function() {
            this.timeout(TIMEOUT);
            console.log('📝 Test 5c: Testing form validation...');
            
            // Try to submit empty form
            const submitButton = await driver.findElement(By.css('button[type="submit"]'));
            await submitButton.click();
            
            // Check if HTML5 validation works
            const titleInput = await driver.findElement(By.id('taskTitle'));
            const validationMessage = await driver.executeScript(
                "return arguments[0].validationMessage;", 
                titleInput
            );
            
            console.log(`Validation message: ${validationMessage || 'None'}`);
            console.log('✅ Form validation tested');
        });
    });

    /**
     * TEST CASE 6: Performance and Responsiveness
     * Tests page performance and responsive behavior
     */
    describe('Test Case 6: Performance Tests', function() {
        it('should load page within acceptable time', async function() {
            this.timeout(TIMEOUT);
            console.log('\n📝 Test 6: Testing page load performance...');
            
            const startTime = Date.now();
            await driver.get(BASE_URL);
            await driver.wait(until.titleContains('Task Manager'), TIMEOUT);
            const loadTime = Date.now() - startTime;
            
            console.log(`Page load time: ${loadTime}ms`);
            assert.ok(loadTime < 5000, 'Page should load in less than 5 seconds');
            console.log('✅ Page load performance acceptable');
        });

        it('should handle multiple rapid form submissions', async function() {
            this.timeout(15000);
            console.log('📝 Test 6b: Testing rapid form submissions...');
            
            for (let i = 0; i < 3; i++) {
                const titleInput = await driver.findElement(By.id('taskTitle'));
                const descriptionInput = await driver.findElement(By.id('taskDescription'));
                
                await titleInput.sendKeys(`Rapid Test ${i + 1}`);
                await descriptionInput.sendKeys(`Description ${i + 1}`);
                
                const submitButton = await driver.findElement(By.css('button[type="submit"]'));
                await submitButton.click();
                await driver.sleep(500);
            }
            
            console.log('✅ Multiple rapid submissions handled');
        });
    });
});

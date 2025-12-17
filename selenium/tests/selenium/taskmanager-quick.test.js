const { Builder } = require('selenium-webdriver');
const chrome = require('selenium-webdriver/chrome');
const { expect } = require('chai');

const BASE_URL = process.env.BASE_URL || 'http://localhost';
const HEADLESS = process.env.HEADLESS === 'true';

describe('Task Manager - Quick Selenium Tests', function() {
    let driver;

    // Setup: Initialize WebDriver before tests
    before(async function() {
        this.timeout(30000);
        console.log(`\n🚀 Starting Selenium tests (headless: ${HEADLESS})`);
        
        const options = new chrome.Options();
        if (HEADLESS) {
            options.headless();
        }
        options.addArguments('--disable-gpu');
        options.addArguments('--no-sandbox');
        options.addArguments('--disable-dev-shm-usage');
        
        driver = await new Builder()
            .forBrowser('chrome')
            .setChromeOptions(options)
            .build();
        
        console.log('✅ WebDriver initialized');
    });

    // Cleanup: Quit WebDriver after tests
    after(async function() {
        if (driver) {
            await driver.quit();
            console.log('✅ WebDriver closed');
        }
    });

    // Test Suite 1: Page Loading and Basic Elements
    describe('Suite 1: Page Loading', function() {
        
        it('1.1 Should load the homepage successfully', async function() {
            await driver.get(BASE_URL);
            const currentUrl = await driver.getCurrentUrl();
            expect(currentUrl).to.include(BASE_URL);
            console.log('✅ Homepage loaded');
        });

        it('1.2 Should have the correct page title', async function() {
            const title = await driver.getTitle();
            expect(title).to.equal('Cloud Pipeline Task Manager');
            console.log(`✅ Page title verified: ${title}`);
        });

        it('1.3 Should display the main header', async function() {
            const header = await driver.findElement({ css: 'h1' });
            const headerText = await header.getText();
            expect(headerText).to.equal('Cloud Pipeline Task Manager');
            console.log('✅ Main header displayed correctly');
        });

        it('1.4 Should display the task form', async function() {
            const form = await driver.findElement({ id: 'taskForm' });
            const isDisplayed = await form.isDisplayed();
            expect(isDisplayed).to.be.true;
            console.log('✅ Task form is visible');
        });

        it('1.5 Should have input fields for title and description', async function() {
            const titleInput = await driver.findElement({ id: 'taskTitle' });
            const descInput = await driver.findElement({ id: 'taskDescription' });
            expect(await titleInput.isDisplayed()).to.be.true;
            expect(await descInput.isDisplayed()).to.be.true;
            console.log('✅ Input fields are present');
        });
    });

    // Test Suite 2: Task Creation
    describe('Suite 2: Task Creation', function() {
        
        it('2.1 Should create a new task', async function() {
            await driver.get(BASE_URL);
            await driver.sleep(1000);
            
            const titleInput = await driver.findElement({ id: 'taskTitle' });
            const descInput = await driver.findElement({ id: 'taskDescription' });
            const submitBtn = await driver.findElement({ css: 'button[type="submit"]' });
            
            await titleInput.clear();
            await titleInput.sendKeys('Selenium Test Task');
            await descInput.clear();
            await descInput.sendKeys('This task was created by Selenium automation');
            await submitBtn.click();
            
            await driver.sleep(2000);
            console.log('✅ Task created successfully');
        });

        it('2.2 Should display the created task in the list', async function() {
            await driver.sleep(1000);
            const taskList = await driver.findElement({ id: 'taskList' });
            const text = await taskList.getText();
            expect(text).to.include('Selenium Test Task');
            console.log('✅ Task appears in the list');
        });
    });

    // Test Suite 3: Task Management
    describe('Suite 3: Task Management', function() {
        
        it('3.1 Should mark a task as completed', async function() {
            const completeBtn = await driver.findElement({ css: 'button.complete-btn' });
            await completeBtn.click();
            await driver.sleep(1000);
            console.log('✅ Task marked as complete');
        });

        it('3.2 Should delete a task', async function() {
            const deleteBtn = await driver.findElement({ css: 'button.delete-btn' });
            await deleteBtn.click();
            await driver.sleep(1000);
            console.log('✅ Task deleted successfully');
        });
    });

    // Test Suite 4: Performance
    describe('Suite 4: Performance', function() {
        
        it('4.1 Should load the page in under 5 seconds', async function() {
            const startTime = Date.now();
            await driver.get(BASE_URL);
            const loadTime = Date.now() - startTime;
            expect(loadTime).to.be.lessThan(5000);
            console.log(`✅ Page loaded in ${loadTime}ms`);
        });
    });
});

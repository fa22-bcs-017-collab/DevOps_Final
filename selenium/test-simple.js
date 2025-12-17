const { Builder } = require('selenium-webdriver');
const chrome = require('selenium-webdriver/chrome');

async function testDriver() {
    console.log('Testing ChromeDriver initialization...');
    
    let driver;
    try {
        const options = new chrome.Options();
        options.addArguments('--headless');
        options.addArguments('--disable-gpu');
        options.addArguments('--no-sandbox');
        options.addArguments('--disable-dev-shm-usage');
        
        console.log('Creating WebDriver...');
        driver = await new Builder()
            .forBrowser('chrome')
            .setChromeOptions(options)
            .build();
        
        console.log('✅ WebDriver created successfully!');
        
        console.log('Navigating to localhost...');
        await driver.get('http://localhost');
        
        const title = await driver.getTitle();
        console.log(`✅ Page title: ${title}`);
        
        console.log('✅ All tests passed!');
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    } finally {
        if (driver) {
            await driver.quit();
            console.log('WebDriver closed.');
        }
    }
}

testDriver();

'use strict';
const dhalang = require('./dhalang')

const createPdf = async () => {
    const configuration = dhalang.getConfiguration(true);

    let browser;
    try {
        browser = await dhalang.launchPuppeteer(configuration.puppeteerPath);
        const page = await browser.newPage();
        await page.goto(configuration.webPageUrl, dhalang.getNavigationParameters());
        await page.waitForTimeout(250);
        await page.screenshot({
            path: configuration.tempFilePath,
            type: configuration.imageType,
            fullPage: true
        });
    } catch (error) {
        console.log(error.message);
    } finally {
        if (browser) {
            browser.close();
        }
        process.exit();
    }
};
createPdf();
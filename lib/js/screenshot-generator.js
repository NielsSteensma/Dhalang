'use strict';
const dhalang = require('./dhalang')

const createPdf = async () => {
    const configuration = dhalang.getConfiguration();

    let browser;
    try {
        browser = await dhalang.launchPuppeteer(configuration.puppeteerPath);
        const page = await browser.newPage();
        await dhalang.configurePage(page, configuration.userOptions);
        await page.goto(configuration.webPageUrl, configuration.userOptions.navigationParameters);
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
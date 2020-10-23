'use strict';
const dhalang = require('./dhalang');

const createPdf = async () => {
    const configuration = dhalang.getConfiguration();

    let browser;
    try {
        browser = await dhalang.launchPuppeteer(configuration.puppeteerPath);
        const page = await browser.newPage();
        await dhalang.configurePage(page, configuration.userOptions);
        await page.goto(configuration.webPageUrl, configuration.userOptions.navigationParameters);
        await page.waitFor(250);
        await page.pdf({
            ...{ path: configuration.tempFilePath },
            ...configuration.pdfOptions
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

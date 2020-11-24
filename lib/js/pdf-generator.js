'use strict';
const dhalang = require('./dhalang');

const createPdf = async () => {
    const configuration = dhalang.getConfiguration();

    let browser;
    try {
        browser = await dhalang.launchPuppeteer(configuration);
        const page = await browser.newPage();
        await dhalang.configurePage(page, configuration.userOptions);
        await page.goto(configuration.webPageUrl, dhalang.getNavigationParameters(configuration));
        await page.waitForTimeout(250);
        await page.pdf({
            ...{
                path: configuration.tempFilePath
            },
            ...configuration.pdfOptions
        });
    } catch (error) {
        console.log(error.message);
        process.exit(1);
    } finally {
        if (browser) {
            browser.close();
        }
        process.exit();
    }
};
createPdf();
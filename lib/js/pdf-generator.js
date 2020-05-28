'use strict';
const dhalang = require('./dhalang');

const createPdf = async () => {
    const configuration = dhalang.getConfiguration(false);

    let browser;
    try {
        browser = await dhalang.launchPuppeteer(configuration.puppeteerModulePath);
        const page = await browser.newPage();
        await page.goto(configuration.webPageUrl, dhalang.getNavigationParameters());
        await page.waitFor(250);
        await page.pdf({
            path: configuration.tempFilePath,
            format: 'A4',
            margin: {
                top: 36,
                right: 36,
                bottom: 20,
                left: 36
            },
            printBackground: true
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
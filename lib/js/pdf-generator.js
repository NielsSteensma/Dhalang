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
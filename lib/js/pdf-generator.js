'use strict';
const dhalang = require('./dhalang');

const createPdf = async () => {
    const configuration = dhalang.getConfiguration();

    let browser;
    try {
        browser = await dhalang.launchPuppeteer(configuration);
        const page = await browser.newPage();
        await dhalang.configure(page, configuration.userOptions);
        await dhalang.navigate(page, configuration);

        await page.pdf({
            ...{
                path: configuration.tempFilePath
            },
            ...configuration.pdfOptions
        });
    } catch (error) {
        console.error(error.message);
        process.exit(1);
    } finally {
        if (browser) {
            browser.close();
        }
        process.exit();
    }
};
createPdf();
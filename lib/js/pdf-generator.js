'use strict';
const dhalang = require('./dhalang');

const createPdf = async () => {
    const configuration = dhalang.getConfiguration();

    let browser;
    let page;
    try {
        browser = await dhalang.launchPuppeteer(configuration);
        page = await browser.newPage();
        await dhalang.configure(page, configuration.userOptions);
        await dhalang.navigate(page, configuration);
        const pdfOptions = await dhalang.getConfiguredPdfOptions(page, configuration);
        await page.pdf({
            ...{
                path: configuration.tempFilePath
            },
            ...pdfOptions
        });
    } catch (error) {
        console.error(error.message);
        process.exit(1);
    } finally {
        if (browser && configuration.userOptions['browserWebsocketUrl'] === "") {
            browser.close();
        } else {
            page.close();
        }
        process.exit();
    }
};
createPdf();
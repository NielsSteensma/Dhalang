'use strict';
import {getConfiguration, getConfiguredPdfOptions, launchPuppeteer, configure, navigate} from './dhalang.js';

const createPdf = async () => {
    const configuration = getConfiguration();

    let browser;
    let page;
    try {
        browser = await launchPuppeteer(configuration);
        page = await browser.newPage();
        await configure(page, configuration.userOptions);
        await navigate(page, configuration);
        const pdfOptions = await getConfiguredPdfOptions(page, configuration);
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
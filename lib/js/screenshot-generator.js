'use strict';
import {getConfiguration, launchPuppeteer, configure, navigate} from './dhalang.js';

const createScreenshot = async () => {
    const configuration = getConfiguration();

    let browser;
    let page;
    try {
        browser = await launchPuppeteer(configuration);
        page = await browser.newPage();
        await configure(page, configuration.userOptions);
        await navigate(page, configuration);

        await page.screenshot({
            ...{
                path: configuration.tempFilePath,
                type: configuration.imageType,
            },
            ...(configuration.imageType === "jpeg") && configuration.jpegOptions,
            ...configuration.screenshotOptions
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
createScreenshot();
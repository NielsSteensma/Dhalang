'use strict';
const dhalang = require('./dhalang')

const createScreenshot = async () => {
    const configuration = dhalang.getConfiguration();

    let browser;
    let page;
    try {
        browser = await dhalang.launchPuppeteer(configuration);
        page = await browser.newPage();
        await dhalang.configure(page, configuration.userOptions);
        await dhalang.navigate(page, configuration);

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
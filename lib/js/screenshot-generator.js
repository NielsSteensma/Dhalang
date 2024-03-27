'use strict';
const dhalang = require('./dhalang')

const createScreenshot = async () => {
    const configuration = dhalang.getConfiguration();

    let browser;
    try {
        browser = await dhalang.launchPuppeteer(configuration);
        const page = await browser.newPage();
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
        if (browser) {
            browser.close();
        }
        process.exit();
    }
};
createScreenshot();
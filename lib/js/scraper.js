'use strict';
const dhalang = require('./dhalang');

const scrapePage = async () => {
    const configuration = dhalang.getConfiguration();

    let browser;
    try {
        browser = await dhalang.launchPuppeteer(configuration);
        const page = await browser.newPage();
        await dhalang.configure(page, configuration.userOptions);
        await dhalang.navigate(page, configuration);
        const html = await page.content();
        console.log(html);
    } catch (error) {
        console.error(error.message);
        process.exit(1);
    } finally {
        if (browser) {
            browser.close();
        }
        process.exit(0);
    }
};
scrapePage();
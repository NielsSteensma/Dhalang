'use strict';
import {getConfiguration, launchPuppeteer, configure, navigate} from './dhalang.js';
import fs from 'node:fs';

const scrapeHtml = async () => {
    const configuration = getConfiguration();

    let browser;
    let page;
    try {
        browser = await launchPuppeteer(configuration);
        page = await browser.newPage();
        await configure(page, configuration.userOptions);
        await navigate(page, configuration);
        const html = await page.content();
        fs.writeFileSync(configuration.tempFilePath, html);
    } catch (error) {
        console.error(error.message);
        process.exit(1);
    } finally {
        if (browser && configuration.userOptions['browserWebsocketUrl'] === "") {
            browser.close();
        } else {
            page.close();
        }
        process.exit(0);
    }
};
scrapeHtml();
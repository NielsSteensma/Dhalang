'use strict';

const createPdf = async() => {
    module.paths.push(process.argv[4]);
    const puppeteer = require('puppeteer');
    let browser;
    try {
        browser = await puppeteer.launch({args: ['--no-sandbox', '--disable-setuid-sandbox']});
        const page = await browser.newPage();
        await page.goto(process.argv[2], {timeout: 10000, waitUntil: 'networkidle2'});
        await page.waitFor(250);
        await page.screenshot({
            path: process.argv[3]
        });
    } catch (err) {
        console.log(err.message);
    } finally {
        if (browser) {
            browser.close();
        }
        process.exit();
    }
};
createPdf();
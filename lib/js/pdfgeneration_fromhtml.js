'use strict';

const puppeteer = require('puppeteer');

const createPdf = async() => {
    let browser;
    try {
        browser = await puppeteer.launch({args: ['--no-sandbox', '--disable-setuid-sandbox']});
        const page = await browser.newPage();
        await page.goto(process.argv[2], {timeout: 10000, waitUntil: 'networkidle2'});
        await page.waitFor(250);
        await page.pdf({
            path: process.argv[3],
            format: 'A4',
            margin: { top: 36, right: 36, bottom: 20, left: 36 },
            printBackground: true
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
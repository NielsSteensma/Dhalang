/**
 * @typedef {Object} Configuration
 * @property {string} webPageUrl - The url of the webpage to visit.
 * @property {string} tempFilePath - The path of the tempfile to write the screenshot/pdf to.
 * @property {string} puppeteerModulePath - The path of the Puppeteer module.
 * @property {string} imageType - The type of image to save ( undefined for pdfgenerator ).
 */

/**
 * @typedef {Object} NavigationParameters
 * @property {number} timeout - Maximum in milliseconds until navigation times out, we use a default of 10 seconds as timeout.
 * @property {string} waituntil - Determines when the navigation was finished, we wait here until the Window.load event is fired ( meaning all images, stylesheet, etc was loaded ).
 */

/**
 * Generates a configuration object based on the given process arguments from Ruby.
 * @param {Boolean} isForScreenshotGenerator - Indicates if this configuration is for a screenshot generator.
 * @returns {Configuration}
 * The generated configuration object.
 */
exports.getConfiguration = function (isForScreenshotGenerator) {
    return {
        webPageUrl: process.argv[2],
        tempFilePath: process.argv[3],
        puppeteerPath: process.argv[4],
        imageType: isForScreenshotGenerator ? process.argv[5] : undefined
    }
}

/**
 * Launches Puppeteer and returns its instance.
 * @param {string} puppeteerModulePath - The path puppeteer is under.
 * @returns {Promise<Object>} 
 * The launched instance of Puppeteer.
 */
exports.launchPuppeteer = async function (puppeteerModulePath) {
    module.paths.push(puppeteerModulePath);
    const puppeteer = require('puppeteer');
    return await puppeteer.launch({
        args: ['--no-sandbox', '--disable-setuid-sandbox']
    });
}

/**
 * Returns a new object containing the navigation parameters to use when navigating with Puppeteer to web pages.
 * @returns {NavigationParameters}
 * The navigation parameters to use.
 */
exports.getNavigationParameters = function () {
    return {
        timeout: 10000,
        waitUntil: 'load'
    }
}
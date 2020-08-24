/**
 * @typedef {Object} Configuration
 * @property {string} webPageUrl            - The url of the webpage to visit.
 * @property {string} tempFilePath          - The path of the tempfile to write the screenshot/pdf to.
 * @property {string} puppeteerModulePath   - The path of the Puppeteer module.
 * @property {string} imageType             - The type of image to save ( undefined for pdfgenerator ).
 * @property {UserOptions} userOptions      - User defined and default parameters to use when navigating to pages with Puppeteer.
 */
/**
 * @typedef {Object} UserOptions
 * @property {NavigationParameters} navigationParameters - The parameters to use when navigating to pages with Puppeteer.
 * @property {string} userAgent             - The user agent to send with requests.
 */

/**
 * @typedef {Object} NavigationParameters
 * @property {number} timeout               - Maximum in milliseconds until navigation times out, we use a default of 10 seconds as timeout.
 * @property {string} waituntil             - Determines when the navigation was finished, we wait here until the Window.load event is fired ( meaning all images, stylesheet, etc was loaded ).
 */

/**
 * Parses the given configuration process argument from Ruby to a JS object.
 * @returns {Configuration}
 * The configuration object.
 */
exports.getConfiguration = function () {
    return JSON.parse(process.argv[2])
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
 * Configures the given Puppeteer page.
 * @param {Object} page - The Puppeteer page to configure.
 * @param {UserOptions} configuration - The configuration to use.
 */
exports.configurePage = async function (page, configuration) {
    if (configuration.userAgent !== "") {
        await page.setUserAgent(configuration.userAgent)
    }
}
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
 * @property {number} navigationTimeout             - Maximum in milliseconds until navigation times out, we use a default of 10 seconds as timeout.
 * @property {string} navigationWaitUntil           - Determines when the navigation was finished, we wait here until the Window.load event is fired ( meaning all images, stylesheet, etc was loaded ).
 * @property {string} userAgent                     - The user agent to send with requests.
 * @property {boolean} isHeadless                   - Indicates if Puppeteer should launch Chromium in headless mode.
 * @property {Object} viewPort                      - The view port to use.
 * @property {Object} httpAuthenticationCredentials - The credentials to use for HTTP authentication.
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
 * @param {UserOptions} configuration - The configuration to use.
 * @returns {Promise<Object>} 
 * The launched instance of Puppeteer.
 */
exports.launchPuppeteer = async function (configuration) {
    module.paths.push(configuration.puppeteerPath);
    const puppeteer = require('puppeteer');
    const launchArgs = ['--no-sandbox', '--disable-setuid-sandbox'];
    return await puppeteer.launch({
        args: launchArgs,
        headless: configuration.userOptions.isHeadless
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

    if (configuration.viewPort !== "") {
        await page.setViewport(configuration.viewPort)
    }

    if (configuration.httpAuthenticationCredentials !== "") {
        await page.authenticate(configuration.authenticationCredentials)
    }
}

/**
 * Extracts the navigation parameters from the configuration in a format that is usable by Puppeteer.
 * @param {Configuration} configuration - The configuration to extract the navigation parameters from.
 * @returns {NavigationParameters} 
 * The extracted navigation parameters.
 */
exports.getNavigationParameters = function (configuration) {
    return {
        timeout: configuration.userOptions.navigationTimeout,
        waituntil: configuration.userOptions.navigationWaitUntil
    }
}
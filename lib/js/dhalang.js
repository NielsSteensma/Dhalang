/**
 * @typedef {Object} Configuration
 * @property {string} webPageUrl            - The url of the webpage to visit.
 * @property {string} tempFilePath          - The path of the tempfile to write the screenshot/pdf to.
 * @property {string} puppeteerModulePath   - The path of the Puppeteer module.
 * @property {string} imageType             - The type of image to save ( undefined for pdfgenerator ).
 * @property {UserOptions} userOptions      - User defined and default parameters to use when navigating to pages.
 * @property {Object} pdfOptions            - User defined and default parameters to use when creating PDFs. Note: Do not use directly, rather use {@link getConfiguredPdfOptions}.
 * @property {Object} pngOptions            - User defined and default parameters to use when creating PNGs.
 * @property {Object} jpegOptions           - User defined and default parameters to use when creating JPEGs.
 */

/**
 * @typedef {Object} UserOptions
 * @property {number} navigationTimeout             - Maximum in milliseconds until navigation times out, we use a default of 10 seconds as timeout.
 * @property {string} navigationWaitUntil           - Determines when the navigation was finished, we wait here until the Window.load event is fired ( meaning all images, stylesheet, etc was loaded ).
 * @property {string} navigationWaitForSelector     - If set, specifies the selector Puppeteer should wait for to appear before continuing.
 * @property {string} navigationWaitForXPath        - If set, specifies the XPath Puppeteer should wait for to appear before continuing.
 * @property {string} userAgent                     - The user agent to send with requests.
 * @property {boolean} isHeadless                   - Indicates if Puppeteer should launch Chromium in headless mode.
 * @property {Object} viewPort                      - The view port to use.
 * @property {Object} httpAuthenticationCredentials - The credentials to use for HTTP authentication.
 * @property {boolean} isAutoHeight                 - The height is automatically set
 */

/**
 * @typedef {Object} NavigationParameters
 * @property {number} timeout               - Maximum in milliseconds until navigation times out, we use a default of 10 seconds as timeout.
 * @property {string} waituntil             - Determines when the navigation was finished, we wait here until the Window.load event is fired ( meaning all images, stylesheet, etc was loaded ).
 */

/**
 * @typedef {Object} WaitingParameters
 * @property {number} timeout               - Maximum in milliseconds until navigation times out, we use a default of 10 seconds as timeout.
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
 * Configures the given Puppeteer page object.
 * @param {Object} page - The Puppeteer page object to configure.
 * @param {UserOptions} userOptions - The user options to use.
 */
exports.configure = async function (page, userOptions) {
    if (userOptions.userAgent !== "") {
        await page.setUserAgent(userOptions.userAgent)
    }

    if (userOptions.viewPort !== "") {
        await page.setViewport(userOptions.viewPort)
    }

    if (userOptions.httpAuthenticationCredentials !== "") {
        await page.authenticate(userOptions.httpAuthenticationCredentials)
    }
}

/**
 * Makes the Puppeteer page object open the url with the specified navigation logic as specified in the given configuration.
 * @param {Object} page - The Puppeteer page object to use for navigation.
 * @param {Configuration} configuration - The configuration to use. 
 */
exports.navigate = async function (page, configuration) {
    const navigationWaitForSelector = configuration.userOptions.navigationWaitForSelector;
    const navigationWaitForXPath = configuration.userOptions.navigationWaitForXPath;

    await page.goto(configuration.webPageUrl, this.getNavigationParameters(configuration));

    if (navigationWaitForSelector !== "") {
        await page.waitForSelector(navigationWaitForSelector, this.getWaitingParameters(configuration));
    } else if (navigationWaitForXPath !== "") {
        await page.waitForXPath(navigationWaitForXPath, this.getWaitingParameters(configuration));
    } else {
        await page.waitForTimeout(250);
    }
}

/**
 * Returns the PDF options to pass to Puppeteer based on the set user options and the documents body.  
 * @param {Object} page - The Puppeteer page to configure.
 * @param {UserOptions} configuration - The configuration to use.
 * @returns {Object} - pdfOptions
 */
exports.getConfiguredPdfOptions = async function (page, configuration) {
    const pdfOptions = configuration.pdfOptions

    if (configuration.userOptions.isAutoHeight === true) {
        const pageHeight = await page.evaluate(() => {
            return Math.max(document.body.scrollHeight, document.body.offsetHeight);
        })
        if (pageHeight) {
            pdfOptions['height'] = pageHeight + 1 + 'px'
        }
    }

    return pdfOptions
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


/**
 * Extracts the waiting parameters from the configuration in a format that is usable by Puppeteer.
 * @param {Configuration} configuration - The configuration to extract the waiting parameters from.
 * @returns {WaitingParameters} 
 * The extracted waiting parameters.
 */
exports.getWaitingParameters = function (configuration) {
    return {
        timeout: configuration.userOptions.navigationTimeout
    }
}

import JsonUtils from './json';
import { Logger } from './logger';

/* global VERSION */

/**
 * This class provides utility methods to handle and store data.
 */
export default class DataHandler {

  /**
   * Default Constructor
   */
  constructor() {
    /**
     * Stores the data object
     * @type {object}
     */
    this.data = undefined;
  }

  /**
   * Loads and stores data if valid
   *
   * @param {string} json - a francy valid json
   * @param {boolean} partial - set this to true if the json is not a complete francy json object
   * @returns {object} this instance
   * @public
   */
  load(json, partial) {
    let data = JsonUtils.parse(json, partial);
    if (data) {
      this.data = data;
      if (this.data.version !== VERSION) {
        Logger.warn(`Data was generated in Francy GAP v${this.data.version} and you're using Francy JS v${VERSION}... Rendering may fail, please update your system...`);
      }
    }
    return this;
  }

}

/* global exports */
"use strict";

exports.interval = function(ms) {
    return function(action) {
        return function() {
            return setInterval(action, ms);
        }
    }
};

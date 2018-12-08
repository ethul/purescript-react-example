'use strict';

exports.blur = function blur(ref) {
  return function () {
    return ref.blur();
  };
}

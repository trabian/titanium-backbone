// Found at https://github.com/Meettya/whet.extend

// Copyright (c) 2012 Dmitrii Karpich

// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

var extend, _findValue, _isClass, _isOwnProp, _isPlainObj, _isPrimitiveType, _isTypeOf, _prepareClone,
  __slice = [].slice;

module.exports = extend = function() {
  var args, copy, deep, name, options, target, _i, _len, _ref;
  deep = arguments[0], target = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
  if (!_isClass(deep, 'Boolean')) {
    args.unshift(target);
    _ref = [deep || {}, false], target = _ref[0], deep = _ref[1];
  }
  if (_isPrimitiveType(target)) {
    target = {};
  }
  for (_i = 0, _len = args.length; _i < _len; _i++) {
    options = args[_i];
    if (options != null) {
      for (name in options) {
        copy = options[name];
        if ((copy != null) && target[name] !== copy) {
          target[name] = _findValue(deep, copy, target[name]);
        }
      }
    }
  }
  return target;
};

/*
Internal methods from now
*/


_isClass = function(obj, str) {
  return ("[object " + str + "]") === Object.prototype.toString.call(obj);
};

_isOwnProp = function(obj, prop) {
  return Object.prototype.hasOwnProperty.call(obj, prop);
};

_isTypeOf = function(obj, str) {
  return str === typeof obj;
};

_isPlainObj = function(obj) {
  var key;
  if (!obj) {
    return false;
  }
  if (obj.nodeType || obj.setInterval || !_isClass(obj, 'Object')) {
    return false;
  }
  if (obj.constructor && !_isOwnProp(obj, 'constructor') && !_isOwnProp(obj.constructor.prototype, 'isPrototypeOf')) {
    return false;
  }
  for (key in obj) {
    key;

  }
  return key === void 0 || _isOwnProp(obj, key);
};

_isPrimitiveType = function(obj) {
  return !(_isTypeOf(obj, 'object') || _isTypeOf(obj, 'function'));
};

_prepareClone = function(copy, src) {
  if (_isClass(copy, 'Array')) {
    if (_isClass(src, 'Array')) {
      return src;
    } else {
      return [];
    }
  } else {
    if (_isPlainObj(src)) {
      return src;
    } else {
      return {};
    }
  }
};

_findValue = function(deep, copy, src) {
  var clone;
  if (deep && (_isClass(copy, 'Array') || _isPlainObj(copy))) {
    clone = _prepareClone(copy, src);
    return extend(deep, clone, copy);
  } else {
    return copy;
  }
};

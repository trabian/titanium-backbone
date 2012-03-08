(function() {
  var log, stringify, _oldAlert,
    __slice = Array.prototype.slice;

  stringify = function(statements) {
    var statement, strings;
    strings = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = statements.length; _i < _len; _i++) {
        statement = statements[_i];
        if (_.isString(statement)) {
          _results.push(statement);
        } else {
          _results.push(JSON.stringify(statement));
        }
      }
      return _results;
    })();
    return strings.join(' ');
  };

  log = function(level, statements) {
    Ti.API.log(level, stringify(statements));
  };

  this.console = {
    debug: function() {
      var statements;
      statements = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return this.log(statements);
    },
    log: function() {
      var statements;
      statements = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return log('debug', statements);
    },
    info: function() {
      var statements;
      statements = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return log('info', statements);
    },
    warn: function() {
      var statements;
      statements = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return log('warn', statements);
    },
    error: function() {
      var statements;
      statements = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return log('error', statements);
    }
  };

  _oldAlert = this.alert;

  this.alert = function() {
    var statements;
    statements = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return _oldAlert(stringify(statements));
  };

}).call(this);

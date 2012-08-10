var Ti, Titanium, TitaniumButton, TitaniumButtonBar, TitaniumNavigationGroup, TitaniumTextField, TitaniumView, TitaniumWindow,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

Ti = Titanium = {};

Ti.App = {};

Ti.App.Properties = {
  store: {},
  getString: function(key) {
    return Ti.App.Properties.store[key];
  },
  setString: function(key, value) {
    return Ti.App.Properties.store[key] = value;
  }
};

Ti.Platform = {
  createUUID: function() {
    return 'this-is-a-random-string';
  }
};

Ti.UI = {
  createWindow: function(attributes) {
    return console.log('Create window');
  },
  SIZE: 'size'
};

Ti.UI.iPhone = {
  TableViewCellSelectionStyle: 'table-view-cell-selection-style',
  SystemButtonStyle: {
    DONE: 'done'
  }
};

TitaniumView = (function() {

  function TitaniumView(attributes) {
    var name, value;
    for (name in attributes) {
      value = attributes[name];
      this[name] = value;
    }
    this.children = [];
  }

  TitaniumView.prototype.addEventListener = function(name, event) {
    return this.on(name, event);
  };

  TitaniumView.prototype.add = function(view) {
    return this.children.push(view);
  };

  TitaniumView.prototype.remove = function(view) {
    return this.children = _.without(this.children, view);
  };

  TitaniumView.prototype.getChildren = function() {
    return this.children;
  };

  return TitaniumView;

})();

Ti.UI.createView = function(attributes) {
  return new TitaniumView(attributes);
};

_.extend(TitaniumView.prototype, Backbone.Events);

TitaniumButton = (function(_super) {

  __extends(TitaniumButton, _super);

  function TitaniumButton() {
    TitaniumButton.__super__.constructor.apply(this, arguments);
  }

  return TitaniumButton;

})(TitaniumView);

Ti.UI.createButton = function(attributes) {
  return new TitaniumButton(attributes);
};

TitaniumButtonBar = (function(_super) {

  __extends(TitaniumButtonBar, _super);

  function TitaniumButtonBar() {
    TitaniumButtonBar.__super__.constructor.apply(this, arguments);
  }

  return TitaniumButtonBar;

})(TitaniumView);

Ti.UI.createButtonBar = function(attributes) {
  return new TitaniumButtonBar(attributes);
};

TitaniumTextField = (function(_super) {

  __extends(TitaniumTextField, _super);

  function TitaniumTextField() {
    TitaniumTextField.__super__.constructor.apply(this, arguments);
  }

  TitaniumTextField.prototype.setValue = function(value) {
    this.value = value;
    return this.trigger('change', {
      value: this.value
    });
  };

  return TitaniumTextField;

})(TitaniumView);

Ti.UI.createTextField = function(attributes) {
  return new TitaniumTextField(attributes);
};

TitaniumWindow = (function(_super) {

  __extends(TitaniumWindow, _super);

  function TitaniumWindow() {
    TitaniumWindow.__super__.constructor.apply(this, arguments);
  }

  TitaniumWindow.prototype.open = function() {
    return this.trigger('open');
  };

  TitaniumWindow.prototype.close = function() {
    return this.trigger('close');
  };

  return TitaniumWindow;

})(TitaniumView);

Ti.UI.createWindow = function(attributes) {
  return new TitaniumWindow(attributes);
};

TitaniumNavigationGroup = (function(_super) {

  __extends(TitaniumNavigationGroup, _super);

  function TitaniumNavigationGroup() {
    TitaniumNavigationGroup.__super__.constructor.apply(this, arguments);
  }

  TitaniumNavigationGroup.prototype.open = function() {
    return this.trigger('open');
  };

  TitaniumNavigationGroup.prototype.close = function() {
    return this.trigger('close');
  };

  return TitaniumNavigationGroup;

})(TitaniumView);

Ti.UI.iPhone.createNavigationGroup = function(attributes) {
  return new TitaniumNavigationGroup(attributes);
};
(function() {
  var addClass, binaryDisplay, body, clockType, find, findAll, form, hasClass, init, nodes, pad, removeClass, runClock, showHelp, theme, updateDisplay, updateTime;

  hasClass = function(el, className) {
    return new RegExp(" " + className + " ").test(" " + el.className + " ");
  };

  addClass = function(el, className) {
    console.log(el.className);
    if (!hasClass(el, className)) {
      el.className += " " + className;
    }
    console.log(el.className);
    return el;
  };

  removeClass = function(el, className) {
    var newClass;
    if (!className) {
      el.className = "";
    } else {
      newClass = " " + el.className.replace(/[\t\r\n]/g, " ") + " ";
      if (hasClass(el, className)) {
        while (newClass.indexOf(" " + className + " ") >= 0) {
          newClass = newClass.replace(" " + className + " ", " ");
        }
        el.className = newClass.replace(/^\s+|\s+$/g, "");
      }
    }
    return el;
  };

  find = function(selector, scope) {
    var el;
    el = document.querySelector(selector);
    if (scope != null) {
      el = scope.querySelector(selector);
    }
    return el;
  };

  findAll = function(selector, scope) {
    var el;
    el = document.querySelectorAll(selector);
    if (scope != null) {
      el = scope.querySelectorAll(selector);
    }
    return el;
  };

  pad = function(num, amount) {
    while (num.toString().length < amount) {
      num = '0' + num;
    }
    return num;
  };

  clockType = localStorage.getItem('clock-type' || '12');

  showHelp = localStorage.getItem('show-help' || 'no');

  theme = localStorage.getItem('theme' || 'default');

  nodes = {
    seconds: find('.seconds'),
    minutes: find('.minutes'),
    hours: find('.hours')
  };

  body = find('body');

  binaryDisplay = find('.binary-display');

  form = find('.modal-content');

  updateTime = function(currently) {
    var binaryTime, circles, className, index, key, node, time, value, _results;
    _results = [];
    for (key in currently) {
      value = currently[key];
      node = nodes[key];
      binaryTime = pad(value.toString(2), 6).split('');
      time = key === 'hours' ? value : pad(value, 2);
      find('.time', node).innerHTML = time;
      circles = findAll('.circle', node);
      className = 'circle-active';
      index = 0;
      _results.push((function() {
        var _results1;
        _results1 = [];
        while (index < circles.length) {
          removeClass(circles[index], className);
          console.log(binaryTime[index]);
          if (binaryTime[index] === '1') {
            addClass(circles[index], className);
          }
          _results1.push(index++);
        }
        return _results1;
      })());
    }
    return _results;
  };

  updateDisplay = function() {
    addClass(binaryDisplay, 'hide-help');
    if (showHelp === "yes") {
      removeClass(binaryDisplay, 'hide-help');
      find("input[name='helper'][value='" + showHelp + "']", form).setAttribute('checked', true);
    }
    find("input[name='clock-type'][value='" + clockType + "']", form).setAttribute('checked', true);
    removeClass(body);
    addClass(body, theme);
    return find("input[name='theme'][value='" + theme + "']", form).setAttribute('checked', true);
  };

  runClock = function() {
    var currently, localTime;
    localTime = new Date();
    currently = {
      seconds: localTime.getSeconds(),
      minutes: localTime.getMinutes(),
      hours: clockType === '24' ? localTime.getHours() : localTime.getHours() % 12
    };
    return updateTime(currently);
  };

  init = function() {
    var clock;
    find('.settings-modal .btn').onclick = function(e) {
      clockType = find("input[name='clock-type']:checked", form).value;
      localStorage.setItem('clock-type', clockType);
      showHelp = find("input[name='helper']:checked", form).value;
      localStorage.setItem('show-help', showHelp);
      theme = find("input[name='theme']:checked", form).value;
      localStorage.setItem('theme', theme);
      return updateDisplay();
    };
    runClock();
    clock = setInterval(runClock, 1000);
    return updateDisplay();
  };

  init();

}).call(this);

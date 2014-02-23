(function() {
  var $binaryDisplay, $body, $form, $nodes, clock, clockType, pad, runClock, showHelp, theme, updateDisplay, updateTime;

  clockType = localStorage.getItem('clock-type') || '12';

  showHelp = localStorage.getItem('show-help') || 'no';

  theme = localStorage.getItem('theme') || 'default';

  pad = function(num, amount) {
    while (num.toString().length < amount) {
      num = '0' + num;
    }
    return num;
  };

  updateTime = function(currently) {
    var $circles, $node, binaryTime, key, time, value, _results;
    _results = [];
    for (key in currently) {
      value = currently[key];
      $node = $nodes[key];
      binaryTime = pad(value.toString(2), 6).split('');
      time = key === 'hours' ? value : pad(value, 2);
      $node.find('.time').html(time);
      $circles = $node.find('.circle');
      _results.push($circles.each(function(index, item) {
        var $el, cls;
        $el = $(item);
        cls = 'circle-active';
        $el.removeClass(cls);
        if (binaryTime[index] === '1') {
          return $el.addClass(cls);
        }
      }));
    }
    return _results;
  };

  updateDisplay = function() {
    $binaryDisplay.addClass('hide-help');
    if (showHelp === "yes") {
      $binaryDisplay.removeClass('hide-help');
      $form.find("input[name='helper'][value='" + showHelp + "']").prop('checked', true);
    }
    $form.find("input[name='clock-type'][value='" + clockType + "']").prop('checked', true);
    $body.removeClass().addClass(theme);
    return $form.find("input[name='theme'][value='" + theme + "']").prop('checked', true);
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

  $nodes = {
    seconds: $('.seconds'),
    minutes: $('.minutes'),
    hours: $('.hours')
  };

  $form = $('.modal-content');

  $body = $('body');

  $binaryDisplay = $('.binary-display');

  runClock();

  clock = setInterval(runClock, 1000);

  updateDisplay();

  $('.settings-modal .btn').on('click', function(e) {
    clockType = $form.find("input[name='clock-type']:checked").val();
    localStorage.setItem('clock-type', clockType);
    showHelp = $form.find("input[name='helper']:checked").val();
    localStorage.setItem('show-help', showHelp);
    theme = $form.find("input[name='theme']:checked").val();
    localStorage.setItem('theme', theme);
    return updateDisplay();
  });

}).call(this);

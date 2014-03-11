# Local storage & defaults
clockType = localStorage.getItem 'clock-type' or '12'
showHelp = localStorage.getItem 'show-help' or 'no'
theme = localStorage.getItem 'theme' or 'default'

#dom elements
nodes =
  seconds: find '.seconds'
  minutes: find '.minutes'
  hours: find '.hours'

body = find 'body'
binaryDisplay = find '.binary-display'

form = find '.modal-content'

updateTime = (currently) ->
  for key, value of currently
    node = nodes[key]
    binaryTime = pad(value.toString(2), 6).split('')
    time = if key == 'hours' then value else pad value, 2
    find('.time', node).innerHTML = time

    circles = findAll '.circle', node
    className = 'circle-active'

    index = 0
    while index < circles.length
      removeClass circles[index], className
      if binaryTime[index] == '1'
        addClass circles[index], className
      index++

updateDisplay = ->
  addClass binaryDisplay, 'hide-help'

  if showHelp == "yes"
    removeClass binaryDisplay, 'hide-help'

    find "input[name='helper'][value='#{showHelp}']", form
      .setAttribute 'checked', true

  find "input[name='clock-type'][value='#{clockType}']", form
    .setAttribute 'checked', true

  removeClass body
  addClass body, theme

  find "input[name='theme'][value='#{theme}']", form
    .setAttribute 'checked', true

runClock = ->
  localTime = new Date()
  currently =
    seconds: localTime.getSeconds()
    minutes: localTime.getMinutes()
    hours: if clockType == '24'
    then localTime.getHours()
    else localTime.getHours() % 12

  updateTime(currently)

init = ->
  find('.settings-modal .btn').onclick = (e) ->
    clockType = find("input[name='clock-type']:checked", form).value
    localStorage.setItem 'clock-type', clockType

    showHelp = find("input[name='helper']:checked", form).value
    localStorage.setItem 'show-help', showHelp

    theme = find("input[name='theme']:checked", form).value
    localStorage.setItem 'theme', theme

    updateDisplay()

  runClock()
  clock = setInterval runClock, 1000
  updateDisplay()

init()

# Local storage & defaults
clockType = localStorage.getItem 'clock-type' or '12'
showHelp = localStorage.getItem 'show-help' or 'no'
theme = localStorage.getItem 'theme' or 'default'
clockMode = localStorage.getItem 'clock-mode' or 'tbd'

#dom elements
tbdNodes =
  seconds: find '.seconds'
  minutes: find '.minutes'
  hours: find '.hours'

bcdNodes =
  one: find '.one'
  two: find '.two'
  four: find '.four'
  eight: find '.eight'
    
body = find 'body'

tbd = find '#true-binary'
bcd = find '#binary-coded'

bcdTimeNode = find '.time', bcd
form = find '.modal-content'

activeCls = 'circle-active'


bcdTime = (currently) ->
  updateCircles = (position, num, time) ->
    # set time
    find(position, bcdTimeNode).innerHTML = time
    
    circles = {}
    
    for key, value of bcdNodes
      circles[key] = find '.circle', find(position, value)
      removeClass circles[key], activeCls
      
    addClass(circles.one, activeCls) if num % 2 == 1    
    addClass(circles.two, activeCls) if num == 2 or num == 3 or num == 6 or num == 7  
    addClass(circles.four, activeCls) if num <= 7 && num >= 4    
    addClass(circles.eight, activeCls) if num >= 8 
      
  for key, value of currently
    time = pad(value.toString(), 2).split('')
    tens = parseInt(time[0], 10)
    ones = parseInt(time[1], 10) % 10
    
    updateCircles(".#{key}.tens", tens, time[0])
    updateCircles(".#{key}.ones", ones, time[1])

tbdTime = (currently) ->
  for key, value of currently
    node = tbdNodes[key]
    time = if key == 'hours' then value else pad value, 2
    binaryTime = pad(value.toString(2), 6).split('')

    find('.time', node).innerHTML = time

    circles = findAll '.circle', node
    index = 0
    while index < circles.length
      removeClass circles[index], activeCls
      if binaryTime[index] == '1'
        addClass circles[index], activeCls
      index++

updateDisplay = ->
  # clock mode: BCD or TBD
  clock = removeClass bcd, 'hide'
  addClass tbd, 'hide'
  
  if clockMode == 'tbd'
    clock = removeClass tbd, 'hide'
    addClass bcd, 'hide'
    
  find "input[name='clock-mode'][value='#{clockMode}']", form
    .setAttribute 'checked', true
  
  # help
  addClass clock, 'hide-help'
  if showHelp == "yes"
    removeClass clock, 'hide-help'

    find "input[name='helper'][value='#{showHelp}']", form
      .setAttribute 'checked', true
  
  # clock type: 12 hour or 24 hour
  find "input[name='clock-type'][value='#{clockType}']", form
    .setAttribute 'checked', true

  # theme   
  removeClass body
  addClass body, theme

  find "input[name='theme'][value='#{theme}']", form
    .setAttribute 'checked', true
    
tick = ->
  localTime = new Date()
  currently =
    seconds: localTime.getSeconds()
    minutes: localTime.getMinutes()
    hours: localTime.getHours()
  
  currently.hours = currently.hours % 12 if clockType != '24'

  updateTime = if clockMode == "tbd" then tbdTime else bcdTime
  updateTime(currently)
    
init = ->
  find('.settings-modal .btn').onclick = (e) ->
    clockType = find("input[name='clock-type']:checked", form).value
    localStorage.setItem 'clock-type', clockType

    showHelp = find("input[name='helper']:checked", form).value
    localStorage.setItem 'show-help', showHelp

    theme = find("input[name='theme']:checked", form).value
    localStorage.setItem 'theme', theme
    
    clockMode = find("input[name='clock-mode']:checked", form).value
    localStorage.setItem 'clock-mode', clockMode

    updateDisplay()

  tick()
  clockCounter = setInterval tick, 1000
  updateDisplay()

init()

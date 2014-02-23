clockType = localStorage.getItem('clock-type') || '12'
showHelp = localStorage.getItem('show-help') || 'no'
theme = localStorage.getItem('theme') || 'default'

pad = (num, amount) ->
  while (num.toString().length < amount)
    num = '0' + num
  num

updateTime = (currently) ->
  for key, value of currently
    
    $node = $nodes[key]
    binaryTime = pad(value.toString(2), 6).split('')
    time = if key == 'hours' then value else pad(value, 2)
    $node.find('.time').html time
    
    $circles = $node.find('.circle')
    $circles.each((index, item) ->
      $el = $(item)
      cls = 'circle-active'
      $el.removeClass(cls)
      if (binaryTime[index] == '1')
        $el.addClass(cls)
    )

updateDisplay = () ->
  $binaryDisplay.addClass('hide-help')
  if showHelp == "yes"
    $binaryDisplay.removeClass('hide-help')
    $form
      .find("input[name='helper'][value='#{showHelp}']")
      .prop('checked', true)

  $form
    .find("input[name='clock-type'][value='#{clockType}']")
    .prop('checked', true)

  $body.removeClass().addClass(theme)
  $form.find("input[name='theme'][value='#{theme}']").prop('checked', true)

runClock = ->
  localTime = new Date()
  currently =
    seconds: localTime.getSeconds()
    minutes: localTime.getMinutes()
    hours: if clockType == '24'
    then localTime.getHours()
    else localTime.getHours() % 12

  updateTime(currently)

$nodes =
  seconds: $('.seconds')
  minutes: $('.minutes')
  hours: $('.hours')
$form = $('.modal-content')
$body = $('body')
$binaryDisplay = $('.binary-display')

runClock()
clock = setInterval(runClock, 1000)
updateDisplay()

$('.settings-modal .btn').on('click', (e)->
  clockType = $form.find("input[name='clock-type']:checked").val()
  localStorage.setItem('clock-type', clockType)

  showHelp = $form.find("input[name='helper']:checked").val()
  localStorage.setItem('show-help', showHelp)

  theme = $form.find("input[name='theme']:checked").val()
  localStorage.setItem('theme', theme)

  updateDisplay()
  )
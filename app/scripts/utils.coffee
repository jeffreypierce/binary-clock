hasClass = (el, className) ->
  new RegExp(" " + className + " ").test " " + el.className + " "

addClass = (el, className) ->
  el.className += " " + className  unless hasClass el, className
  el

removeClass = (el, className) ->
  if !className
    el.className = ""
  else
    newClass = " " + el.className.replace(/[\t\r\n]/g, " ") + " "
    if hasClass el, className
      while newClass.indexOf(" " + className + " ") >= 0
        newClass = newClass.replace(" " + className + " ", " ")
      el.className = newClass.replace(/^\s+|\s+$/g, "")
  el

find = (selector, scope) ->
  el = document.querySelector selector
  if scope?
    el = scope.querySelector selector
  el

findAll = (selector, scope) ->
  el = document.querySelectorAll selector
  if scope?
    el = scope.querySelectorAll selector
  el

pad = (num, amount) ->
  while num.toString().length < amount
    num = '0' + num
  num

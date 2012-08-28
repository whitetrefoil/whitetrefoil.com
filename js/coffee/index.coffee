# Use strict mode
'use strict'

$ ->
  # ### Nav ###
  isDoing = 0
  hideHandle = 0

  showNav = () ->
    if isDoing is 0
      clearTimeout(hideHandle)
      isDoing = 2
      $('#nav').stop(true, true).fadeIn 400, ->
        isDoing = isDoing - 1
      $('#bgText').stop(true).fadeOut 400, ->
        isDoing = isDoing - 1
    return

  hideNav = () ->
    $('#nav').stop(true).fadeOut(400)
    $('#bgText').stop(true).fadeIn(400)
    return

  $('#page').mouseenter(showNav).mouseleave ->
    clearTimeout(hideHandle)
    hideHandle = setTimeout(hideNav, 800)

  # ### Color Themes ###
  changeTheme = (color) ->
    $('body#index').css('background-color', color)
    $('#bgText').css('background-color', color)
    $('#bgNoText').css('background-color', color)
    $('#nav > ul > li').css('color', color)

  $('#colors li').click ->
    $(this).addClass('cur').siblings().removeClass('cur')
    changeTheme($(this).children('a').css('background-color'))


  # Force Return To Avoid Too Long Return Chain In JS
  return

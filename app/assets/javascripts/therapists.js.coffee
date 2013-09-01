# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

makeChart = ->
  items = []
  htpEl = ($ '.happiness-through-period')
  htpEl.find('table').hide()
  htpEl.find('table td').each ->
    items.push(parseInt(($ this).text()))

  g = new Bluff.Line('client-mood-trend-happiness-through-period-canvas', htpEl.width() + 'x' + htpEl.height())
  g.theme_odeo()
  colors = [
      '#ff1493',
  ]
  g.set_theme({
    colors: colors,
    marker_color: '#aea9a9',
    font_color: 'black',
    background_colors: 'white'
  })
  g.hide_legend = true
  g.hide_title = true
  g.hide_line_markers = false

  g.data('Happiness', items)

  g.draw()

jQuery ->
  $('.dropdown').dropdown()
  if ($ '.client-mood-trend').length > 0
    makeChart()
    ($ window).resize ->
      makeChart()

  if ($ '#wysihtml5-textarea').length > 0
    editor = new wysihtml5.Editor('wysihtml5-textarea'
      toolbar:      'wysihtml5-toolbar'
      stylesheets:  '/stylesheets/wysiwyg.css'
      parserRules:  wysihtml5ParserRules
    )

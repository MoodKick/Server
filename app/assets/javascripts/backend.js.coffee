jQuery ->
  ($ 'nav[data-navbar-secondary]').hide()

  ($ 'nav a[data-menu-item]').click ->
    menuItem = ($ this).data('menu-item')
    ($ 'nav[data-navbar-secondary]').hide()
    ($ "nav[data-navbar-secondary][data-menu-item='#{menuItem}']").show()

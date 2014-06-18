jQuery ->
  $('body').on('mouseover', '[rel="popover"]', -> $(@).popover('show'))
  .on('mouseout', '[rel="popover"]', -> $(@).popover('hide'))
  .on('click', '[rel="popover"]', (e)-> e.preventDefault())
App.Model = [
   8, 25, 27, 25, 54, 59, 79, 47, 27, 44,
  44, 51, 56, 83, 12, 91, 52, 12, 40,  8,
  60, 29,  7, 33, 56, 25,  1, 78, 70, 68,
   2]

$ () ->
  $('#model').html(JSON.stringify(App.Model))

  chart = new App.Chart

  $(window).resize ->
    chart.render()
  chart.render()
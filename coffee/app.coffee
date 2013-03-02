#App.Model = [
#  18, 25, 27, 25, 54, 59, 79, 47, 27, 44,
#  44, 51, 56, 83, 32, 91, 52, 22, 40, 18,
#  60, 29, 27, 33, 56, 25, 20, 78, 70, 68]

$ () ->
  if localStorage['App.Model'] and not App.Model
    App.Model = JSON.parse(localStorage['App.Model'])
  else
    App.Model = [
      18, 25, 27, 25, 54, 59, 79, 47, 27, 44,
      44, 51, 56, 83, 32, 91, 52, 22, 40, 18,
      60, 29, 27, 33, 56, 25, 20, 78, 70, 68]

  $('#model').html(JSON.stringify(App.Model))

  chart = new App.Chart

  $(window).resize ->
    chart.render()
  chart.render()
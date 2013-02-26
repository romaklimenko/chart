class App.Chart
  paper = undefined

  # private functions
  getAnchors = (p1x, p1y, p2x, p2y, p3x, p3y) ->
    l1 = (p2x - p1x) / 2
    l2 = (p3x - p2x) / 2
    a = Math.atan((p2x - p1x) / Math.abs(p2y - p1y))
    b = Math.atan((p3x - p2x) / Math.abs(p2y - p3y))
    a = Math.PI - a if p1y < p2y
    b = Math.PI - b if p3y < p2y

    alpha = Math.PI / 2 - ((a + b) % (Math.PI * 2)) / 2
    dx1 = l1 * Math.sin(alpha + a)
    dy1 = l1 * Math.cos(alpha + a)
    dx2 = l2 * Math.sin(alpha + b)
    dy2 = l2 * Math.cos(alpha + b)

    return {
      x1: p2x - dx1
      y1: p2y + dy1
      x2: p2x + dx2
      y2: p2y + dy2
    }

  renderDot = (x, y, index) ->
    innerCircle = paper.circle(x, y, 5).attr
      "cursor": "move"
      fill: "#FFF"
      stroke: "#009874"
      "stroke-width": 4

    outerCircle = paper.circle(x, y, 30).attr
      'cursor': 'move'
      fill: "transparent"
      stroke: "none"

    outerCircle.innerCircle = innerCircle

    outerCircle.data('index', index)

    @circles = [] if not @circles
    @circles.push(outerCircle)

    y = undefined

    max = 100
    Y = height() / max
    outerCircle.drag(
      # onmove
      (dx, dy) ->
        _y = Math.min(Math.max(y + dy, 15), height() - 15)
        App.Model[@data('index')] = Math.round(max - (_y / Y))
        @attr
          cy: Math.round(height() - Y * App.Model[@data('index')])
        @innerCircle.attr
          cy: Math.round(height() - Y * App.Model[@data('index')])
        @innerCircle.toFront()
        App.Model[@data('index')] = Math.round(max - (@attr('cy') / Y))
        $('#model').html(JSON.stringify(App.Model))
        renderPath()
      # onstart
      ->
        y = @attr("cy")
      # onend
      ->
        renderPath()
        renderDots()
      )

  renderDots = ->
    if @circles
      for circle in @circles
        circle?.innerCircle?.remove()
        circle?.remove()

    X = width() / App.Model.length
    max = 100
    Y = height() / max

    for i in [0..App.Model.length - 1]
      y = Math.round(height() - Y * App.Model[i])
      x = Math.round(X * (i + .5))

      renderDot x, y, i

  renderPath = ->
    X = width() / App.Model.length
    max = 100
    Y = height() / max

    @path?.remove()
    @bgpath?.remove()

    @path = paper.path().attr
      stroke: "#009874"
      "stroke-width": 4
      "stroke-linejoin": "round"

    @bgpath = paper.path().attr
      stroke: "none"
      opacity: .3
      fill: "#009874"

    for i in [0..App.Model.length - 1]
      y = Math.round(height() - Y * App.Model[i])
      x = Math.round(X * (i + .5))

      if i is 0
        p = ["M", x, y, "C", x, y]
        bgpp = ["M", X * .5, height(), "L", x, y, "C", x, y];

      if i isnt 0 and i < App.Model.length - 1
        Y0 = Math.round(height() - Y * App.Model[i - 1])
        X0 = Math.round(X * (i - .5))
        Y2 = Math.round(height() - Y * App.Model[i + 1])
        X2 = Math.round(X * (i + 1.5))

        a = getAnchors(X0, Y0, x, y, X2, Y2)
        p = p.concat([a.x1, a.y1, x, y, a.x2, a.y2])
        bgpp = bgpp.concat([a.x1, a.y1, x, y, a.x2, a.y2])

    p = p.concat([x, y, x, y]) # the last one
    @path.attr({path: p}).toBack()
    bgpp = bgpp.concat([x, y, x, y, "L", x, height(), "z"])
    @bgpath.attr({path: bgpp}).toBack()

  height = ->
    innerHeight - 70

  width = ->
    $('#chart').innerWidth()

  # public functions
  render: ->
    paper?.remove()
    paper = new Raphael(
      'chart',
      width(),
      height())
    renderPath()
    renderDots()
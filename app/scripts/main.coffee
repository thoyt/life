class Automaton
    constructor: (n, m) ->
        @n = n
        @m = m
        @grid = []
        @neighbors = []
        for i in [0..n-1]
            row = (0 for j in [0..m-1])
            @grid.push(row)
            @neighbors.push(row.slice())

    randomize: ->
        for i in [0..@n-1]
            row = @grid[i]
            for j in [0..@m-1]
                row[j] = if Math.random() < 0.3 then 1 else 0
   
    updateNeighbors: ->
        for i in [0..@n-1]
            for j in [0..@m-1]
                neighbors = 0
                if i > 0
                    if @grid[i-1][j] is 1 then neighbors++
                    if j > 0
                        if @grid[i-1][j-1] is 1 then neighbors++
                        if @grid[i][j-1] is 1 then neighbors++
                    if j < @m-1
                        if @grid[i-1][j+1] is 1 then neighbors++
                        if @grid[i][j+1] is 1 then neighbors++
                if i < @n-1
                    if @grid[i+1][j] is 1 then neighbors++
                    if j > 0
                        if @grid[i+1][j-1] is 1 then neighbors++
                    if j < @m-1
                        if @grid[i+1][j+1] is 1 then neighbors++
                @neighbors[i][j] = neighbors 

    step: (f) ->
        for i in [0..@n-1]
            for j in [0..@m-1]
                state = @grid[i][j]
                neighbors = @neighbors[i][j]
                @grid[i][j] = (f state, neighbors)

draw = (canvas, automaton) ->
    wCell = width / automaton.n
    hCell = height / automaton.m
    for i in [0..automaton.n-1]
        row = automaton.grid[i]
        for j in [0..automaton.m-1]
            e = row[j]
            if e is 1
                ctx.rect i * wCell, j * hCell, wCell, hCell
 
rule1 = (state, neighbors) ->
    alive = (state is 1)
    if alive 
        if (neighbors is 2 or neighbors is 3) then 1 else 0
    else
        if (neighbors is 3) then 1 else 0

width = 400
height = 400
canvas = document.createElement('canvas')
canvas.width = width
canvas.height = height 
container = document.getElementById('main')
container.appendChild(canvas)
ctx = canvas.getContext '2d'
ctx.fillStyle = 'red'

a = new Automaton 80, 80
a.randomize()
a.updateNeighbors()

play = ->
    ctx.clearRect(0, 0, width, height)
    ctx.beginPath()
    draw canvas, a
    ctx.fill()
    a.step rule1
    a.updateNeighbors()

setInterval play, 80

#imageData = ctx.getImageData(0, 0, width, height);
#draw = (canvas, grid) ->
    #mygrid = _.flatten grid
    #_.each mygrid, (e, i) ->
    #    imageData.data[4 * i] = e * 255
    #    imageData.data[4 * i + 3] = 255
    #ctx.putImageData(imageData, 10, 10)

stringify = (grid) ->
    _.reduce grid, ((memo, row) -> 
        for e in row
            c = if e is 1 then '@ ' else '. '
            memo += c
        memo += '\n'), ''


randomBit = ->
    if Math.random() < 0.3 then 1 else 0

sum = (list) -> 
    _.reduce list, ((memo, num) -> memo + num), 0

window.makeGrid = (n) -> 
    mygrid = []
    for i in [0..n-1]
        row = (0 for j in [0..n-1])
        mygrid.push(row)
    mygrid

randomizeGrid = (grid) ->
    N = grid.length
    for i in [0..N-1]
        row = grid[i]
        for j in [0..N-1]
            row[j] = randomBit()
    grid

getNeighborhood = (grid, i, j) ->
    neighborhood = makeGrid 3
    N = grid.length
    neighborhood[1][1] = grid[i][j]
    if i > 0
        neighborhood[0][1] = grid[i-1][j]
        if j > 0
            neighborhood[0][0] = grid[i-1][j-1]
            neighborhood[1][0] = grid[i][j-1]
        if j < N-1
            neighborhood[0][2] = grid[i-1][j+1]
            neighborhood[1][2] = grid[i][j+1]
    if i < N-1
        neighborhood[2][1] = grid[i+1][j]
        if j > 0
            neighborhood[2][0] = grid[i+1][j-1]
        if j < N-1
            neighborhood[2][2] = grid[i+1][j+1]
    neighborhood

step = (grid, f) -> 
    N = grid.length
    tempGrid = makeGrid N
    for i in [0..N-1]
        for j in [0..N-1]
            neighb = getNeighborhood grid, i, j
            tempGrid[i][j] = if (f neighb) then 1 else 0
    tempGrid

stringify = (grid) ->
    _.reduce grid, ((memo, row) -> 
        for e in row
            c = if e is 1 then '@ ' else '. '
            memo += c
        memo += '\n'), ''

draw = (canvas, grid) ->
    N = grid.length
    w = 600
    h = 600
    wCell = w / N
    hCell = h / N
    for i in [0..N-1]
        row = grid[i]
        for j in [0..N-1]
            e = row[j]
            if e is 1
                ctx.rect i * wCell, j * hCell, wCell, hCell
 
rule1 = (neighborhood) ->
    center = neighborhood[1][1]
    alive = center is 1
    numNeighbors = _.reduce neighborhood, 
        ((memo, row) -> memo += (sum row)), 0
    numNeighbors -= center
    if alive 
        (numNeighbors is 2 or numNeighbors is 3)
    else
        (numNeighbors is 3)

canvas = document.querySelector('canvas')
ctx = canvas.getContext '2d'
ctx.fillStyle = 'red'
grid = randomizeGrid makeGrid 300

play = ->
    ctx.clearRect(0, 0, 600, 600)
    ctx.beginPath()
    draw canvas, grid
    grid = step grid, rule1
    ctx.fill()

setInterval play, 200

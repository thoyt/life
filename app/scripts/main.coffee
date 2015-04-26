pow = Math.pow
rand = Math.random
floor = Math.floor

class FractalAutomaton
    constructor: (depth) ->
        @depth = depth
        @grid = []
        @neighbors = []
        @grid[0] = [[0]]
        for d in [1..depth]
            @grid[d] = []
            @neighbors[d] = [] 
            dim = pow(2, d)
            for i in [0..dim-1]
                row = (0 for j in [0..dim-1])
                @grid[d].push row
                @neighbors[d].push row.slice()

    randomize: (k) ->
        for d in [1..@depth]
            g = @grid[d]
            dim = pow 2, d
            for i in [0..dim-1]
                row = g[i]
                for j in [0..dim-1]
                    row[j] = if rand() < k then 1 else 0    
                
    updateNeighbors: -> 
        # 8 local neighbors
        # 4 children
        # 4 closest parents
        for d in [1..@depth]
            dParent = d - 1
            dimParent = pow 2, d-1
            gParent = @grid[dParent]

            gLocal = @grid[d]
            dim = pow 2, d

            if d < @depth
                dChild = d + 1
                gChild = @grid[dChild]
                dimChild = pow 2, dChild
            
            for i in [0..dim-1] 
                for j in [0..dim-1]
                    nbrs = 0
                    ip0 = floor i / 2
                    jp0 = floor j / 2
                    ip1 = if i % 2 is 0 then ip0 - 1 else ip0 + 1
                    jp1 = if j % 2 is 0 then jp0 - 1 else jp0 + 1
                    ip1 = (dimParent + ip1) %% dimParent
                    jp1 = (dimParent + jp1) %% dimParent
                    nbrs += gParent[ip0][jp0] + gParent[ip1][jp0]
                    nbrs += gParent[ip0][jp1] + gParent[ip1][jp1]

                    if (d < @depth)
                        ic0 = 2 * i
                        jc0 = 2 * j
                        nbrs += gChild[ic0][jc0] + gChild[ic0 + 1][jc0]
                        nbrs += gChild[ic0][jc0 + 1] + gChild[ic0 + 1][jc0 + 1]
                   
                    iminus1 = (i - 1 + dim) %% dim
                    iplus1 = (i + 1 + dim) %% dim
                    jminus1 = (j - 1 + dim) %% dim
                    jplus1 = (j + 1 + dim) %% dim
                    nbrs += gLocal[iminus1][jminus1] + gLocal[iminus1][j] + gLocal[iminus1][jplus1]
                    nbrs += gLocal[i][jminus1] + gLocal[i][jplus1]
                    nbrs += gLocal[iplus1][jminus1] + gLocal[iplus1][j] + gLocal[iplus1][jplus1]
  
                    @neighbors[d][i][j] = nbrs 

    step: (f) ->
        for d in [1..@depth]
            dim = pow 2, d
            for i in [0..dim-1]
                for j in [0..dim-1]
                    state = @grid[d][i][j]
                    neighbors = @neighbors[d][i][j]
                    @grid[d][i][j] = (f state, neighbors)

                     
    rule: (state, neighbors) ->
        if neighbors in [5, 7, 8, 10, 11, 12] then 1 else 0

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
                row[j] = if rand() < 0.3 then 1 else 0
   
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

    rule: (state, neighbors) ->
        alive = (state is 1)
        if alive 
            if (neighbors is 2 or neighbors is 3) then 1 else 0
        else
            if (neighbors is 3) then 1 else 0


draw = (canvas, automaton) ->
    dim = pow 2, automaton.depth
    wCell = width / dim
    hCell = height / dim
    for i in [0..dim-1]
        row = automaton.grid[automaton.depth][i]
        for j in [0..dim-1]
            e = row[j]
            if e is 1
                ctx.rect i * wCell, j * hCell, wCell, hCell
 
width = 600
height = 600
canvas = document.createElement('canvas')
canvas.width = width
canvas.height = height 
container = document.getElementById('main')
container.appendChild(canvas)
ctx = canvas.getContext '2d'
ctx.fillStyle = 'red'

f = new FractalAutomaton 9
f.randomize 0.23
f.updateNeighbors()

play = ->
    ctx.clearRect(0, 0, width, height)
    ctx.beginPath()
    draw canvas, f
    ctx.fill()
    f.step f.rule
    f.updateNeighbors() 

#a = new Automaton 150, 150
#a.randomize()
#a.updateNeighbors()
#
#play = ->
#    ctx.clearRect(0, 0, width, height)
#    ctx.beginPath()
#    draw canvas, a
#    ctx.fill()
#    a.step a.rule
#    a.updateNeighbors()
#
#draw = (canvas, automaton) ->
#    wCell = width / automaton.n
#    hCell = height / automaton.m
#    for i in [0..automaton.n-1]
#        row = automaton.grid[i]
#        for j in [0..automaton.m-1]
#            e = row[j]
#            if e is 1
#                ctx.rect i * wCell, j * hCell, wCell, hCell
 
setInterval play, 80

#stringify = (grid) ->
#    _.reduce grid, ((memo, row) -> 
#        for e in row
#            c = if e is 1 then '@ ' else '. '
#            memo += c
#        memo += '\n'), ''
#
#imageData = ctx.getImageData(0, 0, width, height);
#
#draw = (canvas, grid) ->
#    mygrid = _.flatten grid
#    _.each mygrid, (e, i) ->
#        imageData.data[4 * i] = e * 255
#        imageData.data[4 * i + 3] = 255
#    ctx.putImageData(imageData, 10, 10)

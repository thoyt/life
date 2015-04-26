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
                    pnbrs = 0
                    ip0 = floor i / 2
                    jp0 = floor j / 2
                    ip1 = if i % 2 is 0 then ip0 - 1 else ip0 + 1
                    jp1 = if j % 2 is 0 then jp0 - 1 else jp0 + 1
                    ip1 = (dimParent + ip1) %% dimParent
                    jp1 = (dimParent + jp1) %% dimParent
                    pnbrs += gParent[ip0][jp0] + gParent[ip1][jp0]
                    pnbrs += gParent[ip0][jp1] + gParent[ip1][jp1]

                    cnbrs = 0 
                    if (d < @depth)
                        ic0 = 2 * i
                        jc0 = 2 * j
                        cnbrs += gChild[ic0][jc0] + gChild[ic0 + 1][jc0]
                        cnbrs += gChild[ic0][jc0 + 1] + gChild[ic0 + 1][jc0 + 1]
                   
                    iminus1 = (i - 1 + dim) %% dim
                    iplus1 = (i + 1 + dim) %% dim
                    jminus1 = (j - 1 + dim) %% dim
                    jplus1 = (j + 1 + dim) %% dim
                    nbrs = 0
                    nbrs += gLocal[iminus1][jminus1] + gLocal[iminus1][j] + gLocal[iminus1][jplus1]
                    nbrs += gLocal[i][jminus1] + gLocal[i][jplus1]
                    nbrs += gLocal[iplus1][jminus1] + gLocal[iplus1][j] + gLocal[iplus1][jplus1]
  
                    @neighbors[d][i][j] = { 'nbrs': nbrs, 'cnbrs': cnbrs, 'pnbrs': pnbrs }

    step: (f) ->
        for d in [1..@depth]
            dim = pow 2, d
            for i in [0..dim-1]
                for j in [0..dim-1]
                    state = @grid[d][i][j]
                    neighbors = @neighbors[d][i][j]
                    @grid[d][i][j] = (f state, neighbors)

                     
    rule0: (state, neighbors) ->
        n = neighbors.nbrs
        if state is 1
            if n in [2, 3] then 1 else 0
        else
            if n in [3] then 1 else 0

    rule1: (state, neighbors) ->
        n = neighbors.pnbrs + neighbors.cnbrs + neighbors.nbrs
        if n in [5, 7, 8, 10, 11, 12] then 1 else 0

    rule2: (state, neighbors) ->
        n = neighbors.pnbrs + neighbors.cnbrs
        if n in [3, 4, 5, 6, 7, 8, 10, 11] then 1 else 0

    rule3: (state, neighbors) ->
        n = neighbors.pnbrs + neighbors.nbrs
        if n in [4, 5, 6, 7, 8, 9, 10, 11] then 1 else 0
 
    rule4: (state, neighbors) ->
        n = neighbors.pnbrs
        if n in [2, 3] then 1 else 0

    rule5: (state, neighbors) ->
        n = neighbors.pnbrs
        if n in [1, 4] then 1 else 0

    rule6: (state, neighbors) ->
        n = neighbors.pnbrs + neighbors.nbrs + neighbors.cnbrs
        if n in [5, 6, 9, 11, 12, 13, 14] then 1 else 0

    rule7: (state, neighbors) ->
        if neighbors.pnbrs in [0, 2] then 1 else 0

    rule8: (state, neighbors) -> # @randomize 0.0001
        n = neighbors.pnbrs + neighbors.nbrs
        if n in [0, 2, 5, 7, 8, 9, 12] then 1 else 0

    ruleRandomParents: (k) ->
        @arr = []
        for i in [0..12]
            if rand() < k
                @arr.push(i)
        rule = (state, neighbors) =>
            n = neighbors.pnbrs + neighbors.nbrs 
            if n in @arr then 1 else 0
        rule

    ruleRandom: (k) ->
        @arr = []
        for i in [0..16]
            if rand() < k
                @arr.push(i)
        rule = (state, neighbors) =>
            n = neighbors.pnbrs + neighbors.nbrs + neighbors.cnbrs
            if n in @arr then 1 else 0
        rule

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
 
width = 800
height = 800
stage = new PIXI.Stage 0x66FF99
renderer = PIXI.autoDetectRenderer width, height
renderer.view.style.width = window.innerWidth + "px"
renderer.view.style.height = window.innerHeight + "px"
container = document.querySelector 'body'
container.appendChild renderer.view

params = 
    density: 0.25
    depth: 7
    rate: 1000
    rule: 'rule1'
    render: ->
        clearInterval(window.interval)
        render()

gui = new dat.GUI()
gui.add(params, 'density', 0, 0.4).step(0.001)
gui.add(params, 'depth', 2, 10).step(1)
gui.add(params, 'rule', ['rule0', 'rule1', 'rule2', 'rule3', 'rule4', 'rule5', 'rule6', 'rule7', 'rule8', 'random'])
gui.add(params, 'rate', 20, 4000)
gui.add(params, 'render')

graphics = new PIXI.Graphics()
graphics.beginFill 0xFF0000, 1.0

stage.addChild graphics

draw = (automaton) ->
    dim = pow 2, automaton.depth
    wCell = width / dim
    hCell = height / dim
    for i in [0..dim-1]
        row = automaton.grid[automaton.depth][i]
        for j in [0..dim-1]
            e = row[j]
            if e is 1
                #graphics.drawCircle i * wCell, j * hCell, hCell / 1.5
                graphics.drawRect i * wCell, j * hCell, wCell, hCell
    
do render = ->
    f = new FractalAutomaton params.depth
    f.randomize params.density
    f.updateNeighbors()
    
    if params.rule is 'random'
        rule = f.ruleRandomParents(0.2)
        console.log rule
    else
        rule = f[params.rule]
    
    play = ->
        draw f
        f.step rule
        f.updateNeighbors() 
        renderer.render(stage)
        graphics.clear()
        graphics.beginFill(0xFF0000, 1.0)
    
    window.interval = setInterval play, params.rate

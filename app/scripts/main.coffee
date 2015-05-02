pow = Math.pow
rand = Math.random
floor = Math.floor

class FractalAutomaton
    constructor: (depth) ->

    rule: (state, neighbors) ->
        n = 0
        if @sumParents
            n += neighbors.pnbrs
        if @sumLocal
            n += neighbors.nbrs
        if @sumChildren
            n+= neighbors.cnbrs
        if n in @ruleArray then 1 else 0

    setRule: (rule) ->
        @sumParents = rule.sumParents
        @sumLocal = rule.sumLocal
        @sumChildren = rule.sumChildren
        @ruleArray = rule.ruleArray
        # materialize rule here for performance? how
        # @rule = ..

    rulePresets:
        rule1:
            sumParents: yes
            sumLocal: yes
            sumChildren: yes
            ruleArray: [5, 7, 8, 10, 11, 12]
        rule2:
            sumParents: yes
            sumLocal: yes
            sumChildren: yes
            ruleArray: [2, 6, 8, 11]
        rule3:
            sumParents: yes
            sumLocal: yes
            sumChildren: no
            ruleArray: [4, 5, 6, 7, 8, 9, 10, 11]
        rule4:
            sumParents: yes
            sumLocal: no
            sumChildren: no
            ruleArray: [2, 3]
        rule5:
            sumParents: yes
            sumLocal: no
            sumChildren: no
            ruleArray: [1, 4]
        rule6:
            sumParents: yes
            sumLocal: yes
            sumChildren: yes
            ruleArray: [5, 6, 9, 11, 12, 13, 14]
        rule7:
            sumParents: yes
            sumLocal: no
            sumChildren: no
            ruleArray: [0, 2]
        rule8:
            sumParents: yes
            sumLocal: yes
            sumChildren: no
            ruleArray: [0, 2, 5, 7, 8, 9, 12]
        rule9:
            sumParents: yes
            sumLocal: yes
            sumChildren: no
            ruleArray: [0, 3, 12] 
        rule10:
            sumParents: yes
            sumLocal: yes
            sumChildren: no
            ruleArray: [2, 6] 
        rule11:
            sumParents: yes
            sumLocal: yes
            sumChildren: no
            ruleArray: [1, 10] 


class @FractalAutomaton3 extends FractalAutomaton
    constructor: (depth) ->
        @depth = depth
        @grid = []
        @neighbors = []
        @grid[0] = [[[0]]]
        for d in [1..depth]
            @grid[d] = []
            @neighbors[d] = []
            dim = pow(2, d)
            for i in [0..dim-1]
                @grid[d][i] = []
                @neighbors[d][i] = []
                for j in [0..dim-1]
                    row = (0 for k in [0..dim-1])
                    @grid[d][i][j] = row
                    @neighbors[d][i][j] = row.slice()

        @sumParents = yes
        @sumLocal = yes
        @sumChildren = yes

    randomize: (p) ->
        for d in [1..@depth]
            g = @grid[d]
            dim = pow 2, d
            for i in [0..dim-1]
                plane = g[i]
                for j in [0..dim-1]
                    row = plane[j]
                    for k in [0..dim-1]
                        row[k]  = if rand() < p then 1 else 0    
                
    updateNeighbors: -> 
        # 26 local neighbors
        # 8 children
        # 8 closest parents
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
                    for k in [0..dim-1]
                        pnbrs = 0
                        ip0 = floor i / 2
                        jp0 = floor j / 2
                        kp0 = floor k / 2
                        ip1 = if i % 2 is 0 then ip0 - 1 else ip0 + 1
                        jp1 = if j % 2 is 0 then jp0 - 1 else jp0 + 1
                        kp1 = if k % 2 is 0 then kp0 - 1 else kp0 + 1
                        ip1 = (dimParent + ip1) %% dimParent
                        jp1 = (dimParent + jp1) %% dimParent
                        kp1 = (dimParent + kp1) %% dimParent
                        pnbrs += gParent[ip0][jp0][kp0] + gParent[ip1][jp0][kp0]
                        pnbrs += gParent[ip0][jp1][kp0] + gParent[ip1][jp1][kp0]
                        pnbrs += gParent[ip0][jp0][kp1] + gParent[ip1][jp0][kp1]
                        pnbrs += gParent[ip0][jp1][kp1] + gParent[ip1][jp1][kp1]

                    cnbrs = 0 
                    if (d < @depth)
                        ic0 = 2 * i
                        jc0 = 2 * j
                        kc0 = 2 * k
                        cnbrs += gChild[ic0][jc0][kc0] + gChild[ic0 + 1][jc0][kc0]
                        cnbrs += gChild[ic0][jc0 + 1][kc0] + gChild[ic0 + 1][jc0 + 1][kc0]
                        cnbrs += gChild[ic0][jc0][kc0 + 1] + gChild[ic0 + 1][jc0][kc0 + 1]
                        cnbrs += gChild[ic0][jc0 + 1][kc0 + 1] + gChild[ic0 + 1][jc0 + 1][kc0 + 1]

                    iminus1 = (i - 1 + dim) %% dim
                    iplus1 = (i + 1 + dim) %% dim
                    jminus1 = (j - 1 + dim) %% dim
                    jplus1 = (j + 1 + dim) %% dim
                    kminus1 = (k - 1 + dim) %% dim
                    kplus1 = (k + 1 + dim) %% dim
                    nbrs = 0

                    nbrs += gLocal[iminus1][jminus1][kminus1] + gLocal[iminus1][j][kminus1] + gLocal[iminus1][jplus1][kminus1]
                    nbrs += gLocal[i][jminus1][kminus1] + gLocal[i][jplus1][kminus1] + gLocal[i][j][kminus1]
                    nbrs += gLocal[iplus1][jminus1][kminus1] + gLocal[iplus1][j][kminus1] + gLocal[iplus1][jplus1][kminus1]

                    nbrs += gLocal[iminus1][jminus1][k] + gLocal[iminus1][j][k] + gLocal[iminus1][jplus1][k]
                    nbrs += gLocal[i][jminus1][k] + gLocal[i][jplus1][k]
                    nbrs += gLocal[iplus1][jminus1][k] + gLocal[iplus1][j][k] + gLocal[iplus1][jplus1][k]
  
                    nbrs += gLocal[iminus1][jminus1][kplus1] + gLocal[iminus1][j][kplus1] + gLocal[iminus1][jplus1][kplus1]
                    nbrs += gLocal[i][jminus1][kplus1] + gLocal[i][jplus1][kplus1] + gLocal[i][j][kplus1]
                    nbrs += gLocal[iplus1][jminus1][kplus1] + gLocal[iplus1][j][kplus1] + gLocal[iplus1][jplus1][kplus1]

                    @neighbors[d][i][j][k] = { 'nbrs': nbrs, 'cnbrs': cnbrs, 'pnbrs': pnbrs }

    step: ->
        for d in [1..@depth]
            dim = pow 2, d
            for i in [0..dim-1]
                for j in [0..dim-1]
                    for k in [0..dim-1]
                        state = @grid[d][i][j][k]
                        neighbors = @neighbors[d][i][j][k]
                        @grid[d][i][j][k] = (@rule state, neighbors)


class @FractalAutomaton2 extends FractalAutomaton
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

        @sumParents = yes
        @sumLocal = yes
        @sumChildren = yes
        @ruleArray = [5, 7, 8, 10, 11, 12]

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

    step: ->
        for d in [1..@depth]
            dim = pow 2, d
            for i in [0..dim-1]
                for j in [0..dim-1]
                    state = @grid[d][i][j]
                    neighbors = @neighbors[d][i][j]
                    @grid[d][i][j] = (@rule state, neighbors)

    rule0: (state, neighbors) ->
        n = neighbors.nbrs
        if state is 1
            if n in [2, 3] then 1 else 0
        else
            if n in [3] then 1 else 0


@voxels = []
draw = (automaton) ->
    dim = pow 2, automaton.depth
    for i in [0..dim-1]
        plane = automaton.grid[automaton.depth][i]
        for j in [0..dim-1]
            row = plane[j]
            for k in [0..dim-1]
                e = row[k]
                if e is 1
                    voxel = new THREE.Mesh( cubeGeo, cubeMaterial )
                    voxel.position.x = size * i
                    voxel.position.y = size * j
                    voxel.position.z = size * k
                    scene.add( voxel )
                    voxels.push( voxel )

params = 
    density: 0.80
    depth: 4
    rate: 200
    rule: 'rule1'
    customRule:
        sumParents: true
        sumLocal: true
        sumChildren: true
        array: "[1,2,3,4]"
    render: ->
        clearInterval(window.interval)
        render()

window.generateCustomRule = (sumParents, sumLocal, sumChildren, rule) ->
    newRule = (state, neighbors) =>
        n = 0
        if sumParents
            n += neighbors.pnbrs
        if sumLocal
            n += neighbors.nbrs
        if sumChildren
            n += neighbors.cnbrs
        if n in rule then 1 else 0

rules = [
    'rule1', 
    'rule2', 
    'rule3', 
    'rule4', 
    'rule5', 
    'rule6', 
    'rule7', 
    'rule8', 
    'rule9', 
    'rule10', 
    'rule11',
    'custom'
]

densityChoices = 
    'super tiny': 0.0001
    'tiny': 0.001
    'small': 0.01
    'medium': 0.1
    'large': 0.25
    'xlarge': 0.4

gui = new dat.GUI()
gui.add(params, 'density', densityChoices)
gui.add(params, 'depth', 5, 11).step(1)
gui.add(params, 'rule', rules)
f1 = gui.addFolder('custom rule')
f1.add(params.customRule, 'sumParents').name('sum parents')
f1.add(params.customRule, 'sumLocal').name('sum local')
f1.add(params.customRule, 'sumChildren').name('sum children')
f1.add(params.customRule, 'array').name('array')
gui.add(params, 'rate', 20, 4000)
gui.add(params, 'render')

width = window.innerWidth
height = window.innerHeight

container = document.createElement( 'div' )
document.body.appendChild( container )
@scene = new THREE.Scene()
@camera = new THREE.PerspectiveCamera( 45, width / height, 0, 10000 )
camera.position.z = 500

scene.add(camera)

ambientLight = new THREE.AmbientLight( 0x999999 )
scene.add( ambientLight )

directionalLight = new THREE.DirectionalLight( 0x808080, 1.0 )
directionalLight.position.set( 0, 1, 0 )
scene.add( directionalLight )

@renderer = new THREE.WebGLRenderer( { antialiasing: true } )
renderer.setClearColor( 0xf0f0f0 )
renderer.setSize( width, height )

#@controls = new THREE.OrbitControls(camera, renderer.domElement)

container.appendChild( renderer.domElement )

cubeMaterial = new THREE.MeshBasicMaterial( { color: 0xFF0066, wireframe: true, wireframeLinewidth: 1 } )
#cubeMaterial = new THREE.MeshLambertMaterial( { color: 0xff0000, shading: THREE.FlatShading } )
size = 5
cubeGeo = new THREE.BoxGeometry( size, size, size )

f = new FractalAutomaton3 params.depth
f.randomize params.density

do render = ->
    if params.rule is 'custom' 
        rule = 
            sumParents: params.customRule.sumParents
            sumLocal: params.customRule.sumLocal
            sumChildren: params.customRule.sumChildren
            ruleArray: JSON.parse(params.customRule.array)
    else
        rule = f.rulePresets[params.rule]
    f.setRule rule

    draw f
    f.step()
    f.updateNeighbors()
    renderer.render(scene, camera)

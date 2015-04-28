(function(){var a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r=function(a,b){return(a%b+ +b)%b},s=[].indexOf||function(a){for(var b=0,c=this.length;c>b;b++)if(b in this&&this[b]===a)return b;return-1};k=Math.pow,l=Math.random,f=Math.floor,a=function(){function a(a){var b,c,d,e,f,g,h,i;for(this.depth=a,this.grid=[],this.neighbors=[],this.grid[0]=[[0]],b=g=1;a>=1?a>=g:g>=a;b=a>=1?++g:--g)for(this.grid[b]=[],this.neighbors[b]=[],c=k(2,b),d=h=0,i=c-1;i>=0?i>=h:h>=i;d=i>=0?++h:--h)f=function(){var a,b,d;for(d=[],e=a=0,b=c-1;b>=0?b>=a:a>=b;e=b>=0?++a:--a)d.push(0);return d}(),this.grid[b].push(f),this.neighbors[b].push(f.slice());this.sumParents=!0,this.sumLocal=!0,this.sumChildren=!0,this.ruleArray=[5,7,8,10,11,12]}return a.prototype.randomize=function(a){var b,c,d,e,f,g,h,i,j;for(j=[],b=h=1,i=this.depth;i>=1?i>=h:h>=i;b=i>=1?++h:--h)d=this.grid[b],c=k(2,b),j.push(function(){var b,h,i;for(i=[],e=b=0,h=c-1;h>=0?h>=b:b>=h;e=h>=0?++b:--b)g=d[e],i.push(function(){var b,d,e;for(e=[],f=b=0,d=c-1;d>=0?d>=b:b>=d;f=d>=0?++b:--b)e.push(g[f]=l()<a?1:0);return e}());return i}());return j},a.prototype.updateNeighbors=function(){var a,b,c,d,e,g,h,i,j,l,m,n,o,p,q,s,t,u,v,w,x,y,z,A,B,C,D;for(D=[],b=B=1,C=this.depth;C>=1?C>=B:B>=C;b=C>=1?++B:--B)d=b-1,h=k(2,b-1),l=this.grid[d],j=this.grid[b],e=k(2,b),b<this.depth&&(c=b+1,i=this.grid[c],g=k(2,c)),D.push(function(){var c,d,g;for(g=[],m=c=0,d=e-1;d>=0?d>=c:c>=d;m=d>=0?++c:--c)g.push(function(){var c,d,g;for(g=[],t=c=0,d=e-1;d>=0?d>=c:c>=d;t=d>=0?++c:--c)A=0,p=f(m/2),w=f(t/2),q=m%2===0?p-1:p+1,x=t%2===0?w-1:w+1,q=r(h+q,h),x=r(h+x,h),A+=l[p][w]+l[q][w],A+=l[p][x]+l[q][x],a=0,b<this.depth&&(n=2*m,u=2*t,a+=i[n][u]+i[n+1][u],a+=i[n][u+1]+i[n+1][u+1]),o=r(m-1+e,e),s=r(m+1+e,e),v=r(t-1+e,e),y=r(t+1+e,e),z=0,z+=j[o][v]+j[o][t]+j[o][y],z+=j[m][v]+j[m][y],z+=j[s][v]+j[s][t]+j[s][y],g.push(this.neighbors[b][m][t]={nbrs:z,cnbrs:a,pnbrs:A});return g}.call(this));return g}.call(this));return D},a.prototype.step=function(){var a,b,c,d,e,f,g,h,i;for(i=[],a=g=1,h=this.depth;h>=1?h>=g:g>=h;a=h>=1?++g:--g)b=k(2,a),i.push(function(){var g,h,i;for(i=[],c=g=0,h=b-1;h>=0?h>=g:g>=h;c=h>=0?++g:--g)i.push(function(){var g,h,i;for(i=[],d=g=0,h=b-1;h>=0?h>=g:g>=h;d=h>=0?++g:--g)f=this.grid[a][c][d],e=this.neighbors[a][c][d],i.push(this.grid[a][c][d]=this.rule(f,e));return i}.call(this));return i}.call(this));return i},a.prototype.rule=function(a,b){var c;return c=0,this.sumParents&&(c+=b.pnbrs),this.sumLocal&&(c+=b.nbrs),this.sumChildren&&(c+=b.cnbrs),s.call(this.ruleArray,c)>=0?1:0},a.prototype.setRule=function(a){return this.sumParents=a.sumParents,this.sumLocal=a.sumLocal,this.sumChildren=a.sumChildren,this.ruleArray=a.ruleArray},a.prototype.rulePresets={rule1:{sumParents:!0,sumLocal:!0,sumChildren:!0,ruleArray:[5,7,8,10,11,12]},rule2:{sumParents:!0,sumLocal:!0,sumChildren:!0,ruleArray:[2,6,8,11]},rule3:{sumParents:!0,sumLocal:!0,sumChildren:!1,ruleArray:[4,5,6,7,8,9,10,11]},rule4:{sumParents:!0,sumLocal:!1,sumChildren:!1,ruleArray:[2,3]},rule5:{sumParents:!0,sumLocal:!1,sumChildren:!1,ruleArray:[1,4]},rule6:{sumParents:!0,sumLocal:!0,sumChildren:!0,ruleArray:[5,6,9,11,12,13,14]},rule7:{sumParents:!0,sumLocal:!1,sumChildren:!1,ruleArray:[0,2]},rule8:{sumParents:!0,sumLocal:!0,sumChildren:!1,ruleArray:[0,2,5,7,8,9,12]},rule9:{sumParents:!0,sumLocal:!0,sumChildren:!1,ruleArray:[0,3,12]},rule10:{sumParents:!0,sumLocal:!0,sumChildren:!1,ruleArray:[2,6]},rule11:{sumParents:!0,sumLocal:!0,sumChildren:!1,ruleArray:[1,10]}},a.prototype.rule0=function(a,b){var c;return c=b.nbrs,1===a?2===c||3===c?1:0:3===c?1:0},a}(),d=function(a,b){var c,d,e,f,g,h,j,l,m,n;for(c=k(2,b.depth),j=q/c,e=i/c,n=[],f=l=0,m=c-1;m>=0?m>=l:l>=m;f=m>=0?++l:--l)h=b.grid[b.depth][f],n.push(function(){var a,b,i;for(i=[],g=a=0,b=c-1;b>=0?b>=a:a>=b;g=b>=0?++a:--a)d=h[g],i.push(1===d?ctx.rect(f*j,g*e,j,e):void 0);return i}());return n},q=800,i=800,p=new PIXI.Stage(6750105),n=PIXI.autoDetectRenderer(q,i),n.view.style.width=window.innerWidth+"px",n.view.style.height=window.innerHeight+"px",b=document.querySelector("body"),b.appendChild(n.view),j={density:.25,depth:8,rate:200,rule:"rule1",customRule:{sumParents:!0,sumLocal:!0,sumChildren:!0,array:"[1,2,3,4]"},render:function(){return clearInterval(window.interval),m()}},window.generateCustomRule=function(a,b,c,d){var e;return e=function(e){return function(e,f){var g;return g=0,a&&(g+=f.pnbrs),b&&(g+=f.nbrs),c&&(g+=f.cnbrs),s.call(d,g)>=0?1:0}}(this)},o=["rule1","rule2","rule3","rule4","rule5","rule6","rule7","rule8","rule9","rule10","rule11","custom"],c={"super tiny":1e-4,tiny:.001,small:.01,medium:.1,large:.25,xlarge:.4},h=new dat.GUI,h.add(j,"density",c),h.add(j,"depth",5,11).step(1),h.add(j,"rule",o),e=h.addFolder("custom rule"),e.add(j.customRule,"sumParents").name("sum parents"),e.add(j.customRule,"sumLocal").name("sum local"),e.add(j.customRule,"sumChildren").name("sum children"),e.add(j.customRule,"array").name("array"),h.add(j,"rate",20,4e3),h.add(j,"render"),g=new PIXI.Graphics,g.beginFill(16711680,1),p.addChild(g),d=function(a){var b,c,d,e,f,h,j,l,m,n;for(b=k(2,a.depth),j=q/b,d=i/b,n=[],e=l=0,m=b-1;m>=0?m>=l:l>=m;e=m>=0?++l:--l)h=a.grid[a.depth][e],n.push(function(){var a,i,k;for(k=[],f=a=0,i=b-1;i>=0?i>=a:a>=i;f=i>=0?++a:--a)c=h[f],k.push(1===c?g.drawRect(e*j,f*d,j,d):void 0);return k}());return n},(m=function(){var b,c,e;return b=new a(j.depth),b.randomize(j.density),b.updateNeighbors(),e="custom"===j.rule?{sumParents:j.customRule.sumParents,sumLocal:j.customRule.sumLocal,sumChildren:j.customRule.sumChildren,ruleArray:JSON.parse(j.customRule.array)}:b.rulePresets[j.rule],b.setRule(e),c=function(){return d(b),b.step(),b.updateNeighbors(),n.render(p),g.clear(),g.beginFill(16711680,1)},window.interval=setInterval(c,j.rate)})()}).call(this);
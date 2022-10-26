var c = document.getElementById("myCanvas");
var ctx = c.getContext("2d");
ctx.canvas.width = window.innerWidth;
let sizeX = window.innerWidth/2
let sizeY = ctx.canvas.height/2
for (let i = 0; i < points.length; i++) {
    scale(points[i], startT)
    scale(points[i], getmat(Math.PI/2,0,0))
}
const speed = 1/120*2
var drot = [0, 0, speed/4]

function getmat(x,y,z) {
    const ca = Math.cos(x), sa = Math.sin(x),
    cb = Math.cos(y), sb = Math.sin(y),
    cc = Math.cos(z), sc = Math.sin(z)
    return [
        [cc*cb, -sc*ca+cc*sb*sa, sc*sa+cc*sb*ca],
        [sc*cb, cc*ca+sc*sb*sa, -cc*sa+sc*sb*ca],
        [-sb, cb*sa, ca*cb]
    ]
}

ctx.globalAlpha = 0.4;
function plot() {
    ctx.canvas.width = window.innerWidth;
    let sizeX = window.innerWidth/2
    ctx.globalAlpha = 0.2;
    ctx.clearRect(0, 0, c.width, c.height);
    let newpoints = []
    for (let i = 0; i < points.length; i++) {
        let e = points[i];
        ctx.beginPath();
        scale(e, getmat(drot[0],drot[1],drot[2]))

        grd = ctx.createRadialGradient(e[0]+sizeX, e[1]+sizeY, 1, e[0]+sizeX, e[1]+sizeY, e[3]);
        grd.addColorStop(0, "rgb(250,250,250)");
        grd.addColorStop(1, "rgb(150,150,150)");
        ctx.fillStyle = grd;

        ctx.arc(e[0]+sizeX, e[1]+sizeY, e[3], 0, 2 * Math.PI);
        ctx.fill();
        newpoints[i] = [e[0]+sizeX,e[1]+sizeY]
    }
    ctx.lineWidth = 8;
    ctx.strokeStyle="rgb(200,200,200)"
    for (let i = 0; i < lines.length; i++) {
        let e = lines[i];
        ctx.beginPath();
        v = [newpoints[e[0]][0]-newpoints[e[1]][0],
        newpoints[e[0]][1]-newpoints[e[1]][1]]
        m = Math.pow(Math.pow(v[0], 2)+Math.pow(v[1], 2), 0.5)
        s = [v[0]/m*(points[e[0]][3]-1),
        v[1]/m*(points[e[0]][3]-1)]
        f = [v[0]/m*(points[e[1]][3]-1),
        v[1]/m*(points[e[1]][3]-1)]
        ctx.moveTo(points[e[0]][0]+sizeX-s[0], points[e[0]][1]+sizeY-s[1]);
        ctx.lineTo(points[e[1]][0]+sizeX+f[0], points[e[1]][1]+sizeY+f[1]);
        ctx.stroke();
    }
    ctx.lineWidth = 0;
    mag = Math.pow(Math.pow(drot[0],2)+Math.pow(drot[1],2)+Math.pow(drot[2],2), 0.5)
    if (mag>1) {
        drot[0] *= 0.95
        drot[1] *= 0.95
        //drot[2] *= 0.95
    } else if (mag>0.005) {
        drot[0] *= 0.99
        drot[1] *= 0.99
        //drot[2] *= 0.998
    }
    console.log(mag)
}
function scale(vec, scale) {
    vec2 = []
    for (let i = 0; i < 3; i++) {
        vec2[i] = scale[i][0]*vec[0]+scale[i][1]*vec[1]+scale[i][2]*vec[2]
    }
    for (let i = 0; i < 3; i++) {
        vec[i] = vec2[i]
    }
}


var pastM = [0,0]
function mouseInteract(e){
    if (clickin) {
        let posx = (Math.min(e.clientX,sizeX*2)-sizeX)/sizeX
        let posy = (Math.min(e.clientY,sizeY*2)-sizeY)/sizeY
        
        console.log("mouse location:", posx, posy)
        let dx = pastM[0]-posx, dy = pastM[1]-posy
        let dm = Math.pow(Math.pow(dx,2)+Math.pow(dy,2),0.5)
        let mag = Math.pow(Math.pow(drot[0],2)+Math.pow(drot[1],2)+Math.pow(drot[2],2), 0.5)
        if (dm<mag) {
            drot[0] *= 0.9
            drot[1] *= 0.9
        } else {
            drot[1] += -Math.sin((dx)*Math.PI*0.5)*speed
            drot[0] += Math.sin((dy)*Math.PI*0.5)*speed
        }
        console.log(pastM[0]-posx)
    }
}

clickin = false

onmousedown = function (e) {
    clickin = true;
    let posx = (Math.min(e.clientX,sizeX*2)-sizeX)/sizeX
    let posy = (Math.min(e.clientY,sizeY*2)-sizeY)/sizeY
    pastM = [posx,posy]
}, false


document.getElementById("top").addEventListener('mousemove', mouseInteract, false);
onmouseup = function (e) {clickin = false}
setInterval(plot, 16.7);

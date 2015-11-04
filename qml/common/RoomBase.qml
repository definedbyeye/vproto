import VPlay 2.0
import QtQuick 2.0
import '../../assets/scripts/utility.js' as Utility
import '../../assets/scripts/astar.js' as Astar
import '../../assets/scripts/sat.js' as Sat

Item {
  id: roomBase  

  property real dragMinX: -(roomBase.width-gameScene.width)
  property real dragMaxX: 0
  property real dragMinY: 0
  property real dragMaxY: roomBase.height-gameScene.height

  property real defaultOffset: 0

  property point defaultPlayerPoint: Qt.point(0,0)
  property real minPerspective: .1
  property real maxPerspective: 1

  property string goToRoomId: ''
  property string fromAreaId: ''

  property variant nodes: []
  property int stepSize: 20

  /*
  signal drawBlocks(var blocks, var color);
  onDrawBlocks: {
      drawBlocksNow(blocks, color);
  }

  EntityManager {
      id: testGrid
      entityContainer: roomBase
      dynamicCreationEntityList: []
  }

  function drawBlocksNow(blocks, color) {
      if(blocks.length > 0){
      for(var i = 0; i < blocks.length; i++){

          testGrid.createEntityFromUrlWithProperties(
                      Qt.resolvedUrl("Block.qml"), {"x": blocks[i].x, "y": blocks[i].y, 'color': color});

      }
      }
  }
  */

  property var obstructions: [] //currently only walls - should separate walls and obstructions.  Walls only check if the stepper is inside them.  Obstructions check stepper->obst then check obstruction->stepper
  property var obstructionSAT: [] //translated to SAT objects

  function placePlayer(player, fromAreaId) {
      player.placePlayer(defaultPlayerPoint);
  }

  function initGraph(){
      var row = [],
          blocked = false,
          stepX = 0,
          stepY = 0;

      nodes = [];
      var blocks = [];

      var i, j, v, o;
      if(obstructions.length){
          for(i=0; i < obstructions.length; i++){
              o = obstructions[i];
              v = [];
              for(j=0; j < o.vertices.length; j++){
                  v.push(new Sat.Vector(o.vertices[j].x,o.vertices[j].y));
              }
              obstructionSAT.push(new Sat.Polygon(new Sat.Vector(o.x, o.y), v));
          }
      }

      while(stepX <= width) {
          while(stepY <= height) {
            blocked = isStepBlocked(Qt.point(stepX, stepY), stepSize) ? 0 : 1;

            row.push(blocked);
            if(!blocked){
                //console.log('making nodes: ['+nodes.length+','+row.length+'] '+blocked)
                blocks.push(Qt.point(stepX,stepY));
            };
            stepY += stepSize;
          }
          nodes.unshift(row);
          row = [];          
          stepY = 0;
          stepX += stepSize;
      }
      //console.log('step x and y '+x+' '+y);
      //drawBlocks(blocks, 'orange');
  }

  function isStepBlocked(point, stepSize){
      if(obstructions.length > 0){
          var stepper = new Sat.Box(new Sat.Vector(point.x,point.y), stepSize, stepSize).toPolygon();
          for(var i = 0; i < obstructionSAT.length; i++){
              if(Sat.testPolygonPolygon(stepper, obstructionSAT[i])){
                  return true;
              }
          }
      }
      return false;
  }

  //http://playtechs.blogspot.ca/2007/03/raytracing-on-grid.html
  function lineOfSite(pointA, pointB) {
    var x0 = pointA.x;
    var y0 = pointA.y;
    var x1 = pointB.x;
    var y1 = pointB.y;

    var dx = Math.abs(x1 - x0);
    var dy = Math.abs(y1 - y0);

    var x = Math.floor(x0);
    var y = Math.floor(y0);

    var n = 1;
    var x_inc, y_inc;
    var error;
    var blocked = false;

    if (dx == 0) {
        x_inc = 0;
        error = Infinity;
    }
    else if (x1 > x0) {
        x_inc = 1;
        n += Math.floor(x1) - x;
        error = (Math.floor(x0) + 1 - x0) * dy;
    }
    else {
        x_inc = -1;
        n += x - Math.floor(x1);
        error = (x0 - Math.floor(x0)) * dy;
    }

    if (dy === 0) {
        y_inc = 0;
        error -= Infinity;
    }
    else if (y1 > y0) {
        y_inc = 1;
        n += Math.floor(y1) - y;
        error -= (Math.floor(y0) + 1 - y0) * dx;
    }
    else {
        y_inc = -1;
        n += y - Math.floor(y1);
        error -= (y0 - Math.floor(y0)) * dx;
    }

      //console.log('n is '+n);
    for (; n > 0; --n) {

        //console.log('node ['+(x)+','+(y)+'] = ');
          //      console.log(nodes[x][y]);
        if (nodes[x][y] === 0) {
            return false;
        }

        if (error > 0) {
            y += y_inc;
            error -= dx;
        }
        else {
            x += x_inc;
            error += dy;
        }

    }
    return true;
  }

  function getPath(start, end) {

      var graph = new Astar.Graph(nodes);

      var startX = Math.floor(start.x/stepSize)-1;
      var startY = Math.floor(start.y/stepSize)-1;
      var endX = Math.floor(end.x/stepSize)-1;
      var endY = Math.floor(end.y/stepSize)-1;
      var startNode = graph.grid[startX][startY];
      var endNode = graph.grid[endX][endY];

      console.log('startnode '+startNode);
      console.log('endnode '+endNode);
      //console.log('line of site: '+lineOfSite(Qt.point(startX, startY), Qt.point(endX, endY)));

      var path = Astar.astar.search(graph, startNode, endNode, {heuristic: Astar.astar.heuristics.diagonal, closest: true});

      //smooth the path
      //console.log('path before: '+path);
      if(path.length > 2){
          var from = 0;
          while(from+2 < path.length){
              if(lineOfSite(path[from], path[from+2])){
                  path.splice(from+1, 1);
              } else {
                  from++;
              }
          }
      }

      //console.log('path after: '+path);

      //convert path back to x,y
      var point;
      for(var i = 0; i < path.length; i++){
          point = path[i];
          path[i].x = point.x*stepSize;
          path[i].y = point.y*stepSize;
      }

      //drawBlocks(path, 'purple');

      //get to the clicked point
      if(path.length === 2){
          path.pop();
      }

      path.push(end);

      path.shift();
      return path;
  }

}


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

  property variant nodes: []    //multi array [x][y] blocked=0
  property variant graph: null  //nodes translated to astar graph obj
  property int stepSize: 10

  // obstructions are pushed here as they are created.
  // on room load, these are translated to SAT objects.
  // todo: cache to db
  property var obstructions: []

  //has room been initialized before
  //todo: not sure if room retains nodes, graphs, etc on reload
  property bool init: false

  signal loaded
  onLoaded: {
      //todo: save generated nodes and graph to db
      if(!init){
        initGraph();
        init = true;
      }
  }

  function placePlayer(player, fromAreaId) {
      player.placePlayer(defaultPlayerPoint);
  }

  function initGraph(){
      var row = [],
          blocked = false,
          stepX = 0,
          stepY = 0;
      var blocks = [];

      convertObstructionsToSAT();

      while(stepX <= width) {
          while(stepY <= height) {
            row.push(isNodeBlocked(Qt.point(stepX, stepY), stepSize) ? 0 : 1);
              //if(!isNodeBlocked(Qt.point(stepX, stepY), stepSize) ? 0 : 1){
              //    blocks.push(Qt.point(stepX,stepY));
              //};
            stepY += stepSize;
          }
          nodes.unshift(row);
          row = [];          
          stepY = 0;
          stepX += stepSize;
      }
      //drawBlocks(blocks, 'orange');
      graph = new Astar.Graph(nodes);
  }

  function convertObstructionsToSAT(){
      var i, //iterate obstructions
          j, //iterate vertices
          v, //current obstruction's array of SAT vectors
          o; //current obstruction

      var obstructionsSAT = [];

      if(obstructions.length){
          for(i=0; i < obstructions.length; i++){
              o = obstructions[i];
              v = [];
              for(j=0; j < o.vertices.length; j++){
                  v.push(new Sat.Vector(o.vertices[j].x,o.vertices[j].y));
              }
              obstructionsSAT.push(new Sat.Polygon(new Sat.Vector(o.x, o.y), v));
          }
      }

      obstructions = obstructionsSAT;
  }

  function isNodeBlocked(point, stepSize){
      if(obstructions.length > 0){
          var stepper = new Sat.Box(new Sat.Vector(point.x,point.y), stepSize, stepSize).toPolygon();
          for(var i = 0; i < obstructions.length; i++){
              if(Sat.testPolygonPolygon(stepper, obstructions[i])){
                  return true;
              }
          }
      }
      return false;
  }

  //http://playtechs.blogspot.ca/2007/03/raytracing-on-grid.html
  //test line of site across nodes
  function lineOfSite(nodeA, nodeB) {      
    var x0 = nodeA.x;
    var y0 = nodeA.y;
    var x1 = nodeB.x;
    var y1 = nodeB.y;

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

    for (; n > 0; --n) {

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

  function getWaypoints(start, end) {
    var waypoints = [end];

    graph = new Astar.Graph(nodes); //do not remove

    var startNode = graph.grid[Math.floor(start.x/stepSize)-1][Math.floor(start.y/stepSize)-1];
    var endNode = graph.grid[Math.floor(end.x/stepSize)-1][Math.floor(end.y/stepSize)-1];

    //shortcut pathing if end point is within line of site
    if(!lineOfSite(startNode, endNode)) {
        var path = Astar.astar.search(graph, startNode, endNode, {closest: true});
        path = smoothPath(path);
        waypoints = convertPathToWaypoints(path);
        waypoints = setStartpoint(waypoints);
        waypoints = setEndpoint(waypoints, end);
    }

    return waypoints;
  }

  //remove redundant steps in the path
  function smoothPath(path){
      var from = 0;

      if(path.length > 2){
          while(from+2 < path.length){
              if(lineOfSite(path[from], path[from+2])){
                  path.splice(from+1, 1);
              } else {
                  from++;
              }
          }
      }

      return path;
  }

  //convert path back to x,y coordinates, traveling through the center of the blocks
  function convertPathToWaypoints(path){
      var waypoints = path;
      var w;

      for(var i = 0; i < waypoints.length; i++){
          w = waypoints[i];
          waypoints[i].x = ((w.x+1)*stepSize);
          waypoints[i].y = ((w.y+1)*stepSize);
      }

      return waypoints;
  }

  //remove the starting waypoint
  function setStartpoint(waypoints){
      waypoints.shift();
      return waypoints;
  }

  //if the endpoint is inside the last waypoint block,
  //replace the last waypoint with the actual point
  function setEndpoint(waypoints, end){
      var ln = waypoints[waypoints.length-1]; //lastNode
      /*
      var lnVerts = [
                  [ln.x-(stepSize/2),ln.y-(stepSize/2)],
                  [ln.x+(stepSize/2),ln.y-(stepSize/2)],
                  [ln.x+(stepSize/2),ln.y+(stepSize/2)],
                  [ln.x-(stepSize/2),ln.y+(stepSize/2)],
                  [ln.x-(stepSize/2),ln.y-(stepSize/2)]
              ];
              */
      var lnVerts = [
                  [ln.x,ln.y],
                  [ln.x+stepSize,ln.y],
                  [ln.x+stepSize,ln.y+stepSize],
                  [ln.x,ln.y+stepSize],
                  [ln.x,ln.y]
              ];
      //drawBlocks([Qt.point(ln.x-(stepSize/2), ln.y-(stepSize/2))], 'green');
      if(Utility.pointInPoly(end, lnVerts)){
          waypoints.pop();
          waypoints.push(end);
      }

      return waypoints;
  }



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


}


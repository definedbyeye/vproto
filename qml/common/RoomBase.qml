import VPlay 2.0
import QtQuick 2.0
import '../../assets/scripts/utility.js' as Utility
import '../../assets/scripts/astar.js' as Astar
import '../../assets/scripts/sat.js' as Sat

Item {
  id: roomBase  

  property real dragMinX: -(roomBase.width-screen.width)
  property real dragMaxX: 0
  property real dragMinY: 0
  property real dragMaxY: roomBase.height-screen.height

  // --- rooms will not override these
  //property point defaultOffset: Qt.point(0,0)
  //property var entrances: {'default': Qt.point(0,0)}
  //property real minPerspective: 1
  //property real maxPerspective: 1

  property variant grid: []    //multi array [x][y] blocked=0
  property variant graph: null  //grid translated to astar graph obj
  property int stepSize: 10

  // obstructions are pushed here as they are created.
  // on room load, these are translated to SAT objects.
  // todo: cache to db
  property var obstructions: []

  signal loaded
  onLoaded: {
      console.log('ROOM '+parent.id+' LOADED.  Init\'ed? ' + init);
      //todo: save generated grid and graph to db
        initGraph();
  }

  PlayerSkin {
      id: playerSkin
      z: 50
  }

  // ------------------- //


  function placePlayer(player, entrance) {
      var point = Qt.point(0,0);

      if(entrances[entrance]) {
          point = entrances[entrance];
      } else if(entrances.default) {
          point = entrances.default;
      }

      console.log('placing player at '+point.x+', '+point.y);

      player.x = point.x;
      player.y = point.y;
  }


  function initGraph(){
      var cachedGrid = storage.loadRoomGrid(activeRoomId, obstructions);

      //load grid from storage, else generate and store
      if(cachedGrid.length){

          grid = cachedGrid;

      } else {

          var row = [],
              blocked = false,
              stepX = 0,
              stepY = 0;
          var blocks = [];

          var satObstructions = convertObstructionsToSAT(obstructions);

          while(stepY <= height) {
              while(stepX <= width) {
                row.push(isNodeBlocked(Qt.point(stepX, stepY), stepSize, satObstructions) ? 0 : 1);
                  if(!isNodeBlocked(Qt.point(stepX, stepY), stepSize, satObstructions) ? 0 : 1){
                      blocks.push(Qt.point(stepX,stepY));
                  };
                stepX += stepSize;
              }
              grid.push(row);
              row = [];
              stepX = 0;
              stepY += stepSize;
          }

          drawBlocks(blocks, 'orange');

          storage.saveRoomGrid(activeRoomId, obstructions, grid);
     }

      graph = new Astar.Graph(grid);
  }

  function convertObstructionsToSAT(obstructions){
      var i, //iterate obstructions
          j, //iterate vertices
          v, //current obstruction's array of SAT vectors
          o; //current obstruction

      var satObstructions = [];

      if(obstructions.length){
          for(i=0; i < obstructions.length; i++){
              o = obstructions[i];
              v = [];
              for(j=0; j < o.vertices.length; j++){
                  v.push(new Sat.Vector(o.vertices[j].x,o.vertices[j].y));
              }
              satObstructions.push(new Sat.Polygon(new Sat.Vector(o.x, o.y), v));
          }
      }

      return satObstructions;
  }

  //tests if the node overlaps any of our obstruction polygons
  function isNodeBlocked(node, stepSize, obstructions){
      if(obstructions.length > 0){
          var block = new Sat.Box(new Sat.Vector(node.x,node.y), stepSize, stepSize).toPolygon();
          for(var i = 0; i < obstructions.length; i++){
              if(Sat.testPolygonPolygon(block, obstructions[i])){
                  return true;
              }
          }
      }
      return false;
  }

  //http://playtechs.blogspot.ca/2007/03/raytracing-on-grid.html
  //test line of site across grid
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

        if (grid[x][y] === 0) {
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
    var waypoints = [start,end];

    graph = new Astar.Graph(grid); //do not remove

    var startNode = graph.grid[Math.floor(start.y/stepSize)][Math.floor(start.x/stepSize)];
    var endNode = graph.grid[Math.floor(end.y/stepSize)][Math.floor(end.x/stepSize)];

    //shortcut pathing if end point is within line of site
    if(!lineOfSite(startNode, endNode)) {
        var path = Astar.astar.search(graph, startNode, endNode, {closest: true});
        path = smoothPath(path);
        waypoints = convertPathToWaypoints(path);
        waypoints = setStartpoint(waypoints, start);
        waypoints = setEndpoint(waypoints, end);
    }

      drawBlocks(waypoints, 'yellow');

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
      var x,y;

      for(var i = 0; i < waypoints.length; i++){
          x = waypoints[i].x;
          y = waypoints[i].y;
          waypoints[i].y = (x*stepSize)+stepSize/2;
          waypoints[i].x = (y*stepSize)+stepSize/2;
      }

      return waypoints;
  }

  //remove the starting waypoint
  function setStartpoint(waypoints, start){
      waypoints.shift();
      waypoints.unshift(start);
      return waypoints;
  }

  //if the endpoint is inside the last waypoint block, replace the last waypoint with the actual point
  function setEndpoint(waypoints, end){
      var lastPoint = waypoints[waypoints.length-1];
      var lastNode = new Sat.Box(new Sat.Vector(lastPoint.x,lastPoint.y), stepSize, stepSize).toPolygon();

      if(Sat.pointInPolygon(end, lastNode)){
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


import VPlay 2.0
import QtQuick 2.4
import "../common"


EntityBase {
    id: interactable
    entityId: "interactable"
    entityType: "interactable"

    property int triggerSensitivity: 20    

    // interactable exposes these events:
    signal swipeUp()
    signal swipeDown()
    signal swipeLeft()
    signal swipeRight()

    signal tap()
    signal doubleTap()
    signal hold()    

    //detects inventory drag/drop
    property string useWithInventoryId;

    signal dropped
    onDropped: {if(useWithInventoryId) useWith()}

    signal useWith
    onUseWith: console.log('----------------- use with '+useWithInventoryId);

    //optional for odd shaped areas
    property var areaVertices: [];
    Component.onCompleted: initArea();
    Polygon {
        id: interactArea
        vertices: areaVertices
    }                

    //detects when active inventory is dropped on this
    //TODO: polygon collider (with counter-clockwise vertices?)
    BoxCollider {
      id: boxCollider
      x: interactable.x
      y: interactable.y
      width: interactable.width
      height: interactable.height

      collisionTestingOnlyMode: true
      categories: Box.Category5
      collidesWith: Box.Category4

      property var collidedCollider;

      fixture.onBeginContact: {
        collidedCollider = other.parent.parent;
        collidedCollider.dropped.connect(dropped);
        interactable.useWithInventoryId = collidedCollider.inventoryId;
      }

      fixture.onEndContact: {
        collidedCollider.dropped.disconnect(dropped);
        interactable.useWithInventoryId = '';
      }
    }


    // trigger mouse interaction signals
    MouseArea {
        anchors.fill: parent
        onReleased: if(inArea(mouse)) triggerSwipe(mouse)
        onClicked: if(inArea(mouse)) tap()
        onDoubleClicked: if(inArea(mouse)) doubleTap()
        onPressAndHold: if(inArea(mouse)) hold()
    }


    //only triggers a swipe if the mouse has traveled > 20
    function triggerSwipe (mouse) {
        var tw = triggerSensitivity
        var th = triggerSensitivity
        var x = mouse.x - tw;
        var y = - (mouse.y  - th);

        if(Math.abs(y) > Math.abs(x) && Math.abs(y) > (th+1)) {
            if(y > 0) {
                swipeUp()
            } else {
                swipeDown()
            }
        } else if(Math.abs(x) > Math.abs(y) && Math.abs(x) > (tw+1)) {
            if(x > 0) {
                swipeRight()
            } else {
                swipeLeft()
            }
        }
    }

    function inArea(mouse) {        
        return !(areaVertices.length && !wn_PnPoly(mouse))
    }

    function initArea(){

        if(areaVertices.length){

            var minX, minY, maxX, maxY, v;
            minX = maxX = areaVertices[0].x;
            minY = maxY = areaVertices[0].y;

            for(var i = 0; i < areaVertices.length; i++){
                v = areaVertices[i];
                minX = Math.min(minX, v.x);
                minY = Math.min(minY, v.y);
                maxX = Math.max(maxX, v.x);
                maxY = Math.max(maxY, v.y);
            }

            interactable.x = minX;
            interactable.y = minY;
            interactable.width = maxX-minX;
            interactable.height = maxY-minY;

        }
    }


    // Copyright 2000 softSurfer, 2012 Dan Sunday
    // This code may be freely used and modified for any purpose
    // providing that this copyright notice is included with it.
    // SoftSurfer makes no warranty for this code, and cannot be held
    // liable for any real or imagined damage resulting from its use.
    // Users of this code must verify correctness for their application.
    //http://geomalgorithms.com/a03-_inclusion.html

    // isLeft(): tests if a point is Left|On|Right of an infinite line.
    //    Input:  three points P0, P1, and P2
    //    Return: >0 for P2 left of the line through P0 and P1
    //            =0 for P2  on the line
    //            <0 for P2  right of the line
    //    See: Algorithm 1 "Area of Triangles and Polygons"
    function isLeft(P0, P1, P2) {
        return ( (P1.x - P0.x) * (P2.y - P0.y) - (P2.x -  P0.x) * (P1.y - P0.y) );
    }

    // wn_PnPoly(): winding number test for a point in a polygon
    //      Input:   P = a point,
    //               V[] = vertex points of a polygon V[n+1] with V[n]=V[0] -- areaVertices
    //      Return:  wn = the winding number (=0 only when P is outside)
    function wn_PnPoly(P) {
        var wn = 0;    // the  winding number counter
        var V = areaVertices;

        if(V.length){
            var nextV, thisV;
            // loop through all edges of the polygon
            for (var i=0; i<V.length; i++) {   // edge from V[i] to  V[i+1]
                thisV = V[i];
                nextV = V[i+1] || V[0];

                if (thisV.y <= P.y) {          // start y <= P.y
                    if (nextV.y  > P.y) {      // an upward crossing
                         if (isLeft(thisV, nextV, P) > 0) {  // P left of  edge
                             ++wn;            // have  a valid up intersect
                         }
                    }
                }
                else {                        // start y > P.y (no test needed)
                    if (nextV.y  <= P.y) {     // a downward crossing
                         if (isLeft(thisV, nextV, P) < 0) { // P right of  edge
                             --wn;            // have  a valid down intersect
                         }
                    }
                }
            }
        }
        return wn;
    }

}

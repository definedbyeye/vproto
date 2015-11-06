.pragma library
function deepCopy(obj) {
    return JSON.parse(JSON.stringify(obj));
}

function pointInPoly(point, vertices){
    return wn_PnPoly(point, vertices) !== 0;
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
function wn_PnPoly(P, V) {
    var wn = 0;    // the  winding number counter

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

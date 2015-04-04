import VPlay 2.0
import QtQuick 2.0

PolygonCollider {

    //player collides with Category1
    categories: Box.Category2
    collidesWith: Box.Category1

    // the BoxCollider will not be affected by gravity or other applied physics forces
    collisionTestingOnlyMode: false
    bodyType: Body.Static
    vertices: []

    fixture.onBeginContact: {}
}


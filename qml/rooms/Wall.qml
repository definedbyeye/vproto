import VPlay 2.0
import QtQuick 2.0


PolygonCollider {
    //player collides with Category1
    categories: Box.Category1
    //collidesWith: Box.Category2

    // the BoxCollider will not be affected by gravity or other applied physics forces
    collisionTestingOnlyMode: false
    bodyType: Body.Static
    vertices: []

    fixture.onBeginContact: {
        console.log('wall collideded with player!!')
    }
}


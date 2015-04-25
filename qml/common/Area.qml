import VPlay 2.0
import QtQuick 2.0

PolygonCollider {

    signal entered

    categories: Box.Category3   // area
    collidesWith: Box.Category1 // player

    // the BoxCollider will not be affected by gravity or other applied physics forces
    collisionTestingOnlyMode: true
    bodyType: Body.Static
    vertices: []

    fixture.onBeginContact: {
        console.log('----- entered area')
        entered();
    }

}


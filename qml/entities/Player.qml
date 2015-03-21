import VPlay 2.0
import QtQuick 2.0

EntityBase {
  id: player
  entityType: "player"
  width: 57
  height: 192

  // add some aliases for easier access to those properties from outside
  //property alias collider: collider
  //property alias horizontalVelocity: collider.linearVelocity.x

  // start with jumping state, because we let the player fall from the sky at start
  //state: "jumping"

  // here you could use a SpriteSquenceVPlay to animate your player
  MultiResolutionImage {
    source: "../../assets/player/player.png"
  }

  /*
  BoxCollider {
    id: collider
    height: parent.height
    width: 30
    anchors.horizontalCenter: parent.horizontalCenter
    // this collider must be dynamic because we are moving it by applying forces and impulses
    bodyType: Body.Dynamic // this is the default value but I wanted to mention it ;)
    fixedRotation: true // we are running, not rolling...
    bullet: true // for super accurate collision detection, use this sparingly, because it's quite performance greedy
    fixture.onBeginContact: {
      var otherCollider = other.parent.parent
      var otherEntity = otherCollider.owningEntity
      // if the player contacts the ground or a platform (which is not in cloud mode), we set it's state to walking, which will enable jumps
      if(otherEntity.entityType === "ground") {
        player.state = "walking"
      } else if(otherEntity.entityType === "platform" && !otherCollider.collisionTestingOnlyMode) {
        player.state = "walking"
      }
    }
    fixture.onEndContact: {
      var otherCollider = other.parent.parent
      var otherEntity = otherCollider.owningEntity
      // as soon as the player leaves the ground or platforms, we set the state to jumping, disabling further jumps
      if(otherEntity.entityType === "ground") {
        player.state = "jumping"
      } else if(otherEntity.entityType === "platform") {
        player.state = "jumping"
      }
    }
  }

  function jump() {
    if(player.state == "walking") {
      // for the jump, we simplay apply an upward impulse to the collider
      collider.applyLinearImpulse(Qt.point(0,-420), collider.body.getWorldCenter())
    }
  }
  */
}


import VPlay 2.0
import QtQuick 2.0
import "common"
import "scenes"

GameWindow {
    id: gameWindow

    licenseKey: "2B76C38A127992D0AA2E4CE6BD373B22B9F0A86987E3BE24FAAE3B7796867D0D6014D693C5C5CE5D2D9DC3748D6EBCE08190EC4125893320504917B4D0E00B65991EDF5CD666D857D0383B6B8D8169FF568A0E87D7386C3AE021DFB58D41AF50A5528382E3FB64A3233BC9B5A88B6B12145BF5CB528BC95E31154B155CDC84A35091785533D48E776EDCC48D6BDAA31929AD5A83D6C038BF4B8E61756C1F5DC838C90AFD0678696F95FA635127175E364588AD859C959F1B3B004A7E03AB63B46F2E554A6FBA550287183E9B6FEDA7C62B2825528E574EFC7FFBA8F017E52D854C55452234273FFAA5A6ADFAC98C5F3288D7EE725868CF48A4B0D78628D498CAF1278D490BCD74D5B48D3C2FAA9D0E3103DAB22ADF2BB93CFAF8E6CA277BCCFD"

    width: 960
    height: 640

    Data {
        id: storage
    }

    EntityManager {
        id: entityManager
        entityContainer: gameScene
        dynamicCreationEntityList: []
    }

    state: "menu"
    activeScene: menuScene

    MenuScene {
        id: menuScene
    }

    GameScene {
        id: gameScene
    }

    CreditsScene {
        id: creditsScene
    }

    // state machine, takes care of reversing the PropertyChanges when changing the state, like changing the opacity back to 0
    states: [
        State {
            name: "menu"
            PropertyChanges {target: menuScene; opacity: 1}
            PropertyChanges {target: gameWindow; activeScene: menuScene}
        },
        State {
            name: "game"
            PropertyChanges {target: gameScene; opacity: 1}
            PropertyChanges {target: gameWindow; activeScene: gameScene}
        },
        State {
            name: "credits"
            PropertyChanges {target: creditsScene; opacity: 1}
            PropertyChanges {target: gameWindow; activeScene: creditsScene}
        }
    ]

}


//
//  StartScreenScene.swift
//  games
//
//  Created by Sergii Kotyk on 21/4/2022.
//

import Foundation
import SpriteKit

class StartScreenScene: SKScene{
    
    func addLabel(text: String, position: CGPoint){
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = text
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = position
        addChild(label)
        label.name = text
    }
    
    


    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = SKColor.white
        
        let position1 = CGPoint(x: size.width/2, y: size.height * 0.666)
        let position2 = CGPoint(x: size.width/2, y: size.height * 0.333)
        
        addLabel(text: "Stealthy Ninja", position: position1)
        addLabel(text: "Nimble Ninja", position: position2)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      // 1 - Choose one of the touches to work with
      guard let touch = touches.first else {
        return
      }
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        if touchedNode.name == "Stealthy Ninja"{
            let reveal = SKTransition.doorsOpenVertical(withDuration: 0.5)
            let stealthyNinjaScene = StealthyNinjaScene(size: self.size)
            self.view?.presentScene(stealthyNinjaScene, transition: reveal)
        }
        if touchedNode.name == "Nimble Ninja"{
            let reveal = SKTransition.doorsOpenVertical(withDuration: 0.5)
            let nimbleNinja = NimbleNinjaScene(size: self.size)
            self.view?.presentScene(nimbleNinja, transition: reveal)
        }
    }
}


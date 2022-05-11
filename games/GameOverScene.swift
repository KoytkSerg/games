//
//  GameOverScene.swift
//  games
//
//  Created by Sergii Kotyk on 29/4/2022.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    init(size: CGSize, won:Bool, score: Int?) {
    super.init(size: size)
    
    // 1
       backgroundColor = SKColor.white
    
    // 2
        let message = won ? "You Won!" : "You Lose :["
    
    // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        if score != nil{
            let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
            scoreLabel.text = "Score: \(score!)"
            scoreLabel.fontSize = 20
            scoreLabel.fontColor = SKColor.black
            scoreLabel.position = CGPoint(x: size.width/2, y: size.height * 0.3)
            addChild(scoreLabel)
        }

    
    // 4
    run(SKAction.sequence([
        SKAction.wait(forDuration: 6.0),
        SKAction.run() { [weak self] in
        // 5
          guard let `self` = self else { return }
          let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
          let scene = StartScreenScene(size: size)
          self.view?.presentScene(scene, transition:reveal)
        }
      ]))
   }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        run(SKAction.run() { [weak self] in
            // 5
            guard let `self` = self else { return }
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
              let scene = StartScreenScene(size: self.size)
            self.view?.presentScene(scene, transition:reveal)
          }
          )
    }
  
  // 6
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


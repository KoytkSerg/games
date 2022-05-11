//
//  GameScene.swift
//  games
//
//  Created by Sergii Kotyk on 18/4/2022.
//

import SpriteKit
import GameplayKit

class StealthyNinjaScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "player")
    let lightBall = SKSpriteNode()
    let exitButton = SKLabelNode(fontNamed: "Chalkduster")
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var time = 0 {
        didSet{
            lightBall.removeFromParent()
            lightningBallSetup(diametr: CGFloat(100 + time))
            score += time
            
        }
    }
    
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    

    
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        backgroundColor = SKColor.white
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        
        let scorePosition = CGPoint(x: size.width * 0.1, y: size.height * 0.1)
        let exitPosition = CGPoint(x: size.width * 0.1, y: size.height * 0.9)
        
        playerSetup()
        lightningBallSetup(diametr: 100)
        
        addLabel(labelNode: scoreLabel, text: "Score: \(score)", position: scorePosition)
        addLabel(labelNode: exitButton, text: "Exit", position: exitPosition)
        
        timerFunc()
        
    }
    
    override func didEvaluateActions() {
        super.didEvaluateActions()
        move(node: lightBall, to: player.position, speed: 90)
    }
    
    func timerFunc(){
        
        let wait = SKAction.wait(forDuration: 1)
        let block = SKAction.run({
            [unowned self] in
            self.time += 1
        })
        let sequence = SKAction.sequence([wait,block])
        run(SKAction.repeatForever(sequence))

    }
    
    func playerSetup(){
        player.size = CGSize(width: 30, height: 30)
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.lightBall
        player.physicsBody?.collisionBitMask = 0
        
    
        addChild(player)
        }
    
    func lightningBallSetup(diametr: CGFloat){
        let circleShape = SKShapeNode(circleOfRadius: diametr)
        circleShape.fillColor = SKColor.yellow
        lightBall.texture = view!.texture(from: circleShape)
        lightBall.size = CGSize(width: diametr, height: diametr)
        lightBall.position = CGPoint(x: size.width * 0.1, y: size.height * 0.1)
        
        lightBall.physicsBody = SKPhysicsBody(circleOfRadius: diametr/2)
        lightBall.physicsBody?.isDynamic = true
        lightBall.physicsBody?.categoryBitMask = PhysicsCategory.lightBall
        lightBall.physicsBody?.contactTestBitMask = PhysicsCategory.player
        lightBall.physicsBody?.collisionBitMask = 0
        
        addChild(lightBall)
    }
    
    
    func addLabel(labelNode: SKLabelNode, text: String, position: CGPoint){
        labelNode.text = text
        labelNode.fontSize = 20
        labelNode.fontColor = SKColor.black
        labelNode.position = position
        labelNode.name = text
        addChild(labelNode)
    }
    
    func move(node: SKSpriteNode, to: CGPoint, speed: CGFloat){
        let x = node.position.x
        let y = node.position.y
        let distance = sqrt((x - to.x) * (x - to.x) + (y - to.y) * (y - to.y))
        let dur = distance / speed
        let move = SKAction.move(to: to, duration: dur)
        node.run(move)
    }
    
    func loose(){
        let loseAction = SKAction.run() { [weak self] in
          guard let `self` = self else { return }
          let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false, score: self.score)
          self.view?.presentScene(gameOverScene, transition: reveal)
        }
        run(loseAction)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let touch = touches.first else {
        return
      }
        let touchLocation = touch.location(in: self)
        move(node: player, to: touchLocation, speed: 200)
    
        let touchedNode = atPoint(touchLocation)
        if touchedNode.name == "Exit"{
            let reveal = SKTransition.doorsCloseVertical(withDuration: 0.5)
            let StartScreen = StartScreenScene(size: self.size)
            self.view?.presentScene(StartScreen, transition: reveal)
        }

    }
}

extension StealthyNinjaScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        loose()
        print("hit")
    }
}

//
//  game2Scene.swift
//  games
//
//  Created by Sergii Kotyk on 27/4/2022.
//

import Foundation
import SpriteKit




class NimbleNinjaScene: SKScene{
    let player = SKSpriteNode(imageNamed: "player")
    let floor = SKSpriteNode()
    var wallSpeed = 0.0
    
    var count = 0{
        didSet{
            scoreLabel.text = "Score: \(count)"
            switch count{
            case 1:
                wallSpeed = 3
                wallsRun(count: 3)
            case 11:
                wallSpeed = 2
                wallsRun(count: 6)
            case 24:
                wallSpeed = 1
                wallsRun(count: 10)
            case 35:
                wallSpeed = 0.8
                wallsRun(count: 50)
            case 40:
                let winAction = SKAction.run() { [weak self] in
                  guard let `self` = self else { return }
                  let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let gameOverScene = GameOverScene(size: self.size, won: true, score: nil)
                  self.view?.presentScene(gameOverScene, transition: reveal)
                }
                run(winAction)
            default:
                return
            }
        }
    }
    
    var health = 100{
        didSet{
            healthLabel.text = "Health: \(health)%"
            switch health{
            case 75:
                backgroundColor = SKColor.orange
            case 50:
                backgroundColor = SKColor.purple
            case 25:
                backgroundColor = SKColor.red
            case 0:
                let loseAction = SKAction.run() { [weak self] in
                  guard let `self` = self else { return }
                  let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let gameOverScene = GameOverScene(size: self.size, won: false, score: self.count)
                  self.view?.presentScene(gameOverScene, transition: reveal)
                }
                run(loseAction)
            default:
                return
            }
        }
    }
    
    let exitButton = SKLabelNode(fontNamed: "Chalkduster")
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    let healthLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = SKColor.white
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        let edge = frame.insetBy(dx: 0, dy: 0)
        physicsBody = SKPhysicsBody(edgeLoopFrom: edge)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.edge
        
        objectSetup(node: floor,
                    size: CGSize(width: size.width, height: size.height*0.4),
                    position: CGPoint(x: size.width/2, y: size.height * 0.2),
                    color: SKColor.black,
                    categoryBitMask: PhysicsCategory.floor,
                    contactTestBitMask: [PhysicsCategory.player],
                    collisionBitMask: [PhysicsCategory.player, PhysicsCategory.edge])
        
        objectSetup(node: player,
                    size: CGSize(width: size.width/20, height: size.width/20),
                    position: CGPoint(x: size.width * 0.4, y: size.height * 0.6),
                    color: SKColor.red,
                    categoryBitMask: PhysicsCategory.player,
                    contactTestBitMask: [PhysicsCategory.floor],
                    collisionBitMask: [PhysicsCategory.floor, PhysicsCategory.wall])
        

        floor.physicsBody?.isDynamic = false
        floor.physicsBody?.mass = 1000

        addLabel(labelNode: scoreLabel, text: "Score: \(count)", position: CGPoint(x: size.width * 0.1, y: size.height * 0.1))
        addLabel(labelNode: healthLabel, text: "Health: \(health)%", position: CGPoint(x: size.width * 0.5, y: size.height * 0.9))
        addLabel(labelNode: exitButton, text: "Exit", position: CGPoint(x: size.width * 0.1, y: size.height * 0.9))
        scoreLabel.fontColor = SKColor.white
        
        timerFunc()

    }
    
    func wallsRun(count: Int){
        
        let wallRunAction = SKAction.repeat(
                SKAction.sequence([
                    SKAction.run(self.wallFunc),
                    SKAction.wait(forDuration: self.wallSpeed)
                ]), count: count)
        
        
        run(SKAction.sequence([
            wallRunAction,
            SKAction.run(self.removeAllActions),
            SKAction.run(timerFunc)
        ]))
    }
    
    func timerFunc(){
        
        let wait = SKAction.wait(forDuration: 1)
        let block = SKAction.run({
            [unowned self] in
            self.count += 1
            if player.position.x < 0{
                health = 0
            }
        })
        let sequence = SKAction.sequence([wait,block])
        run(SKAction.repeatForever(sequence))

    }
    
    func wallFunc(){
        let wall = SKSpriteNode()
        objectSetup(node: wall,
                    size: CGSize(width: size.width/30, height: size.width/13),
                    position: CGPoint(x: size.width - 50, y: 0 ),
                    color: SKColor.brown,
                    categoryBitMask: PhysicsCategory.wall,
                    contactTestBitMask: [PhysicsCategory.player],
                    collisionBitMask: [PhysicsCategory.floor, PhysicsCategory.player])
        
        let surface = floor.position.y + floor.size.height/2
        
        wall.position = CGPoint(x: wall.position.x, y: surface + wall.size.height/2)
        wall.physicsBody?.mass = 100
        wall.physicsBody?.isDynamic = false
        
        wall.run(SKAction.sequence([
                    SKAction.move(to: CGPoint(x: 0, y: size.height * 0.5), duration: 2),
                    SKAction.removeFromParent()]))

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {
          return
        }
        let touchLocation = touch.location(in: self)
        
        let touchedNode = atPoint(touchLocation)
        if touchedNode.name == "Exit"{
            self.isPaused = true
            let reveal = SKTransition.doorsCloseVertical(withDuration: 0.5)
            let StartScreen = StartScreenScene(size: self.size)
            self.view?.presentScene(StartScreen, transition: reveal)
            
        }
        if player.position.y <= 207{
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
            player.physicsBody?.applyTorque(-0.5)
        }
    }
    
    func addLabel(labelNode: SKLabelNode, text: String, position: CGPoint){
        labelNode.text = text
        labelNode.fontSize = 20
        labelNode.fontColor = SKColor.black
        labelNode.position = position
        labelNode.name = text
        addChild(labelNode)

    }
    
    func objectSetup(node: SKSpriteNode,
                     size: CGSize,
                     position: CGPoint,
                     color: SKColor,
                     categoryBitMask: UInt32,
                     contactTestBitMask: [UInt32],
                     collisionBitMask: [UInt32])
    {
        node.size = size
        node.position = position
        node.color = color
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.categoryBitMask = categoryBitMask
        for i in contactTestBitMask{
            node.physicsBody?.contactTestBitMask |= i
        }
        for i in collisionBitMask{
            node.physicsBody?.collisionBitMask |= i
        }
        addChild(node)
    }
    

    
    func hit(wall: SKSpriteNode){
        wall.run(SKAction.sequence([SKAction.wait(forDuration: 0,withRange: 2), SKAction.removeFromParent()]))
        health -= 5
    }
    
    
}

extension NimbleNinjaScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        

        var wallBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            wallBody = contact.bodyB
        } else {
            wallBody = contact.bodyA
        }
        
        switch contactMask {

        case PhysicsCategory.player | PhysicsCategory.wall:
            print("hit")
            if let wall = wallBody.node as? SKSpriteNode{
                hit(wall: wall)
            }
        default:
            return
        }
    }
}

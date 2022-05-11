//
//  GameViewController.swift
//  games
//
//  Created by Sergii Kotyk on 18/4/2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.myOrientation = .landscape
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let scene = StartScreenScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }


   
}

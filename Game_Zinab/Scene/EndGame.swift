//
//  File.swift
//  Game_Zinab
//
//  Created by MARWAH MOHAMMED ISMAIL on 12/11/1445 AH.
//

import Foundation
import SpriteKit

class EndScene : SKScene {
//    self.removeAllActions()

    override func sceneDidLoad() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            let scene = SKScene(fileNamed: "StartScene")
            scene?.scaleMode = .aspectFill
            self.view?.presentScene(scene!)
        }
    }
}

//
//  File.swift
//  Game_Zinab
//
//  Created by MARWAH MOHAMMED ISMAIL on 12/11/1445 AH.
//

import Foundation
import SpriteKit

class EndGame : SKScene {
    
//    override func sceneDidLoad(){
//        print("transitionToNextScene()")
//        transitionToNextScene()
//    }
//
//    func transitionToNextScene() {
//        if let view = self.view {
//            let transition = SKTransition.fade(withDuration: 1.0) // تخصيص الانتقال
//            if let nextScene = SKScene(fileNamed: "StartScene") {
//                nextScene.scaleMode = .aspectFill
//                view.presentScene(nextScene, transition: transition)
//                print("تم الانتقال إلى المشهد التالي")
//            } else {
//                print("فشل في تحميل مشهد ")
//            }
//        }
//    }
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }

        
        override func didMove(to view: SKView) {
            print("transitionToNextScene()")
            Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (timer) in
                self.removeFromParent()

                let scene = SKScene(fileNamed: "StartScene")
                scene?.scaleMode = .aspectFill
                self.view?.presentScene(scene!)
            }
        }
    }


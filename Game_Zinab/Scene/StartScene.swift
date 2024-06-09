import UIKit
import SpriteKit
import GameplayKit
import GameKit

class StartScene: SKScene {
    var startButton: SKNode?
//    var isStart = false
    var enemy : SKNode?
    var enemy2 : SKNode?
    
    override func didMove(to view: SKView) {
        enemy = childNode(withName: "pinkOcto")
        enemy2 = childNode(withName: "purblOcto")
        
        print("Start scene loaded")
        
        startButton = childNode(withName: "startButton")
        GameHelper.moveEnemyVertically(enemy: enemy, startY: 160, endY: 100, duration: 2.0)
        GameHelper.moveEnemyVertically(enemy: enemy2, startY: 160, endY: 100, duration: 1.0)
        
        
        
    }
    func generateImpactFeedback() {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            // التحقق إذا كانت اللمسة داخل الزر
            if startButton?.contains(location) == true {
                print("Start button touched")
                // تغيير الحالة إلى true لتبدأ اللعبة
//                self.isStart = true
                generateImpactFeedback()
                
                
                
                if let viewController = self.view?.window?.rootViewController as? GameViewController {
//                    viewController.authenticateLocalPlayer()
                    viewController.startMatchmaking()
                }
//                let scene = GameScene(fileNamed: "GameScene") {
                //                    scene.scaleMode = .aspectFill
                //                    // تقديم مشهد اللعب مع انتقال
                //                    view?.presentScene(scene, transition: SKTransition.doorsOpenHorizontal(withDuration: 2.0))
                
                // تحميل مشهد اللعب
                //                if let scene = GameScene(fileNamed: "GameScene") {
                //                    scene.scaleMode = .aspectFill
                //                    // تقديم مشهد اللعب مع انتقال
                //                    view?.presentScene(scene, transition: SKTransition.doorsOpenHorizontal(withDuration: 2.0))
                //                } else {
                //                    print("Failed to load GameScene")
                //                }
                //            } else {
                //                print("Start button not touched")
                //            }
            }
        }
        
    }
}

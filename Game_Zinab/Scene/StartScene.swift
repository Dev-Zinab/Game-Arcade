
import GroupActivities
import UIKit
import SpriteKit
import GameplayKit
import GameKit

class StartScene: SKScene {
    var startButton: SKNode?
//    var enemy
    var isStart = false

    override func didMove(to view: SKView) {
        print("Start scene loaded")
        // تعيين الزر من الـ scene
        startButton = childNode(withName: "startButton")
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
                // تغيير الحالة إلى true لتبدأ اللعبة
                self.isStart = true
                generateImpactFeedback()

                // تحميل مشهد اللعب
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    // تقديم مشهد اللعب مع انتقال
                    view?.presentScene(scene, transition: SKTransition.doorsOpenHorizontal(withDuration: 2.0))
                }
            }
        }
    }
}

import Foundation
import SpriteKit

class GameOver: SKScene {
    
    var qButn: SKNode?
    var isquit = false
    var reButn: SKNode?
    var isReplayed = false

    override func didMove(to view: SKView) {
        print("touchesBegan is called1")

        qButn = childNode(withName: "qButn")
        reButn = childNode(withName: "reButn")

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan is called")

        for touch in touches {
            let location = touch.location(in: self)
            // التحقق إذا كانت اللمسة داخل الزر
            if qButn?.contains(location) == true {
                // تحميل مشهد StartScene
                self.isquit = true
                 let scene = SKScene(fileNamed: "StartScene")
                scene?.scaleMode = .aspectFill
                view?.presentScene(scene!, transition: SKTransition.doorsOpenHorizontal(withDuration: 2.0))
                
            }
             if reButn?.contains(location) == true {
                // تحميل مشهد GameScene
                self.isReplayed = true

                 let scene = SKScene(fileNamed: "GameScene")
                    scene?.scaleMode = .aspectFill
                view?.presentScene(scene!, transition: SKTransition.doorsOpenHorizontal(withDuration: 2.0))
                
            }
        }
    }
}

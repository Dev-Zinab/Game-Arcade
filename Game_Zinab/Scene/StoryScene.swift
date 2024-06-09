//import SpriteKit
//
//
//class StoryScene: SKScene {
//    
//    override func didMove(to view: SKView) {
//        transitionToStartScene()
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        transitionToStartScene()
//    }
//    
//    func transitionToStartScene() {
//        print("Attempting to transition to StartScene")
//        
//        if let startScene = SKScene(fileNamed: "StartScene") {
//            startScene.scaleMode = .aspectFill
//            let transition = SKTransition.fade(withDuration: 1.0)
//            
//            if let view = self.view {
//                view.presentScene(startScene, transition: transition)
//            } else {
//                print("Failed to present StartScene. View is nil.")
//            }
//        } else {
//            print("Failed to load StartScene.sks")
//        }
//    }}

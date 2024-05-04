import SpriteKit

class StoryScene: SKScene {
    override func didMove(to view: SKView) {
        transitionToStartScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        transitionToStartScene()
    }
    
    func transitionToStartScene() {
        print("Attempting to transition to StartScene")
        if let scene = StartScene(fileNamed: "StartScene") {
            scene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1.0)
            self.view?.presentScene(scene, transition: transition)
        } else {
            print("Failed to load StartScene.sks")
        }
    }
}

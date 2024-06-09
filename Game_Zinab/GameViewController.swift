
import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate {

    var match: GKMatch?
    var gameScene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the main view and scene
        
        if let view = self.view as! SKView? {
            // قم بتحميل SKScene من 'StoryScene.sks'
            let scene = Story(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            
            // قم بعرض المشهد
            view.presentScene(scene)
            
        }
  
            // Authenticate the local player for Game Center
//        DispatchQueue.main.asyncAfter(deadline: .now() + 26.0) {
//            self.authenticateLocalPlayer()
//        }

    }

    // MARK: - Game Center Authentication and Display

    func showGameCenter() {
        let viewController = GKGameCenterViewController(state: .localPlayerProfile)
        viewController.gameCenterDelegate = self
        present(viewController, animated: true, completion: nil)
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { [weak self] viewController, error in
            DispatchQueue.main.async {
                if let viewController = viewController {
                    self?.present(viewController, animated: true, completion: nil)
                } else if localPlayer.isAuthenticated {
                    // Player is authenticated
                    self?.startMatchmaking() //
                } else {
                    if let error = error {
                        print("Authentication failed! Error: \(error.localizedDescription)")
                    } else {
                        print("Authentication failed without an error message!")
                    }
                }
            }
        }
    }

    // MARK: - Matchmaking

    func startMatchmaking() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2

        let mmvc = GKMatchmakerViewController(matchRequest: request)
        mmvc?.matchmakerDelegate = self
        if let viewController = mmvc {
            present(viewController, animated: true, completion: nil)
        }
    }

    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true, completion: nil)
        print("Matchmaker vc did fail with error: \(error.localizedDescription)")
    }

    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(animated: true, completion: nil)
        self.match = match
        match.delegate = self

        // Load GameScene when match is found
        if let view = self.view as? SKView {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            self.gameScene = scene
        }
    }

//    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
//        if let message = String(data: data, encoding: .utf8) {
//            print("Received data: \(message)")
//        }
//    }
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if let positionString = String(data: data, encoding: .utf8) {
            let components = positionString.split(separator: ",")
            if components.count == 2,
               let x = Double(components[0]),
               let y = Double(components[1]) {
                let position = CGPoint(x: x, y: y)
                
                // نفترض أن player1 هو اللاعب المحلي و player2 هو اللاعب الآخر
                if player.teamPlayerID == GKLocalPlayer.local.teamPlayerID {
                    gameScene.updatePlayer1Position(to: position)
                } else {
                    gameScene.updatePlayer2Position(to: position)
                }
            }
        }
    }
    func sendPlayerMovement(position: CGPoint) {
        guard let match = self.match else { return }
        
        let data = "\(position.x),\(position.y)".data(using: .utf8)!
        do {
            try match.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("Error sending data: \(error.localizedDescription)")
        }
    }


    // MARK: - ViewController Lifecycle Overrides

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .phone ? .allButUpsideDown : .all
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

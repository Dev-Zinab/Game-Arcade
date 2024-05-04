
import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate {

    var match: GKMatch?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the main view and scene
        if let view = self.view as? SKView, let scene = SKScene(fileNamed: "StartScene") {
            scene.scaleMode = .aspectFill
            scene.isUserInteractionEnabled = true
            view.presentScene(scene)
        }

        // Authenticate the local player for Game Center
        authenticateLocalPlayer()
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
                    self?.startMatchmaking()
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
    }

    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if let message = String(data: data, encoding: .utf8) {
            print("Received data: \(message)")
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

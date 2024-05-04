import Foundation
import GameplayKit

fileprivate let characterAnimationKey = "Sprite Animation"

struct PlayerConfiguration {
    let textureNames: [String]
    let textureName: String
    let animationKey: String
}

//  configurations for two players
let player1Config = PlayerConfiguration(textureNames: ["player1", "player1"], textureName: "player1", animationKey: "Player1Animation")
let player2Config = PlayerConfiguration(textureNames: ["player2", "player2"], textureName: "player2", animationKey: "Player2Animation")




class PlayerState: GKState {
    
    unowned var playerNode: SKNode
    var playerConfig: PlayerConfiguration

    init(playerNode: SKNode, playerConfig: PlayerConfiguration) {
        self.playerNode = playerNode
        self.playerConfig = playerConfig
        playerNode.physicsBody?.isDynamic = true
        
        playerNode.physicsBody?.affectedByGravity = true
        
        playerNode.physicsBody?.allowsRotation = false

        super.init()
    }
}





class JumpingState : PlayerState {
    
    var hasFinishedJumping : Bool = false

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is StunnedState.Type { return true }
        print("here1")

        return true
    }
    
    // Use playerConfig to get the correct jump textures
    lazy var textures: [SKTexture] = playerConfig.textureNames.map(SKTexture.init)
    
    // Define the action using the textures
    lazy var action = { SKAction.animate(with: textures, timePerFrame: 0.1) }()
    
    override func didEnter(from previousState: GKState?) {

        playerNode.removeAction(forKey: playerConfig.animationKey)
        playerNode.run(action, withKey: playerConfig.animationKey)
        hasFinishedJumping = false
        print("Velocity before jump: \(playerNode.physicsBody?.velocity.dy ?? 0)")
        playerNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        print("Velocity after jump: \(playerNode.physicsBody?.velocity.dy ?? 0)")
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {(timer) in
            self.hasFinishedJumping = true
        }
    }
}
class LandingState : PlayerState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        switch stateClass {
        case is LandingState.Type, is JumpingState.Type: return false
        default: return true
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        
        stateMachine?.enter(IdleState.self)
    }
}
class IdleState : PlayerState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is LandingState.Type, is IdleState.Type:
            return false
        default:
            return true
        }
    }

    // Use lazy var to access instance property playerConfig
    lazy var textures: [SKTexture] = [SKTexture(imageNamed: playerConfig.textureName)]
    lazy var action: SKAction = {
        SKAction.animate(with: textures, timePerFrame: 0.1)
    }()

    override func didEnter(from previousState: GKState?) {
        playerNode.removeAction(forKey: playerConfig.animationKey)
        playerNode.run(action, withKey: playerConfig.animationKey)
    }
}

class WalkingState: PlayerState {
    lazy var textures: [SKTexture] = playerConfig.textureNames.map(SKTexture.init)
    lazy var action = { SKAction.repeatForever(.animate(with: textures, timePerFrame: 0.1)) }()

    override func didEnter(from previousState: GKState?) {
        playerNode.removeAction(forKey: playerConfig.animationKey)
        playerNode.run(action, withKey: playerConfig.animationKey)
    }
}

class StunnedState : PlayerState {
    
    var isStunned : Bool = false
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        if isStunned { return false }
        
        switch stateClass {
        case is IdleState.Type: return true
        default: return false
        }
    }
    
    let action = SKAction.repeat(.sequence([
        .fadeAlpha(to: 0.5, duration: 0.01),
        .wait(forDuration: 0.25),
        .fadeAlpha(to: 1.0, duration: 0.01),
        .wait(forDuration: 0.25),
        ]), count: 5)
    
    override func didEnter(from previousState: GKState?) {
        
        isStunned = true
        
        playerNode.run(action)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
            self.isStunned = false
            self.stateMachine?.enter(IdleState.self)
        }
    }
}




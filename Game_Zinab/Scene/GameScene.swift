
    
import SpriteKit
import UIKit
import GameplayKit
import GameKit


struct PhysicsCatagory {
    static let flag : UInt32 = 3
    static let enemy : UInt32 = 1
    static let bullet : UInt32 = 4
    static let player1 : UInt32 = 2
    static let player2 : UInt32 = 2
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var realTimeGame: RealTimeGame!
    
    // Nodes
    var flag : SKNode?
    var bullet : SKNode?
    var enemy : SKNode?
    var enemy2 : SKNode?
    var cameraNode : SKCameraNode?
    var Cloud1 : SKNode?
    var Cloud2 : SKNode?
    var Cloud3 : SKNode?
    var sun : SKNode?
    var step : SKNode?
    
    // Joystick and attack buttons
    
    var joystick : SKNode?
    var joystickKnob : SKNode?
    var jumpB : SKNode?
    var attackA : SKNode?
    
    // Boolean flags
    var joystickAction = false
    var jumpBAction = false
    var isAttacking = false
    
    // Timer
    var timer: Timer?
    var timerLabel = SKLabelNode(fontNamed: "Chalkduster")
    var timeRemaining = 40
    
    // Leaderboard button
    var leaderboardButton: SKLabelNode?
    
    // Measure
    var knobRadius: CGFloat = 50.0
    
    // Sprite Engine
    var previousTimeInterval: TimeInterval = 0
    var playerIsFacingRight = true
    var playerSpeed = 4.0
    
    
    
    // Player nodes and Player state machines
    var player1: SKNode?
    var player2: SKNode?
    var player1StateMachine: GKStateMachine?
    var player2StateMachine: GKStateMachine?
    
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        realTimeGame = RealTimeGame()
        realTimeGame.authenticatePlayer()
        setupScene()
        setupUI()
        setupPhysics()
        startGameTimer()
        let backgroundMusic = SKAudioNode(fileNamed: "scenegh.wav")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    func setupScene() {
        self.size = CGSize(width: 812, height: 375)
        flag = childNode(withName: "flag")
        player1 = childNode(withName: "player1")
        player2 = childNode(withName: "player2")
        enemy = childNode(withName: "pinkOcto")
        enemy2 = childNode(withName: "purblOcto")
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
        jumpB = childNode(withName: "jumpB")
        attackA = childNode(withName: "attackA")
        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        Cloud1 = childNode(withName: "Cloud1")
        Cloud2 = childNode(withName: "Cloud2")
        Cloud3 = childNode(withName: "Cloud3")
        sun = childNode(withName: "sun")
        step = childNode(withName: "step")
        
        // Movement helpers
        GameHelper.moveEnemyHorizontally(enemy: enemy, startX: 340, endX: 325, duration: 1.0)
        GameHelper.moveEnemyVertically(enemy: enemy2, startY: 160, endY: 100, duration: 1.0)
        
        
        
        // Initialize state machines for both players
        
        if let player1 = player1, let player2 = player2 {
            player1StateMachine = GKStateMachine(states: [
                JumpingState(playerNode: player1, playerConfig: player1Config),
                WalkingState(playerNode: player1, playerConfig: player1Config),
                IdleState(playerNode: player1, playerConfig: player1Config),
                LandingState(playerNode: player1, playerConfig: player1Config),
                StunnedState(playerNode: player1, playerConfig: player1Config)
            ])
            
            player2StateMachine = GKStateMachine(states: [
                JumpingState(playerNode: player2, playerConfig: player2Config),
                WalkingState(playerNode: player2, playerConfig: player2Config),
                IdleState(playerNode: player2, playerConfig: player2Config),
                LandingState(playerNode: player2, playerConfig: player2Config),
                StunnedState(playerNode: player2, playerConfig: player2Config)
            ])
        }
        player1StateMachine?.enter(IdleState.self)
        player2StateMachine?.enter(IdleState.self)
        
    }
    
    func setupUI() {
        timerLabel = SKLabelNode(text: "Time: \(timeRemaining)")
        timerLabel.fontSize = 30
        timerLabel.fontColor = SKColor.green
        timerLabel.position = CGPoint(x: frame.minX, y: frame.maxY-50)
        timerLabel.fontName = UIFont.boldSystemFont(ofSize: 30).fontName
        addChild(timerLabel)
        
    }
    
    func setupPhysics() {
        physicsWorld.contactDelegate = self
    }
    
    func startGameTimer() {
        GameHelper.startTimer(in: self, timeInterval: 1.0, updateSelector: #selector(updateTimer))
    }
    
    func setupAudio() {
        let backgroundMusic = SKAudioNode(fileNamed: "scene1bg.wav")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    
    @objc func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            // التحقق من أن timerLabel لا يزال جزءًا من المشهد قبل تعديله
            if timerLabel.parent != nil {
                timerLabel.text = "Time: \(timeRemaining)"
            }
        } else {
            // Game over, stop the timer
            timer?.invalidate()
            timer = nil
            let gameOverScene = GameOver(fileNamed: "GameOver")
            self.view?.presentScene(gameOverScene)

        }
        
    }


}


    // MARK: Touches
    extension GameScene {
        // Touch Began
        func generateImpactFeedback() {
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            for touch in touches {
                let location = touch.location(in: self)

                // التعامل مع الأزرار أو المناطق التفاعلية
                switch true {
                case joystickKnob?.frame.contains(touch.location(in: joystick!)) ?? false:
                    joystickAction = true
                case jumpB?.contains(location) ?? false:
                    print("Entered JumpingState")
                    run(SKAction.playSoundFileNamed("jumb.wav", waitForCompletion: false))
                    self.player1StateMachine?.enter(JumpingState.self)
                case attackA?.contains(location) ?? false:
                    isAttacking = true
                    generateImpactFeedback()
                default:
                    break
                }
            }
        }
//
        // Touch Moved
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let joystick = joystick else { return }
            guard let joystickKnob = joystickKnob else { return }
            
            if !joystickAction { return }
            
            // Distance
            for touch in touches {
                let position = touch.location(in: joystick)
                
                let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
                let angle = atan2(position.y, position.x)
                
                if knobRadius > length {
                    joystickKnob.position = position
                } else {
                    joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
                }
            }
        }
        
        // Touch End
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                
                if let joystick = joystick {
                    let xJoystickCoordinate = touch.location(in: joystick).x
                    let xLimit: CGFloat = 200.0
                    if xJoystickCoordinate > -xLimit && xJoystickCoordinate < xLimit {
                        resetKnobPosition()}                } 
                if attackA?.contains(location) == true {
                    run(SKAction.playSoundFileNamed("mew.wav", waitForCompletion: false))
                    isAttacking = false
                    bullet?.removeFromParent()
                    
                }
                                
            }
        }
    }

    
    // MARK: Action
    extension GameScene {
        func resetKnobPosition() {
            let initialPoint = CGPoint(x: 0, y: 0)
            let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
            moveBack.timingMode = .linear
            joystickKnob?.run(moveBack)
            joystickAction = false
        }
    }
    
    // MARK: Game Loop
    extension GameScene {
        override func update(_ currentTime: TimeInterval) {
            let deltaTime = currentTime - previousTimeInterval
            
            previousTimeInterval = currentTime
            //camera
            cameraNode?.position.x = player1!.position.x
            
            if let cameraX = cameraNode?.position.x {
                timerLabel.position.x = cameraX - 300
            } else {
                timerLabel.removeFromParent() }
            joystick?.position.y = (cameraNode?.position.y)! - 100
            joystick?.position.x = (cameraNode?.position.x)! - 300
            jumpB?.position.y = (cameraNode?.position.y)! - 140.524
            jumpB?.position.x = (cameraNode?.position.x)! + 312
            attackA?.position.y = (cameraNode?.position.y)! - 69
            attackA?.position.x = (cameraNode?.position.x)! + 359.999
            
            
            // Player movement
            guard let joystickKnob = joystickKnob else { return }
            let xPosition = Double(joystickKnob.position.x)
            let positivePosition = xPosition < 0 ? -xPosition : xPosition
            
            if floor(positivePosition) != 0 {
                player2StateMachine?.enter(WalkingState.self)
                player1StateMachine?.enter(WalkingState.self)
            } else {
                player1StateMachine?.enter(IdleState.self)
                player2StateMachine?.enter(IdleState.self)
            }
            let displacement = CGVector(dx: deltaTime * xPosition * playerSpeed, dy: 0)
            let move = SKAction.move(by: displacement, duration: 0)
            let faceAction : SKAction!
            let movingRight = xPosition > 0
            let movingLeft = xPosition < 0
            if movingLeft && playerIsFacingRight {
                playerIsFacingRight = false
                let faceMovement = SKAction.scaleX(to: -1, duration: 0.0)
                faceAction = SKAction.sequence([move, faceMovement])
            }
            else if movingRight && !playerIsFacingRight {
                playerIsFacingRight = true
                let faceMovement = SKAction.scaleX(to: 1, duration: 0.0)
                faceAction = SKAction.sequence([move, faceMovement])
            } else {
                faceAction = move
            }
            player1?.run(faceAction)
            player2?.run(faceAction)
            
            
            //Baground parallax
            
            let parallax1 = SKAction.moveTo(x: (player1?.position.x)!/(-10), duration: 0.0)
            
            Cloud1?.run(parallax1)
            
            let parallax2 = SKAction.moveTo(x: (player1?.position.x)!/(-20), duration: 0.0)
            Cloud2?.run(parallax2)
            
            let parallax3 = SKAction.moveTo(x: (player1?.position.x)!/(-40), duration: 0.0)
            
            Cloud3?.run(parallax3)
            
            let parallax4 = SKAction.moveTo(x: (cameraNode?.position.x)!, duration: 2.0)
            sun?.run(parallax4)
            
            if isAttacking {
                PlayerAcation.spawnBullet(in: self, fromPlayer: player1!, isFacingRight: playerIsFacingRight, imageName: "melon")
            }
            
            
        }
    }
    
    // MARK: Collision
    
    
    
    extension GameScene {
        func didBegin(_ contact: SKPhysicsContact) {
            let bodyA = contact.bodyA
            let bodyB = contact.bodyB
            let die = SKAction.move(to: CGPoint(x: -300,y: -100), duration: 0.0)
            print (bodyA.categoryBitMask)
            print (bodyB.categoryBitMask)
            
            // التحقق من تصادم اللاعب مع العدو
            if (bodyA.categoryBitMask == PhysicsCatagory.player1 && bodyB.categoryBitMask == PhysicsCatagory.enemy) ||
                (bodyA.categoryBitMask == PhysicsCatagory.enemy && bodyB.categoryBitMask == PhysicsCatagory.player1) {
                player1?.run(die)
            }
            if (bodyA.categoryBitMask == PhysicsCatagory.player1 && bodyB.categoryBitMask == PhysicsCatagory.flag) ||
                (bodyA.categoryBitMask == PhysicsCatagory.flag && bodyB.categoryBitMask == PhysicsCatagory.player1) {
                self.removeFromParent()
                self.removeAllActions()


                run(SKAction.playSoundFileNamed("level-completed.wav", waitForCompletion: false))
                
                let end = GameScene(fileNamed: "EndGame")
                self.view?.presentScene(end)

            }
            
            if (bodyA.categoryBitMask == PhysicsCatagory.enemy && bodyB.categoryBitMask == PhysicsCatagory.bullet) ||
                (bodyA.categoryBitMask == PhysicsCatagory.bullet && bodyB.categoryBitMask == PhysicsCatagory.enemy) {
                // تصادم بين العدو والرصاصة
                run(SKAction.playSoundFileNamed("enmayheert.wav", waitForCompletion: false))
                
                if let enemyNode = bodyA.node as? SKSpriteNode, let bulletNode = bodyB.node as? SKSpriteNode {
                    // قم بإزالة العدو والرصاصة من اللعبة
                    enemyNode.removeFromParent()
                    bulletNode.removeFromParent()
                }
            }
            
        }
        
        
    }


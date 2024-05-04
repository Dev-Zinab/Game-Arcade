////
////  File.swift
////  Game_Zinab
////
////  Created by MARWAH MOHAMMED ISMAIL on 11/11/1445 AH.
////
//
//
//import SpriteKit
//import UIKit
//import GameplayKit
//import GameKit
//
//
//struct PhysicsCatagory2 {
//static let flag : UInt32 = 1
//static let enemy : UInt32 = 1
//static let bullet : UInt32 = 4
//static let player1 : UInt32 = 2
//static let player2 : UInt32 = 2
//}
//
//
//
//class GameScene2: SKScene, SKPhysicsContactDelegate {
//
//var realTimeGame: RealTimeGame!
//
//// Nodes
//var flag : SKNode?
//var bullet : SKNode?
//var enemy : SKNode?
//var enemy2 : SKNode?
//var cameraNode : SKCameraNode?
//var sun : SKNode?
//var step : SKNode?
//
//// Joystick and attack buttons
//
//var joystick : SKNode?
//var joystickKnob : SKNode?
//var jumpB : SKNode?
//var attackA : SKNode?
//
//// Boolean flags
//var joystickAction = false
//var jumpBAction = false
//var isAttacking = false
//
//// Timer
//var timer: Timer?
//var timerLabel = SKLabelNode(fontNamed: "Chalkduster")
//var timeRemaining = 50
//
//// Leaderboard button
//var leaderboardButton: SKLabelNode?
//
//// Measure
//var knobRadius: CGFloat = 50.0
//
//// Sprite Engine
//var previousTimeInterval: TimeInterval = 0
//var playerIsFacingRight = true
//var playerSpeed = 4.0
//
//
//
//// Player nodes and Player state machines
//var player1: SKNode?
//var player2: SKNode?
//var player1StateMachine: GKStateMachine?
//var player2StateMachine: GKStateMachine?
//
//
//
//override func didMove(to view: SKView) {
//    super.didMove(to: view)
//    realTimeGame = RealTimeGame()
//    realTimeGame.authenticatePlayer()
//    setupScene()
//    setupUI()
//    setupPhysics()
//    startGameTimer()
//
//    let backgroundMusic = SKAudioNode(fileNamed: "scenegh.wav")
//    backgroundMusic.autoplayLooped = true
//    addChild(backgroundMusic)
//}
//func setupScene() {
//    self.size = CGSize(width: 812, height: 375)
//    flag = childNode(withName: "flag")
//    player1 = childNode(withName: "player1")
//    player2 = childNode(withName: "player2")
//    enemy = childNode(withName: "firmonstr")
//    enemy2 = childNode(withName: "Bigfair")
//    joystick = childNode(withName: "joystick")
//    joystickKnob = joystick?.childNode(withName: "knob")
//    jumpB = childNode(withName: "jumpB")
//    attackA = childNode(withName: "attackA")
//    cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
//    sun = childNode(withName: "sun")
//    step = childNode(withName: "step")
//    
//    // Movement helpers
//    GameHelper.moveEnemyHorizontally(enemy: enemy, startX: 340, endX: 325, duration: 1.0)
//    GameHelper.moveEnemyVertically(enemy: enemy2, startY: 160, endY: 92, duration: 1.0)
//    
//    
//    
//    // Initialize state machines for both players
//    
//    if let player1 = player1, let player2 = player2 {
//        player1StateMachine = GKStateMachine(states: [
//            JumpingState(playerNode: player1, playerConfig: player1Config),
//            WalkingState(playerNode: player1, playerConfig: player1Config),
//            IdleState(playerNode: player1, playerConfig: player1Config),
//            LandingState(playerNode: player1, playerConfig: player1Config),
//            StunnedState(playerNode: player1, playerConfig: player1Config)
//        ])
//        
//        player2StateMachine = GKStateMachine(states: [
//            JumpingState(playerNode: player2, playerConfig: player2Config),
//            WalkingState(playerNode: player2, playerConfig: player2Config),
//            IdleState(playerNode: player2, playerConfig: player2Config),
//            LandingState(playerNode: player2, playerConfig: player2Config),
//            StunnedState(playerNode: player2, playerConfig: player2Config)
//        ])
//    }
//    player1StateMachine?.enter(IdleState.self)
//    player2StateMachine?.enter(IdleState.self)
//    
//}
//
//func setupUI() {
//    timerLabel = SKLabelNode(text: "Time: \(timeRemaining)")
//    timerLabel.fontSize = 30
//    timerLabel.fontColor = SKColor.green
//    timerLabel.position = CGPoint(x: frame.minX, y: frame.maxY-50)
//    timerLabel.fontName = UIFont.boldSystemFont(ofSize: 30).fontName
//    addChild(timerLabel)
//    
////        leaderboardButton = SKLabelNode(fontNamed: "Arial")
////        leaderboardButton?.text = "Leaderboard"
////        leaderboardButton?.fontSize = 20
////        leaderboardButton?.fontColor = SKColor.blue
////        leaderboardButton?.position = CGPoint(x: frame.maxX, y: frame.maxY-50)
////        leaderboardButton?.name = "leaderboardButton"
////        addChild(leaderboardButton!)
////        leaderboardButton?.isHidden = true
//}
//
//func setupPhysics() {
//    physicsWorld.contactDelegate = self
//}
//
//func startGameTimer() {
//    GameHelper.startTimer(in: self, timeInterval: 1.0, updateSelector: #selector(updateTimer))
//}
//
//func setupAudio() {
//    let backgroundMusic = SKAudioNode(fileNamed: "scene1bg.wav")
//    backgroundMusic.autoplayLooped = true
//    addChild(backgroundMusic)
//}
//
//
//@objc func updateTimer() {
//    if timeRemaining > 0 {
//        timeRemaining -= 1
//        // التحقق من أن timerLabel لا يزال جزءًا من المشهد قبل تعديله
//        if timerLabel.parent != nil {
//            timerLabel.text = "Time: \(timeRemaining)"
//        }
//    } else {
//        // Game over, stop the timer
//        timer?.invalidate()
//        timer = nil
//        gameOver()
//    }
//}
//
//func gameOver() {
//    if let view = self.view {
//        let gameOverScene = GameScene(fileNamed: "GameOver")
//        view.presentScene(gameOverScene!, transition: SKTransition.fade(withDuration: 1.0))
//        // إزالة timerLabel من المشهد لتجنب أي تعديلات لاحقة
//        timerLabel.removeFromParent()
//    }
//    print("Game Over!")
//}
//
//}
//
//
//
////    func startGame(){
////
////        gameOver = false
////        skScene.jumpBtn.isHidden = false
////        skScene.myLabel.isHidden = false
////        skScene.playBtn.isHidden = true
////        skScene.gameOverLabel.isHidden = true
////
////        skScene.leaderboardText.isHidden = true
////
////        if(!UserDefaults.standard.bool(forKey: "removeAdsKey")){
////            skScene.noAdsBtn.isHidden = true
////        }
////
////        score = 0
////        skScene.myLabel.text = "Score: \(score)"
////
////    }
////
////    func GameOver(){
////
////        skScene.jumpBtn.isHidden = true
////        skScene.playBtn.isHidden = false
////        skScene.gameOverLabel.isHidden = false
////
////        skScene.leaderboardText.isHidden = false
////
////        if(!UserDefaults.standard.bool(forKey: "removeAdsKey")){
////            skScene.noAdsBtn.isHidden = false
////        }
////
////        //reset hero and enemy position
////        enemy.position = SCNVector3Make(0, 2.0 , 60.0)
////        hero.position = SCNVector3Make(0, 5, 0)
////    }
//
//
//
//
//
//
//// MARK: Touches
//extension GameScene2 {
//    // Touch Began
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        for touch in touches {
//            let location = touch.location(in: self)
//
//            // التعامل مع الأزرار أو المناطق التفاعلية
//            switch true {
//            case joystickKnob?.frame.contains(touch.location(in: joystick!)) ?? false:
//                joystickAction = true
//            case jumpB?.contains(location) ?? false:
//                run(SKAction.playSoundFileNamed("jumb.wav", waitForCompletion: false))
//                print("Entered JumpingState")
//                self.player1StateMachine?.enter(JumpingState.self)
//            case attackA?.contains(location) ?? false:
//                isAttacking = true
//            default:
//                break
//            }
//        }
//    }
////
//    // Touch Moved
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let joystick = joystick else { return }
//        guard let joystickKnob = joystickKnob else { return }
//        
//        if !joystickAction { return }
//        
//        // Distance
//        for touch in touches {
//            let position = touch.location(in: joystick)
//            
//            let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
//            let angle = atan2(position.y, position.x)
//            
//            if knobRadius > length {
//                joystickKnob.position = position
//            } else {
//                joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
//            }
//        }
//    }
//    
//    // Touch End
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//            
//            let xJoystickCoordinate = touch.location(in: joystick!).x
//            let xLimit: CGFloat = 200.0
//            if xJoystickCoordinate > -xLimit && xJoystickCoordinate < xLimit {
//                resetKnobPosition()
//                
//            }
//            if attackA?.contains(location) == true {
//                run(SKAction.playSoundFileNamed("mew.wav", waitForCompletion: false))
//                isAttacking = false
//                bullet?.removeFromParent()
//                
//            }
//            
//        }
//    }
//}
//
//
//// MARK: Action
//extension GameScene2 {
//    func resetKnobPosition() {
//        let initialPoint = CGPoint(x: 0, y: 0)
//        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
//        moveBack.timingMode = .linear
//        joystickKnob?.run(moveBack)
//        joystickAction = false
//    }
//}
//
//// MARK: Game Loop
//extension GameScene2 {
//    override func update(_ currentTime: TimeInterval) {
//        let deltaTime = currentTime - previousTimeInterval
//        
//        previousTimeInterval = currentTime
//        //camera
//        cameraNode?.position.x = player1!.position.x
//        cameraNode?.position.y = player1!.position.y
//        
//        if let cameraY = cameraNode?.position.y {
//            timerLabel.position.y = cameraY - 300
//        } else {
//            timerLabel.removeFromParent()
//        }//            leaderboardButton?.position.x = (cameraNode?.position.x)! + 300
//        joystick?.position.y = (cameraNode?.position.y)! - 100
//        joystick?.position.x = (cameraNode?.position.x)! - 300
//        jumpB?.position.y = (cameraNode?.position.y)! - 140.524
//        jumpB?.position.x = (cameraNode?.position.x)! + 312
//        attackA?.position.y = (cameraNode?.position.y)! - 69
//        attackA?.position.x = (cameraNode?.position.x)! + 359.999
//        
//        
//        // Player movement
//        guard let joystickKnob = joystickKnob else { return }
//        let xPosition = Double(joystickKnob.position.x)
//        let positivePosition = xPosition < 0 ? -xPosition : xPosition
//        
//        if floor(positivePosition) != 0 {
//            player2StateMachine?.enter(WalkingState.self)
//            player1StateMachine?.enter(WalkingState.self)
//        } else {
//            player1StateMachine?.enter(IdleState.self)
//            player2StateMachine?.enter(IdleState.self)
//        }
//        let displacement = CGVector(dx: deltaTime * xPosition * playerSpeed, dy: 0)
//        let move = SKAction.move(by: displacement, duration: 0)
//        let faceAction : SKAction!
//        let movingRight = xPosition > 0
//        let movingLeft = xPosition < 0
//        if movingLeft && playerIsFacingRight {
//            playerIsFacingRight = false
//            let faceMovement = SKAction.scaleX(to: -1, duration: 0.0)
//            faceAction = SKAction.sequence([move, faceMovement])
//        }
//        else if movingRight && !playerIsFacingRight {
//            playerIsFacingRight = true
//            let faceMovement = SKAction.scaleX(to: 1, duration: 0.0)
//            faceAction = SKAction.sequence([move, faceMovement])
//        } else {
//            faceAction = move
//        }
//        player1?.run(faceAction)
//        player2?.run(faceAction)
//        
//        
//        //Baground parallax
//        
//
//        
//        let parallax4 = SKAction.moveTo(x: (cameraNode?.position.x)!, duration: 1.0)
//        sun?.run(parallax4)
//        
//        if isAttacking {
//            PlayerAcation.spawnBullet(in: self, fromPlayer: player1!, isFacingRight: playerIsFacingRight, imageName: "melon")
//        }
//        
//        
//    }
//}
//
//// MARK: Collision
//
//
//
//extension GameScene2 {
//    func didBegin(_ contact: SKPhysicsContact) {
//        let bodyA = contact.bodyA
//        let bodyB = contact.bodyB
//        let die = SKAction.move(to: CGPoint(x: -300,y: -100), duration: 0.0)
//        print (bodyA.categoryBitMask)
//        print (bodyB.categoryBitMask)
//        
//        // التحقق من تصادم اللاعب مع العدو
//        if (bodyA.categoryBitMask == PhysicsCatagory.player1 && bodyB.categoryBitMask == PhysicsCatagory.enemy) ||
//            (bodyA.categoryBitMask == PhysicsCatagory.enemy && bodyB.categoryBitMask == PhysicsCatagory.player1) {
//            player1?.run(die)
//        }
//        if (bodyA.categoryBitMask == PhysicsCatagory.player1 && bodyB.categoryBitMask == PhysicsCatagory.flag) ||
//            (bodyA.categoryBitMask == PhysicsCatagory.flag && bodyB.categoryBitMask == PhysicsCatagory.player1) {
//            run(SKAction.playSoundFileNamed("level-completed.wav", waitForCompletion: false))
//            let end = GameScene(fileNamed: "EndGame")
//            self.view?.presentScene(end)
//
//        }
//        
//        if (bodyA.categoryBitMask == PhysicsCatagory.enemy && bodyB.categoryBitMask == PhysicsCatagory.bullet) ||
//            (bodyA.categoryBitMask == PhysicsCatagory.bullet && bodyB.categoryBitMask == PhysicsCatagory.enemy) {
//            // تصادم بين العدو والرصاصة
//            run(SKAction.playSoundFileNamed("enmayheert.wav", waitForCompletion: false))
//            
//            if let enemyNode = bodyA.node as? SKSpriteNode, let bulletNode = bodyB.node as? SKSpriteNode {
//                // قم بإزالة العدو والرصاصة من اللعبة
//                enemyNode.removeFromParent()
//                bulletNode.removeFromParent()
//            }
//        }
//        
//    }
//    
//    
//}
//
//

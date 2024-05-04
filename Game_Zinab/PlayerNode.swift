////
////  shoot.swift
////  Game_Zinab
////
////  Created by Zinab Zooba on 23/10/1445 AH.

import Foundation
import SpriteKit

class PlayerAcation: SKSpriteNode {
    
    
    
    static func spawnBullet(in gameScene: GameScene, fromPlayer player: SKNode, isFacingRight: Bool, imageName: String) {
        let bullet = SKSpriteNode(imageNamed: imageName)
        bullet.zPosition = 1
        bullet.size = CGSize(width: 40.0, height: 40.0)
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.categoryBitMask = PhysicsCatagory.bullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCatagory.enemy
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.isDynamic = false

        if gameScene.isAttacking {
            bullet.position = CGPoint(x: player.position.x, y: player.position.y - 10)
            let actionMove: SKAction
            if isFacingRight {
                actionMove = SKAction.moveTo(x: player.position.x + 1000, duration: 2.0)
            } else {
                actionMove = SKAction.moveTo(x: gameScene.frame.minX - 1000, duration: 2.0)
            }
            let actionDone = SKAction.removeFromParent()
            bullet.run(SKAction.sequence([actionMove, actionDone]))
            gameScene.addChild(bullet)
        }
    }
//    static func spawnBullet(in gameScene: GameScene2, fromPlayer player: SKNode, isFacingRight: Bool, imageName: String) {
//        let bullet = SKSpriteNode(imageNamed: imageName)
//        bullet.zPosition = 1
//        bullet.size = CGSize(width: 40.0, height: 40.0)
//        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
//        bullet.physicsBody?.categoryBitMask = PhysicsCatagory.bullet
//        bullet.physicsBody?.contactTestBitMask = PhysicsCatagory.enemy
//        bullet.physicsBody?.affectedByGravity = false
//        bullet.physicsBody?.isDynamic = false
//        
//        if gameScene.isAttacking {
//            bullet.position = CGPoint(x: player.position.x, y: player.position.y - 10)
//            let actionMove: SKAction
//            if isFacingRight {
//                actionMove = SKAction.moveTo(x: player.position.x + 1000, duration: 2.0)
//            } else {
//                actionMove = SKAction.moveTo(x: gameScene.frame.minX - 1000, duration: 2.0)
//            }
//            let actionDone = SKAction.removeFromParent()
//            bullet.run(SKAction.sequence([actionMove, actionDone]))
//            gameScene.addChild(bullet)
//        }
//    }

   }

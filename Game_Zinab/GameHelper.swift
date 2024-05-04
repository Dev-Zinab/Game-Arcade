import SpriteKit

struct GameHelper {
    
    
    static func moveEnemyHorizontally(enemy: SKNode?, startX: CGFloat, endX: CGFloat, duration: TimeInterval) {
            guard let enemy = enemy else {
                print("Enemy node not found")
                return
            }
            
            let left = SKAction.moveTo(x: startX, duration: duration)
            let right = SKAction.moveTo(x: endX, duration: duration)
            let moveSequence = SKAction.sequence([left, right])
            enemy.run(SKAction.repeatForever(moveSequence))
        }
    
    static func moveEnemyVertically(enemy: SKNode?, startY: CGFloat, endY: CGFloat, duration: TimeInterval) {
        guard let enemy = enemy else {
            print("Enemy node not found")
            return
        }
       
  
        
        let up = SKAction.moveTo(y: startY, duration: duration)
        let down = SKAction.moveTo(y: endY, duration: duration)
        let moveSequence = SKAction.sequence([up, down])
        enemy.run(SKAction.repeatForever(moveSequence))
    }
    
    

    static func startTimer(in gameScene: GameScene, timeInterval: TimeInterval, updateSelector: Selector){
     gameScene.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: gameScene, selector: updateSelector, userInfo: nil, repeats: true)
   }
    
//    static func startTimer(in gameScene: GameScene2, timeInterval: TimeInterval, updateSelector: Selector){
//     gameScene.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: gameScene, selector: updateSelector, userInfo: nil, repeats: true)
//   }

    }
  
    
    


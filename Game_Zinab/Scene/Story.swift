//
//  File.swift
//  Game_Zinab
//
//  Created by Zinab Zooba on 16/11/1445 AH.
//

import SpriteKit
import AVKit

class Story: SKScene {

    var player: AVPlayer?

    override func didMove(to view: SKView) {
        // قم بإنشاء عقدة الفيديو
        if let videoNode = createVideoNode() {
            videoNode.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
            videoNode.size = self.size
            addChild(videoNode)
            
            // قم بتشغيل الفيديو
            videoNode.play()
            
            // مراقبة انتهاء الفيديو
            if let player = player {
                NotificationCenter.default.addObserver(self, selector: #selector(videoDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            }
        }
    }

    // دالة لإنشاء SKVideoNode
    func createVideoNode() -> SKVideoNode? {
        guard let url = Bundle.main.url(forResource: "storyf", withExtension: "mp4") else {
            print("فشل في العثور على ملف الفيديو")
            return nil
        }
        
        player = AVPlayer(url: url)
        let videoNode = SKVideoNode(avPlayer: player!)
        return videoNode
    }

    // دالة لمعالجة انتهاء الفيديو
    @objc func videoDidFinish() {
        transitionToNextScene()
    }

    // دالة للانتقال إلى المشهد التالي
    func transitionToNextScene() {
        if let view = self.view {
            let transition = SKTransition.fade(withDuration: 1.0) // تخصيص الانتقال
            if let nextScene = SKScene(fileNamed: "StartScene") {
                nextScene.scaleMode = .aspectFill
                view.presentScene(nextScene, transition: transition)
                print("تم الانتقال إلى المشهد التالي")
            } else {
                print("فشل في تحميل مشهد ")
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

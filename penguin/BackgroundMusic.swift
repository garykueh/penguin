//
//  BackgroundMusic.swift
//  penguin
//
//  Created by Gp on 7/16/22.
//

import AVFoundation

class BackgroundMusic: NSObject {
    // create the class as a singleton
    static let instance = BackgroundMusic()
    var musicPlayer = AVAudioPlayer()
    
    func playBackgroundMusic() {
        if let musicPath = Bundle.main.path(forResource:"Sound/BackgroundMusic.m4a", ofType: nil){
            let url = URL(fileURLWithPath: musicPath)
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer.numberOfLoops = -1
                musicPlayer.prepareToPlay()
                musicPlayer.play()
                UserDefaults.standard.set(false, forKey: "BackgroundMusicMuteState")

            }
            catch { // couldn't load music file
                print("File Not loaded")
            }
        }
        
        if isMuted() {
            pauseMusic()
         }
         
    }
    
    func pauseMusic() {
        UserDefaults.standard.set(true, forKey: "BackgroundMusicMuteState")
        musicPlayer.pause()
    }
    
    func playMusic() {
        UserDefaults.standard.set(false, forKey: "BackgroundMusicMuteState")
        musicPlayer.play()
    }
    // check mute state
    func isMuted() -> Bool {
        if UserDefaults.standard.bool(forKey: "BackgroundMusicMuteState") {
            print("mute true")
            return true
        } else {
            print("mute false")
            return false
        }
    }
    
    func setVolume(volume: Float) {
        musicPlayer.volume = volume
    }
}

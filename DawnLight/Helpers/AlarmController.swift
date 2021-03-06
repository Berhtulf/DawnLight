//
//  AlarmController.swift
//  DawnLight
//
//  Created by Martin Václavík on 06.02.2021.
//

import Foundation
import AVFoundation
import MediaPlayer

class AlarmController {
    private(set) var player: AVAudioPlayer?
    
    func createAVPlayer(sound resource : String) {
        do {
            guard let path = Bundle.main.path(forResource: resource, ofType: nil) else { return }
            let url = URL(fileURLWithPath: path)
            player = try AVAudioPlayer(contentsOf: url)
            
            try AVAudioSession.sharedInstance().setActive(false)
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            //Handle errors
            print("AVAudioSession error: \(error.localizedDescription)")
        }
    }
    
    func cancelAlarm(){
        player?.stop()
    }
    func stop(){
        player?.stop()
    }
    
    func playSample(_ alarm: Alarm, volume: Float) -> Void{
        createAVPlayer(sound: alarm.systemName)
        play(volume: volume)
    }
    
    func stopSample(){
        player?.stop()
    }
    
    func play(volume: Float) {
        guard let player = player else { return }
        
        player.volume = volume
        player.prepareToPlay()
        setDiviceVolumeTo(volume)
        player.play()
    }
    
    func play(volume: Float, after delay: TimeInterval) {
        guard let player = player else { return }
        
        player.volume = volume
        player.prepareToPlay()
        player.play(atTime: player.deviceCurrentTime + delay)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay - 10) {
            self.setDiviceVolumeTo(volume)
        }
    }
    
    private func setDiviceVolumeTo(_ volume: Float) {
        MPVolumeView.setVolume(volume)
    }
}


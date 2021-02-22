//
//  MPVolumeView.swift
//  DawnLight
//
//  Created by Martin Václavík on 03.02.2021.
//

import MediaPlayer

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        slider?.value = volume
    }
    
    static func getVolume() -> Float? {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        return slider?.value
    }
}

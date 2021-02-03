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
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            slider?.value = volume
        }
    }
}

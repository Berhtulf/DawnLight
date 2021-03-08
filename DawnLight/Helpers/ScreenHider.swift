//
//  ScreenHider.swift
//  DawnLight
//
//  Created by Martin Václavík on 07.03.2021.
//

import SwiftUI

class ScreenHider: ObservableObject {
    private var refreshTimer: Timer?
    @Published var isShowingBlackScreen = false
    var brightness: CGFloat = UIScreen.main.brightness
    var shouldShowBlackScreen = false
    
    func startScreenTimer(interval: TimeInterval = 10){
        shouldShowBlackScreen = true
        refreshTimer?.invalidate()
        refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { timer in
            if self.shouldShowBlackScreen {
                self.showBlackScreen()
            }else{
                self.hideBlackScreen()
            }
        }
    }
    
    func showBlackScreen(after delay: TimeInterval = 1) {
        brightness = UIScreen.main.brightness
        isShowingBlackScreen = true
        shouldShowBlackScreen = false
        refreshTimer?.invalidate()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay){
            UIScreen.main.brightness = CGFloat(0)
        }
    }
    func hideBlackScreen() {
        refreshTimer?.invalidate()
        UIScreen.main.brightness = CGFloat(brightness)
        isShowingBlackScreen = false
        shouldShowBlackScreen = false
    }
}

import StoreKit
import SwiftUI

class StoreReview {
    @AppStorage("ActionCount") var actionCount = 0
    @AppStorage("lastReviewRequestAppVersion") var lastVersion:String = ""
}

struct AppStoreReviewPrompt {
    // 1.
    static let minimumActionCount = 7
    
    static func requestReviewIfAppropriate() {
        let bundle = Bundle.main
        let storeReview = StoreReview()
        // 3.
        storeReview.actionCount += 1
        
        // 5.
        guard storeReview.actionCount >= minimumActionCount else { return }
        
        // 6.
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
        
        // 7.
        guard storeReview.lastVersion != currentVersion else { return }
        
        // 8.
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
        
        // 9.
        storeReview.actionCount = 0
        storeReview.lastVersion = currentVersion ?? ""
    }
}

//
//  LoadingView.swift
//  DawnLight
//
//  Created by Martin Václavík on 09.02.2021.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20){
            ProgressView()
                .scaleEffect(2)
            Text("Loading...")
        }
    }
}

//
//  CapsuleButtonStyle.swift
//  DawnLight
//
//  Created by Martin Václavík on 18.01.2021.
//

import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
    @State var foregroundColor: Color = .white
    @State var color: Color = .accentColor
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .padding(.horizontal)
            .foregroundColor(foregroundColor)
            .background(color)
            .cornerRadius(40)
            .opacity(configuration.isPressed ? 0.6 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

struct CapsuleButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}, label: {
            Text("Button")
        }).buttonStyle(CapsuleButtonStyle())
    }
}

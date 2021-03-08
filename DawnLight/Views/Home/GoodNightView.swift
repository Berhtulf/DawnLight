//
//  GoodNightView.swift
//  DawnLight
//
//  Created by Martin Václavík on 27.02.2021.
//

import SwiftUI


struct GoodNightView: View {
    @EnvironmentObject var model: HomeViewModel
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Text("Good Night!")
                    .font(.largeTitle)
                    .padding()
                Text("Alarm set to \(model.buzzTime)")
                    .font(.subheadline)
                Spacer()
                Button("Cancel", action: model.cancelAlarm)
                .font(.system(size: 25))
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(LinearGradient(
                                gradient: Gradient(stops: [
                                                    .init(color: Color(#colorLiteral(red: 1, green: 0.2705882489681244, blue: 0.22745098173618317, alpha: 1)), location: 0),
                                                    .init(color: Color(#colorLiteral(red: 1, green: 0.6235294342041016, blue: 0.03921568766236305, alpha: 1)), location: 1)]),
                                startPoint: UnitPoint(x: 0, y: 0),
                                endPoint: UnitPoint(x: 1, y: 1)))
                        .frame(width: 222, height: 63)
                )
                .offset(y: -31.5)
            }
            Image("BackgroundImage")
                .resizable()
                .scaledToFit()
                .opacity(0.3)
        }
    }
}


struct GoodNightView_Previews: PreviewProvider {
    static var previews: some View {
        GoodNightView()
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
    }
}

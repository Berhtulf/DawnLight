//
//  KeepOnWarningView.swift
//  DawnLight
//
//  Created by Martin Václavík on 11.03.2021.
//

import SwiftUI

struct KeepOnWarningView: View {
    @EnvironmentObject var model: HomeViewModel
    var body: some View {
        VStack{
            Spacer()
            VStack{
                Text("Do not close the application \nKeep the charger connected")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
                HStack{
                    Button(action: {
                        model.canShowKeepOnWarning = false
                        model.isShowingKeepOnWarnig = false
                    }, label: {
                        Text("dont show again")
                            .fontWeight(.medium)
                            .padding()
                    })
                    Spacer()
                    Button(action: {
                        model.isShowingKeepOnWarnig = false
                    }, label: {
                        Text("OK")
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
                                    .frame(width: 100, height: 50)
                            )
                            .frame(width: 100, height: 50)
                    })
                }
                .padding(.horizontal)
            }
            .frame(height: 175)
            .padding()
            .background(Color.black)
            .cornerRadius(20)
            .shadow(color: Color.white.opacity(0.1), radius: 15, x: 0.0, y: -20.0)
        }
    }
}

struct KeepOnWarningView_Previews: PreviewProvider {
    static var previews: some View {
        GoodNightView()
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
    }
}

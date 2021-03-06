//
//  AllowLocationSettingsView.swift
//  DawnLight
//
//  Created by Martin Václavík on 02.03.2021.
//

import SwiftUI

struct AllowLocationSettingsView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack{
            Text("Update privacy settings")
                .foregroundColor(.accentColor)
                .font(.title2)
                .fontWeight(.bold)
                .padding()
            VStack(alignment: .center){
                Text("Your privacy settings are not allowing us to use your current location. Please enter Settings and grant us Permissions to your Location.")
                    .padding(.bottom)
                Text("Dont worry, your location is only used to get tommorows sunrise time and is not saved anywhere.")
                    .font(.subheadline)
            }.padding()
            
            HStack{
                Button(action: {
                    isPresented = false
                }, label: {
                    Text("Cancel")
                        .fontWeight(.bold)
                }).padding()
                Spacer()
                Button(action: goToAppSettings, label: {
                    Text("Go to Settings")
                        .fontWeight(.bold)
                }).padding()
                .buttonStyle(CapsuleButtonStyle())
            }
        }.background(Color(UIColor.systemBackground))
        .cornerRadius(30.0, antialiased: true)
        .padding(.vertical)
        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0.0, y: 0.0)
    }
    
    private func goToAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
}

struct AllowLocationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
            AllowLocationSettingsView(isPresented: .constant(true))
                .preferredColorScheme(.dark)
                .accentColor(.orange)
    }
}

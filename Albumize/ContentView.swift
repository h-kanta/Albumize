//
//  ContentView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/19.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    var body: some View {
        if let user = Auth.auth().currentUser {
            if user.isEmailVerified {
                MainView(userData: .init() ,photoData: .init(), albumData: .init(), photoPicker: .init())
            } else {
                StartUpView()
            }
        } else {
            StartUpView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
        ContentView()
    }
}


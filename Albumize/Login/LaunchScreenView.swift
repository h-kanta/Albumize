//
//  LaunchScreenView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/08/01.
//

import SwiftUI
import FirebaseAuth

// 起動時表示
struct LaunchScreenView: View {
    @State private var isLoading = true
//    @State var noUserIsActive
    
    var body: some View {
        if isLoading {
            ZStack {
                Color("Primary")
                    .ignoresSafeArea()
                
                Text("Albumize")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        } else {
//            Auth.auth().addStateDidChangeListener { auth, user in
//                if user != nil {
//                    LaunchScreenView()
//                } else {
//                    ContentView()
//                }
//            }
            if Auth.auth().currentUser != nil {
                ContentView()
            } else {
                LoginAuthView()
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}

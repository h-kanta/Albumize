//
//  UserView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/20.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack{
                    Button {
                        do {
                            try Auth.auth().signOut()
                            isPresented = true
                        } catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)
                        }
                    } label: {
                        Text("LogOut")
                    }
                }
            }
            // ナビゲーションリンクの戻るボタンを非表示
            .navigationBarBackButtonHidden(true)
            // ログアウト時はログイン画面へ遷移する
            .fullScreenCover(isPresented: $isPresented) {
                LoginAuthView()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

//
//  UserView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/20.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct ProfileView: View {
    
    init() {
        UITableView.appearance().isScrollEnabled = false
    }
    
    // 認証マネージャー
    @State var authManager: AuthManager = AuthManager()
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack {
                    Image("DefaultProfile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Capsule())
                        .overlay {
                            Circle()
                                .stroke(.black, style: StrokeStyle(lineWidth: 3))
                        }
                        .padding()
                    
                    Text("アカウント名")
                        .font(.title3)
                    
                    List {
                        Section(header:Text("グループ")) {
                            Text("要素1")
                            Text("要素2")
                            Text("要素3")
                        }
                        
                        Section(header:Text("グループ")) {
                            Text("要素1")
                            Text("要素2")
                            Text("要素3")
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color("Bg"))
                    
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
            
            // ログアウト時はログイン画面へ遷移する
            .fullScreenCover(isPresented: $isPresented) {
                StartUpView()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
//        ContentView()
    }
}

//
//  UserView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/20.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct ProfileView: View {
    
//    init() {
//        UITableView.appearance().isScrollEnabled = false
//    }
    
    //@State var userData: UserViewModel
    // 認証マネージャー
    @State var authManager: AuthManager = AuthManager()
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack {
                    Image("DefaultProfileImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Capsule())
                        .overlay {
                            Circle()
                                .stroke(.black, style: StrokeStyle(lineWidth: 1))
                        }
                        .padding(.top)
                    
                    Text("アカウント名")
                        .font(.title3)
                    
                    Divider()
                    
                    List {
                        Section(header:Text("アカウント")) {
                            Text("ユーザーID")
                            Text("アカウント編集")
                        }
                        
                        Section(header:Text("グループ")) {
                            Text("グループ名")
                            Text("グループ一覧")
                            Text("グループに招待")
                            Text("グループから脱退")
                        }
                        
                        Section(header:Text("")) {
                            // ログアウト
                            Button {
                                do {
                                    try Auth.auth().signOut()
                                    isPresented = true
                                } catch let signOutError as NSError {
                                    print("Error signing out: %@", signOutError)
                                }
                            } label: {
                                Text("ログアウト")
                            }
                            
                            // 退会
                            Text("退会")
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color("Bg"))
                
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
        //@State var userData: UserViewModel
        ProfileView()
//        ContentView()
    }
}

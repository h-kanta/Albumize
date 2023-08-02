//
//  LoginAuthView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/08/01.
//

import SwiftUI
import FirebaseAuth

// ログイン画面
struct LoginAuthView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var isPresented: Bool = false
    // 認証マネージャー
    @State var authManager = AuthManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack {
                    Text("Albumize")
                        .font(.largeTitle)
                        .foregroundColor(Color("Primary"))
                        .padding(50)
                    
                    VStack(spacing: 30) {
                        Text("ログイン")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // 入力フィールド
                        VStack(spacing: 20) {
                            TextFieldView(title: "メールアドレス", text: $email)
                            SecureFieldView(title: "パスワード", text: $password)
                        }
                        
                        // MARK: ログイン
                        Button {
                            authManager.Login(email: email, password: password) { result in
                                if result {
                                    isPresented = true
                                } else {
                                    
                                }
                            }
                        } label: {
                            Text("ログイン")
                                .padding()
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .background(Color("Primary"))
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.10), radius: 5, x: 3, y: 3)
                        }
                        
                        // ログイン画面へ
                        NavigationLink {
                            EntryAuthView()
                        } label: {
                            Text("未登録の方はこちら")
                                .padding()
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .background(Color("Sub"))
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.10), radius: 5, x: 3, y: 3)
                                .padding(.top)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            // ナビゲーションリンクの戻るボタンを非表示
            .navigationBarBackButtonHidden(true)
            // ログインが完了した場合はメイン画面へ遷移
//            .navigationDestination(isPresented: $isPresented) {
//                ContentView()
//            }
            .fullScreenCover(isPresented: $isPresented) {
                ContentView()
            }
        }
    }
}

struct LoginAuthView_Previews: PreviewProvider {
    static var previews: some View {
        LoginAuthView()
    }
}

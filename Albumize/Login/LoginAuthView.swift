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
    @State var authManager: AuthManager = AuthManager()
    // エラーメッセージ
    @State var errMessage: String = ""
    
    @Binding var loginAuthIsPresented: Bool
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack {
                    if errMessage != "" {
                        Text(errMessage)
                            .font(.title3)
                            .foregroundColor(.red)
                            .padding(.vertical)
                    }
                    
                    VStack(spacing: 40) {
                        // 入力フィールド
                        VStack(spacing: 20) {
                            TextFieldView(title: "メールアドレス", text: $email)
                            SecureFieldView(title: "パスワード", text: $password)
                        }
                        
                        // MARK: ログイン
                        Button {
                            // ローディング表示
                            withAnimation {
                                isLoading = true
                            }
                            // エラーメッセージ初期化
                            errMessage = ""
                            authManager.Login(email: email, password: password) { result in
                                if result {
                                    isPresented = true
                                } else {
                                   isLoading = false
                                   errMessage = authManager.errMessage
                                }
                            }
                        } label: {
                            ButtonView(text: "ログイン", color: Color("Primary"))
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                
                // ローディング
                if isLoading {
                    ProgressView("Loading...")
                }
            }
            .navigationBarTitle("ログイン", displayMode: .inline)
            
            // ばつ
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .onTapGesture {
                            loginAuthIsPresented = false
                        }
                }
            }
            
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
        @State var loginAuthIsPresented = true
        LoginAuthView(loginAuthIsPresented: $loginAuthIsPresented)
    }
}

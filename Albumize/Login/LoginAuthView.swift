//
//  LoginAuthView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/08/01.
//

import SwiftUI
import FirebaseAuth
import KRProgressHUD

// ログイン画面
struct LoginAuthView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var nextPageActive: Bool = false
    // 認証マネージャー
    @State var authManager: AuthManager = AuthManager()
    // エラーメッセージ
    @State var errMessage: String = ""
    
    @Binding var loginAuthIsPresented: Bool
    @State var isShowingAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景色
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 40) {
                        // 入力フィールド
                        VStack(spacing: 20) {
                            TextFieldView(title: "メールアドレス", text: $email, disabled: false)
                            SecureFieldView(title: "パスワード", text: $password)
                        }
                        
                        // MARK: ログイン
                        Button {
                            // ローディング表示
                            withAnimation {
                                KRProgressHUD.show(withMessage: "読み込み中...")
                            }
                            // ログインする
                            authManager.Login(email: email, password: password) { loginResult in
                                if loginResult {
                                    // 認証完了済みかどうか
                                    authManager.isRegistrationComplete { authResult in
                                        if authResult {
                                            nextPageActive = true
                                        } else {
                                            KRProgressHUD.dismiss()
                                            errMessage = "メール認証がまだ完了していません。\n認証リンクがメールボックスに届いているか確認してください。"
                                            isShowingAlert = true
                                        }
                                    }
                                } else {
                                   KRProgressHUD.dismiss()
                                   errMessage = authManager.errMessage
                                   isShowingAlert = true
                                }
                            }
                        } label: {
                            ButtonView(text: "ログイン", color: Color("Primary"))
                        }
                    }
                    
                    Spacer()
                }
                .padding()
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
            // アラート（エラーメッセージ）表示
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text(errMessage))
            }
            // メイン画面に遷移
            .fullScreenCover(isPresented: $nextPageActive) {
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

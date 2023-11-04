//
//  EntryAuthView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/30.
//

import SwiftUI
import KRProgressHUD

// メールアドレス、パスワード入力画面
struct EntryAuthView: View {
    // 新規登録画面表示フラグ
    @Binding var entryAuthIsPresented: Bool
    
    // メールアドレス
    @State var email: String = ""
    // パスワード
    @State var password: String = ""
    // 認証マネージャー
    @State var authManager = AuthManager()
    // エラーメッセージ
    @State var errMessage: String = ""
    // アラート表示フラグ
    @State var showingAlert: Bool = false
    // 次の画面遷移フラグ
    @State var nextPageActive: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景色
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack {
                    VStack {
                        VStack(spacing: 40) {
                            VStack(alignment: .leading) {
                                Text("メールアドレスを入力してください。")
                                TextFieldView(title: "メールアドレス", text: $email, disabled: false)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("パスワードを入力してください。")
                                SecureFieldView(title: "パスワード", text: $password)
                            }
                        }
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.vertical)
                        
                        Spacer()
                        
                        // MARK: メールアドレス、パスワード設定
                        if email == "" || password == "" {
                            Text("次へ")
                                .padding()
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .background(.black.opacity(0.4))
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.10), radius: 5, x: 3, y: 3)
                        } else {
                            Button {
                                //ローディング表示
                                withAnimation {
                                    KRProgressHUD.show(withMessage: "読み込み中...")
                                }
                                //エラーメッセージ初期化
                                errMessage = ""
                                authManager.createUser(email: email, password: password) { result in
                                    if result {
                                        if authManager.auth.currentUser != nil {
                                            KRProgressHUD.dismiss()
                                            nextPageActive = true
                                        }
                                    } else {
                                        KRProgressHUD.dismiss()
                                        errMessage = authManager.errMessage
                                        showingAlert = true
                                    }
                                }
                            } label: {
                                ButtonView(text: "次へ", color: Color("Sub"))
                            }
                        }
                    }
                }
                .padding()
            }
//            .navigationBarTitle("新規登録", displayMode: .inline)
            
            // 閉じるボタン
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .onTapGesture {
                            entryAuthIsPresented = false
                        }
                }
            }
            // アラート（エラーメッセージ）表示
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(errMessage))
            }
            // 次の画面へ
            .navigationDestination(isPresented: $nextPageActive){
                EntryAuthConfirmView(email: $email)
            }
        }
    }
}

struct EntryAuthView_Previews: PreviewProvider {
    static var previews: some View {
        @State var entryAuthIsPresented: Bool = true
        EntryAuthView(entryAuthIsPresented: $entryAuthIsPresented)
    }
}

// 入力テキストフィールド
struct TextFieldView: View {
    var title: String
    @Binding var text: String
    var disabled: Bool
    
    var body: some View {
        if disabled {
            TextField(title, text: $text)
                .font(.title2)
                .padding(10)
                .background(.black.opacity(0.2))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.10), radius: 5, x: 3, y: 3)
                .autocapitalization(.none)
                .disabled(disabled)
        } else {
            TextField(title, text: $text)
                .font(.title2)
                .padding(10)
                .background(.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.10), radius: 5, x: 3, y: 3)
                .autocapitalization(.none)
                .disabled(disabled)
        }
    }
}

// 入力パスワードフィールド
struct SecureFieldView: View {
    // テキストフィールド
    @FocusState var focusText: Bool
    // セキュリティフィールド
    @FocusState var focusSecure: Bool
    // 表示/非表示切り替えフラグ
    @State  var show: Bool = false
    
    var title: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            ZStack(alignment: .trailing) {
                TextField(title, text: $text)
                    .focused($focusText)
                    .opacity(show ? 1 : 0)
                    .autocapitalization(.none)
                
                SecureField(title, text: $text)
                    .focused($focusSecure)
                    .opacity(show ? 0 : 1)
                    .autocapitalization(.none)
                
                Image(systemName: self.show ? "eye.slash.fill" : "eye.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .onTapGesture {
                        show.toggle()
                        if show {
                            focusText = true
                        } else {
                            focusSecure = true
                        }
                    }
            }
            .font(.title2)
            .padding(10)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.10), radius: 5, x: 3, y: 3)
        }
    }
}

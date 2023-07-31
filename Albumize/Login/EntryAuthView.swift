//
//  EntryAuthView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/30.
//

import SwiftUI
import FirebaseAuth

struct EntryAuthView: View {
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        ZStack {
            Color("Bg")
                .ignoresSafeArea()
            
            VStack {
                Text("Albumize")
                    .font(.largeTitle)
                    .foregroundColor(Color("Primary"))
                    .padding(50)
                
                VStack(spacing: 30) {
                    Text("アカウントを作成")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // 入力フィールド
                    VStack(spacing: 20) {
                        TextFieldView(title: "アカウント名", text: $name)
                        TextFieldView(title: "メールアドレス", text: $email)
                        SecureFieldView(title: "パスワード", text: $password)
                    }
                    
                    // 登録ボタン
                    Button {
                        // createUser: ユーザーを作成する処理
                        // 引数には登録するメールアドレスとパスワードを渡す
                        Auth.auth().createUser(withEmail: email, password: password) { result, error in
                            // result の中に user が格納されていれば登録成功
                            if let user = result?.user {
                                // ユーザー情報を編集（リクエストを構築）
                                let request = user.createProfileChangeRequest()
                                // 名前を設定
                                request.displayName = name
                                // 実際にリクエストを反映する（リクエストを実行）
                                request.commitChanges { error in
                                    // 編集成功
                                    if error == nil {
                                        // 確認メール送信
                                        user.sendEmailVerification() { error in
                                            if error == nil {
                                                print("仮登録画面へ")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("新規登録")
                            .padding()
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color("Primary"))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.10), radius: 5, x: 3, y: 3)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

struct EntryAuthView_Previews: PreviewProvider {
    static var previews: some View {
        EntryAuthView()
    }
}

// 入力テキストフィールド
struct TextFieldView: View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        TextField(title, text: $text)
            .padding()
            .background(.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.10), radius: 5, x: 3, y: 3)
            .autocapitalization(.none)
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
                    .font(.system(size: 17))
                    .foregroundColor(Color("Primary"))
                    .onTapGesture {
                        show.toggle()
                        if show {
                            focusText = true
                        } else {
                            focusSecure = true
                        }
                    }
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.10), radius: 5, x: 3, y: 3)
        }
    }
}

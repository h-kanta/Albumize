//
//  EntryAuthView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/30.
//

import SwiftUI
import FirebaseAuth

// 新規登録画面
struct EntryAuthView: View {
    @State var name: String = ""
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
                        Text("アカウント作成")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // 入力フィールド
                        VStack(spacing: 20) {
                            TextFieldView(title: "アカウント名", text: $name)
                            TextFieldView(title: "メールアドレス", text: $email)
                            SecureFieldView(title: "パスワード", text: $password)
                        }
                        
                        // MARK: アカウント登録
                        Button {
                            authManager.createUser(email: email, password: password, name: name)  { result in
                                if result {
                                    isPresented = true
                                } else {
                                    
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
                        
                        // 新規登録画面へ
                        NavigationLink {
                            LoginAuthView()
                        } label: {
                            Text("登録済みの方はこちら")
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
            // 新規登録が完了した場合はメイン画面へ遷移
//            .navigationDestination(isPresented: $isPresented) {
//                ContentView()
//            }
            .fullScreenCover(isPresented: $isPresented) {
                ContentView()
            }
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
            .padding(15)
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
            .padding(15)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.10), radius: 5, x: 3, y: 3)
        }
    }
}

//
//  EntryAuthView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/30.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

// 新規登録画面
struct EntryAuthView: View {
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var isPresented: Bool = false
    // 認証マネージャー
    @State var authManager = AuthManager()
    // エラーメッセージ
    @State var errMessage: String = ""
    
    @Binding var entryAuthIsPresented: Bool
    @State var isLoading: Bool = false
    @State var showingAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 40) {
                        // 入力フィールド
                        VStack(spacing: 20) {
                            TextFieldView(title: "アカウント名", text: $name)
                            TextFieldView(title: "メールアドレス", text: $email)
                            SecureFieldView(title: "パスワード", text: $password)
                        }
                        
                        // MARK: アカウント登録
                        Button {
                            // ローディング表示
                            withAnimation {
                                isLoading = true
                            }
                            // エラーメッセージ初期化
                            errMessage = ""
                            authManager.createUser(email: email, password: password, name: name)  { result in
                                if result {
                                    isPresented = true
                                } else {
                                    isLoading = false
                                    errMessage = authManager.errMessage
                                    showingAlert = true
                                }
                            }
                        } label: {
                            ButtonView(text: "新規登録", color: Color("Sub"))
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
            .navigationBarTitle("新規登録", displayMode: .inline)
            
            // ばつ
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
            // メイン画面に遷移
            .fullScreenCover(isPresented: $isPresented) {
                ContentView()
            }
        }
    }
}

struct EntryAuthView_Previews: PreviewProvider {
    static var previews: some View {
        @State var entryAuthIsPresented = true
        EntryAuthView(entryAuthIsPresented: $entryAuthIsPresented)
    }
}

// 入力テキストフィールド
struct TextFieldView: View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        TextField(title, text: $text)
            .font(.title2)
            .padding(10)
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

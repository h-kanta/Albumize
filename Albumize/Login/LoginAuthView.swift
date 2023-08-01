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
                        Text("アカウントを作成")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // 入力フィールド
                        VStack(spacing: 20) {
                            TextFieldView(title: "メールアドレス", text: $email)
                            SecureFieldView(title: "パスワード", text: $password)
                        }
                        
                        // ログインボタン
                        Button {
                            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                                if let user = result?.user {
                                    print(user)
                                    isPresented = true
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
                        
                        // 新規登録画面へ
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

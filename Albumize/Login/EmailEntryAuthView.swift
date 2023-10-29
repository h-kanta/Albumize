//
//  EmailEntryAuthView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/09/01.
//

import SwiftUI
import FirebaseAuth

struct EmailEntryAuthView: View {
    @Environment(\.dismiss) var dismiss
    // 認証マネージャー
    @State var authManager = AuthManager()
    @State var email: String = ""
    @State var password: String = ""
    // エラーメッセージ
    @State var errMessage: String = ""
    @State var showingAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 40) {
                    VStack(alignment: .leading) {
                        Text("メールアドレスを入力してください。")
//                        TextFieldView(title: "メールアドレス", text: $email, di)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("パスワードを設定してください。")
                        SecureFieldView(title: "パスワード", text: $password)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("パスワードをもう一度入力してください。")
                        SecureFieldView(title: "パスワード(確認)", text: $password)
                    }
                }
                .foregroundColor(.black.opacity(0.6))
                .padding(.vertical)
                
                Spacer()
                
                // MARK: アカウント登録
                Button {
                    
                } label: {
                    ButtonView(text: "次へ", color: Color("Sub"))
                }
            }
            
            // ばつ
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            
            // アラート（エラーメッセージ）表示
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(errMessage))
            }
        }
        .padding(.horizontal)
    }
}

struct EmailEntryAuthView_Previews: PreviewProvider {
    static var previews: some View {
        EmailEntryAuthView()
    }
}

// デフォルトのプロフィール画像をStorageに格納
//if let userId = authManager.auth.currentUser?.uid {
//    let profilePath = "profile/\(userId)/profile.png"
//    storageManager.saveStorage(image: "DefaultProfile", path: profilePath) { result in
//        if result {
//            // ユーザー情報をFirestoreへ保存
//            firestoreManager.saveUserData(userId: userId, userName: name, email: email, imageURL: profilePath)
//
////                                              isPresented = true
//        }
//    }
//}

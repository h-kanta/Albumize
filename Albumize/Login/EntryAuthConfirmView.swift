//
//  EntryAuthConfirmView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/09/01.
//

import SwiftUI

// アカウント認証完了画面
struct EntryAuthConfirmView: View {
    @Environment(\.dismiss) var dismiss
    // メールアドレス
    @Binding var email: String
    
    // 認証マネージャー
    @State var authManager = AuthManager()
    // エラーメッセージ
    @State var errMessage: String = ""
    // 認証完了済みフラグ
    @State var isRegistrationComplete: Bool = false
    // アラート表示フラグ
    @State var isShowingAlert: Bool = false
    // 次の画面遷移フラグ
    @State var nextPageActive: Bool = false
    // 認証完了フラグ
    @State var isEmailVerified: Bool = false
    // タイマー
    @State var timer: Timer?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景色
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("認証メールを送信しました。")
                        Text("認証メールが届きましたら、アカウントを有効化するために、リンクをクリックし認証を完了させてください。")
                    }
                    .padding()
                    
                    Spacer()
                    
                    // MARK: 認証が完了していれば次へボタンが活性化
                    if isEmailVerified {
                        Button {
                            nextPageActive = true
                        } label: {
                            ButtonView(text: "次へ", color: Color("Sub"))
                        }
                    } else {
                        Text("次へ")
                            .padding()
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(.black.opacity(0.4))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.10), radius: 5, x: 3, y: 3)
                    }
                }
                .padding(.horizontal)
            }
            // 戻るボタン
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            // NavigationLink の戻るボタンを非表示
            .navigationBarBackButtonHidden(true)
            // 次の画面へ遷移
            .navigationDestination(isPresented: $nextPageActive){
                EntryProfileInfoView(email: $email)
            }
            // アラート（エラーメッセージ）表示
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text(errMessage))
            }
        }
        .onAppear {
            // タイマーを開始
            startTimer()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            if let currentUser = authManager.auth.currentUser {
                currentUser.reload { error in
                    if error == nil {
                        if currentUser.isEmailVerified {
                            withAnimation {
                                isEmailVerified = true
                            }
                            print("認証完了")
                            timer?.invalidate() // タイマーを停止
                        }
                    }
                }
            }
            print("認証確認中")
        }
    }
}

struct EntryAuthConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        @State var email: String = "uta082812@gmail.com"
        EntryAuthConfirmView(email: $email)
    }
}

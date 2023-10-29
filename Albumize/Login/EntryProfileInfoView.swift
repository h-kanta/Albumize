//
//  EntryProfileInfoView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/09/02.
//

import SwiftUI

// プロフィール情報入力画面
struct EntryProfileInfoView: View {
    @Environment(\.dismiss) var dismiss
    // メールアドレス
    @Binding var email: String
    // 認証マネージャー
    @State var authManager = AuthManager()
    // ユーザー情報
    @State var user: UserViewModel = .init()
    // ユーザ名
    @State var name: String = ""
    // 性別選択
    @State private var selectedGenderValue = ""
    let gender = ["男性", "女性"]
    // 生年月日
    @State var birthday: String = ""
    // 生年月日ピッカー表示フラグ
    @State var isShowingPickerDialog = false
    // 利用規約同意チェックフラグ
    @State var hasAgreedToTermsAndPrivacy: Bool = false
    // グループId
    @State var groupId: String = ""
    // エラーメッセージ
    @State var errMessage: String = ""
    // アラート表示フラグ
    @State var isShowingAlert: Bool = false
    // 次の画面遷移フラグ
    @State var nextPageActive: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景色
                Color("Bg")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        VStack(spacing: 25) {
                            // 名前入力
                            VStack(alignment: .leading) {
                                Text("名前")
                                TextFieldView(title: "名前を入力", text: $name, disabled: false)
                            }
                            
                            // 性別入力
                            VStack(alignment: .leading) {
                                Text("性別")
                                Picker("", selection: $selectedGenderValue) {
                                    ForEach(gender, id: \.self) { item in
                                        Text(item)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            
                            // 生年月日入力
                            VStack(alignment: .leading) {
                                Text("生年月日")
                                Text(birthday.isEmpty ? "yyyy年mm月dd日" : birthday)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title2)
                                    .foregroundColor(birthday.isEmpty ? .black.opacity(0.5) : .black)
                                    .padding(10)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.10), radius: 5, x: 3, y: 3)
                                    .onTapGesture {
                                        isShowingPickerDialog = true
                                    }
                            }
                            
                            // メールアドレス入力
                            VStack(alignment: .leading) {
                                Text("メールアドレス")
                                TextFieldView(title: "メールアドレスを入力", text: $email, disabled: true)
                            }
                            
                            // グループID入力
                            VStack(alignment: .leading) {
                                Text("グループID")
                                Text("※グループに所属したい場合は、そのグループのIDを入力してください。").font(.caption)
                                TextFieldView(title: "グループIDを入力", text: $groupId, disabled: false)
                            }
                            
                            // 利用規約
                            HStack {
                                Image(systemName: hasAgreedToTermsAndPrivacy
                                      ? "checkmark.square.fill"
                                      : "square")
                                .font(.title)
                                Text("利用規約とプライバシーポリシーに同意")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture {
                                hasAgreedToTermsAndPrivacy.toggle()
                            }
                        }
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.vertical)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                Button {
                    // プロフィール情報入力チェック
                    errMessage = isValidProfileData(name: name,
                                                    email: email,
                                                    sex: selectedGenderValue,
                                                    birth: birthday,
                                                    hasAgreedToTermsAndPrivacy: hasAgreedToTermsAndPrivacy
                    )
                    
                    // 入力OKの場合は登録完了
                    // 入力NGの場合はエラーメッセージ表示
                    if errMessage.isEmpty {
                        print("登録完了")
                        
                        // MARK: ユーザー情報登録
                        if let userId = authManager.auth.currentUser?.uid {
                            // Storage プロフィール画像URL
                            let profileImageUrl = "profile/\(userId)/profile.png"
                            // デフォルトのユーザ画像をFirebaseStorageに登録
                            user.saveProfileImage(userId: userId,
                                                  profileImageurl: profileImageUrl) { result in
                                if result {
                                    // 入力したユーザ情報をFirestoreに登録
                                    user.saveUserData(userId: userId,
                                                      userName: name,
                                                      gender: selectedGenderValue,
                                                      birthday: birthday,
                                                      email: email,
                                                      profileImageUrl: profileImageUrl,
                                                      isInGroup: groupId.isEmpty ? false : true
                                    )
                                    
                                    nextPageActive = true
                                }
                            }
                        }
                    } else {
                        isShowingAlert = true
                    }
                } label: {
                    ButtonView(text: "アカウントを登録", color: Color("Sub"))
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
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
            // ナビゲーションリンクの戻るボタンを非表示
            .navigationBarBackButtonHidden(true)
            // 生年月日入力ダイアログ表示
            .sheet(isPresented: $isShowingPickerDialog) {
                BirthDayPickerView(birth: $birthday, isShowingPickerDialog: $isShowingPickerDialog)
            }
            // 登録完了で
            .fullScreenCover(isPresented: $nextPageActive) {
                ContentView()
            }
            // アラート（エラーメッセージ）表示
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text(errMessage))
            }
        }
    }
}

// プロフィール情報入力チェック
func isValidProfileData(name: String, email: String, sex: String, birth: String, hasAgreedToTermsAndPrivacy: Bool) -> String {
    var errMessage: String = ""
    // 名前入力チェック
    if name.isEmpty {
        errMessage = "名前を入力してください。"
        return errMessage
    }
    // メールアドレス入力チェック
    if email.isEmpty {
        errMessage = "メールアドレスを入力してください。"
        return errMessage
    }
    // 性別選択チェック
    if sex.isEmpty {
        errMessage = "性別を選択してください。"
        return errMessage
    }
    // 生年月日入力チェック
    if birth.isEmpty {
        errMessage = "生年月日を入力してください。"
        return errMessage
    }
    // 利用規約とプライバシーポリシー同意チェック
    if !hasAgreedToTermsAndPrivacy {
        errMessage = "利用規約とプライバシーポリシーに同意してください。"
        return errMessage
    }
    
    return errMessage
}

struct EntryProfileInfoView_Previews: PreviewProvider {
    static var previews: some View {
//        StartUpView()
        @State var email: String = "uta082812@gmail.com"
        EntryProfileInfoView(email: $email)
    }
}

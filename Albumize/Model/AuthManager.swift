//
//  AuthManager.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/08/02.
//

import FirebaseAuth

// 認証マネージャー
final class AuthManager {
    static let shared = AuthManager()
    let auth = Auth.auth()
    var errMessage: String = ""
    
    // MARK: ログイン済みか
    func isLogined(id: String, complition: @escaping (Bool) -> Void) {
        if let userId = auth.currentUser?.uid {
            print(userId)
            complition(true)
        } else {
            complition(false)
        }
    }
    
    // MARK: ログイン with email/password
    func Login(email: String, password: String, complition: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if error == nil {
                if result?.user != nil {
                    complition(true)
                } else {
                    complition(false)
                }
            } else {
                self.setErrorMessage(error)
                complition(false)
            }
        }
    }
    
    // MARK: 新規登録
    func createUser(email: String, password: String, name: String, complition: @escaping (Bool) -> Void) {
        // createUser: ユーザーを作成する処理
        // 引数には登録するメールアドレスとパスワードを渡す
        auth.createUser(withEmail: email, password: password) { result, error in
            if error == nil {
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
                                    complition(true)
                                } else {
                                    self.setErrorMessage(error)
                                    complition(false)
                                }
                            }
                        } else {
                            self.setErrorMessage(error)
                            complition(false)
                        }
                    }
                }
            } else {
                self.setErrorMessage(error)
                complition(false)
            }
        }
    }
    
    func setErrorMessage(_ error: Error?) {
        if let error = error as NSError? {
            if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case .invalidEmail:
                    self.errMessage = "メールアドレスの形式が違います。"
                case .emailAlreadyInUse:
                    self.errMessage = "このメールアドレスはすでに使われています。"
                case .weakPassword:
                    self.errMessage = "パスワードが弱すぎます。"
                case .userNotFound, .wrongPassword:
                    self.errMessage = "メールアドレス、またはパスワードが間違っています。"
                case .userDisabled:
                    self.errMessage = "このユーザーアカウントは無効化されています。"
                default:
                    self.errMessage = "予期せぬエラーが発生しました。"
                }
            }
        }
    }
}

//
//  UserViewModel.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/08/20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

class UserViewModel: ObservableObject {
    @Published var userInfo: User = .init()
    // 認証マネージャー
    @State var authManager = AuthManager()
    // Storage appURL
    let appPath: String = "gs://albumize-9b6fb.appspot.com/"
    
    // MARK: Storage
    // プロフィール画像を保存
    func saveProfileImage(userId: String,
                          profileImageurl: String,
                          complition: @escaping (Bool) -> Void) {
        // ストレージ参照を作成する
        let reference = Storage.storage().reference()
        // アップロードするファイルへの参照を作成する
        let imageRef = reference.child(profileImageurl)
        // デフォルト画像取得
        let image = UIImage(named: "DefaultProfileImage")
        
        // pngに変換する。できない場合は処理終了
        guard let imageData = image?.pngData() else {
            return
        }
    
        // ファイルをパスにアップロードします。
        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                // エラーが発生
                print("ユーザープロフィール画像のアップロードに失敗しました。)")
                complition(false)
                return
            }
        }
        
        // サイズも取得可能
        // let size = metadata.size
        
        print("ユーザープロフィール画像のアップロードに成功しました。[url:\(profileImageurl)]")
        complition(true)
    }
    
    // MARK: Firestore
    // ユーザ情報を保存
    func saveUserData(userId: String,
                      userName: String,
                      gender: String,
                      birthday: String,
                      email: String,
                      profileImageUrl: String,
                      isInGroup: Bool) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        let userData: [String: Any] = [
            "userName": userName,
            "gender": gender,
            "email": email,
            "birthday": birthday,
            "profileImageUrl": profileImageUrl,
            "isInGroup": isInGroup,
            "createdAt": Timestamp(date: Date()),
            "updatedAt": Timestamp(date: Date())
        ]
        
        userRef.setData(userData)
        print("Firestore登録完了[users]")
    }
    
    // ユーザ情報を取得
    func getUserData(id: String, completion: @escaping (User?) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(id)
        
        docRef.getDocument() { document, error in
            // エラー発生時
            if let error = error {
                print("Error getting document \(id): \(error)")
            } else {
                // データ取得成功時に User オブジェクトを返す
                if let document = document, document.exists {
                    let createdAt: Timestamp = document["createdAt"] as! Timestamp
                    let updatedAt: Timestamp = document["updatedAt"] as! Timestamp
                    
                    // ユーザ情報格納
                    let user = User(id: document.documentID,
                                    name: document["userName"] as? String ?? "",
                                    gender: document["gender"] as? String ?? "",
                                    email: document["email"] as? String ?? "",
                                    birthday: document["birthday"] as? String ?? "",
                                    profileImageUrl: document["profileImageUrl"] as? String ?? "",
                                    isInGroup: document["isInGroup"] as? Bool ?? false,
                                    createdAt: createdAt.dateValue(),
                                    updatedAt: updatedAt.dateValue())

                    print(user)
                    semaphore.signal()
                    completion(user)
                } else {
                    // ドキュメントが存在しない場合は nil を返す
                    print("Document does not exist")
                    semaphore.signal()
                    completion(nil)
                }
            }
        }
        
        //semaphore.wait()
    }
    
    // ユーザ情報をオブジェクトに格納する
    func loadUserInfo(completion: @escaping (Bool) -> Void) {
        if let currentUser = authManager.auth.currentUser {
            // Firestoreからユーザを取得
            getUserData(id: currentUser.uid) { userResult in
                if let userResult = userResult {
                    self.userInfo = userResult
                    completion(true)
                }
            }
        }
        completion(false)
    }
}

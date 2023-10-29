//
//  FirestoreManager.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/08/20.
//


import FirebaseFirestore

// Firestoreマネージャー
final class FirestoreManager {
    
    let db = Firestore.firestore()
    
    // ユーザ情報を保存
    func saveUserData(userId: String, userName: String, gender: String, birthday: String, email: String, profileImagePath: String) {
        let userRef = db.collection("users").document(userId)
        
        let userData: [String: Any] = [
            "userName": userName,
            "gender": gender,
            "email": email,
            "birthday": birthday,
            "profileImagePath": profileImagePath,
            "createdAt": Timestamp(date: Date()),
            "updatedAt": Timestamp(date: Date())
        ]
        
        print("Firestore登録完了[users]")
        userRef.setData(userData)
    }
    
    // ユーザ情報を取得
    func getUserData(id: String, completion: @escaping (User?) -> Void) {
        let docRef = db.collection("users").document(id)
        
        docRef.getDocument() { document, error in
            // エラー発生時
            if let error = error {
                print("Error getting document \(id): \(error)")
            } else {
                // データ取得成功時に User オブジェクトを返す
                if let document = document, document.exists {
                    let user = User(id: document.documentID,
                                name: document["userName"] as? String ?? "",
                                gender: document["gender"] as? String ?? "",
                                email: document["email"] as? String ?? "",
                                birthday: document["birthday"] as? String ?? "",
                                createdAt: document["createdAt"] as! Date,
                                updatedAt: document["updatedAt"] as! Date)
                    
                    completion(user)
                } else {
                    // ドキュメントが存在しない場合は nil を返す
                    print("Document does not exist")
                    completion(nil)
                }
            }
        }
    }
}

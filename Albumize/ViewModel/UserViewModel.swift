//
//  UserViewModel.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/08/20.
//

import SwiftUI
import FirebaseFirestore

class UserViewModel: ObservableObject {
    // ユーザーデータをFirestoreに保存
    func saveUserData(userId: String, userName: String, imageURL: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        let userData: [String: Any] = [
            "userName": userName,
            "imageURL": imageURL,
            "createdAt": Timestamp(),
            "updatedAt": Timestamp()
        ]
        
        userRef.setData(userData)
    }
}

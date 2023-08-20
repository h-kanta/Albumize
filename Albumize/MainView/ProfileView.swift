//
//  UserView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/20.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct ProfileView: View {
    
    // 認証マネージャー
    @State var authManager: AuthManager = AuthManager()
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack{
                    Image("DefaultProfile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50).stroke(.black, lineWidth: 0)
                        )
                    
                    //
                    Button {
                        let storage = Storage.storage()
                        let reference = storage.reference()
                        
                        let path = "gs://[プロジェクト名].appspot.com/test/test.png"
                        let imageRef = reference.child(path)
                        
                        let image = UIImage(named: "hari1")
                        
                        guard let data = image?.pngData() else {
                            return
                        }
                        let uploadTask = imageRef.putData(data)
                        
                        var downloadURL: URL?
                        uploadTask.observe(.success) { _ in
                            imageRef.downloadURL { url, error in
                                if let url = url {
                                    downloadURL = url
                                }
                            }
                        }
                        
                        uploadTask.observe(.failure) { snapshot in
                            if let message = snapshot.error?.localizedDescription {
                                print(message)
                            }
                        }
                        
                    } label: {
                        Text("画像アップロード")
                            .font(.largeTitle)
                    }
                    //
                    Button {
                        do {
                            try Auth.auth().signOut()
                            isPresented = true
                        } catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)
                        }
                    } label: {
                        Text("LogOut")
                    }
                    // MARK: データ登録
                    Button {
                        if let userId = authManager.auth.currentUser?.uid {
                            Firestore.firestore().collection("users").document(userId).setData(["name": "kanta"])
                            print(userId)
                        }
                    } label: {
                        Text("Firestore")
                            .padding()
                    }
                    // MARK: データ取得
                    Button {
                        // 特定のコレクションにある全てのドキュメントのデータを取得
                        Firestore.firestore().collection("users").getDocuments { (success, error) in
                            if let error = error {
                                print(error.localizedDescription.description)
                            } else {
                                let names = success!.documents.compactMap { $0.data() }
                                print(names)
                            }
                        }
                        // 特定のコレクションにある一つのドキュメントのデータを取得
                        if let userId = authManager.auth.currentUser?.uid {
                            Firestore.firestore().collection("users").document(userId).getDocument { (success, error) in
                                if let error = error {
                                    print(error.localizedDescription.debugDescription)
                                } else {
                                    let name = success!.data()
                                    print(name!)
                                }
                            }
                        }
                    } label: {
                        Text("Firestore取得")
                    }
                    
                    // MARK: データ更新
                    Button {
                        if let userId = authManager.auth.currentUser?.uid {
                            Firestore.firestore().collection("users").document(userId).updateData([
                                "name": "horikawa kanta"
                            ]) { error in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    print("success")
                                }
                            }
                        }
                    } label: {
                        Text("Firestore更新")
                            .padding()
                    }
                    
                    // MARK: フィールド削除
                    Button {
                        if let userId = authManager.auth.currentUser?.uid {
                            Firestore.firestore().collection("users").document(userId).updateData([
                                "name": FieldValue.delete()
                            ]) { error in
                                if let error = error {
                                    print(error)
                                } else {
                                    print("field successfully updated")
                                }
                            }
                        }
                    } label: {
                        Text("Firestore フィールド削除")
                            .padding()
                    }
                    
                    // MARK: ドキュメント削除
                    Button {
                        if let userId = authManager.auth.currentUser?.uid {
                            Firestore.firestore().collection("users").document(userId).delete() { error in
                                if let error = error {
                                    print(error)
                                } else {
                                    print("Document successfully removed")
                                }
                            }
                        }
                    } label: {
                        Text("Firestore ドキュメント削除")
                            .padding()
                    }
                }
            }
            
            // ログアウト時はログイン画面へ遷移する
            .fullScreenCover(isPresented: $isPresented) {
                StartUpView()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

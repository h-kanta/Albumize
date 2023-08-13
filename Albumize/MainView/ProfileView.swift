//
//  UserView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/20.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct ProfileView: View {
    
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack{
                    Circle()
                        .fill(Color.black)
                        .frame(width: 200, height: 100)
                        .padding()
                    
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

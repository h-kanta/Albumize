//
//  StorageManager.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/08/20.
//

import FirebaseStorage

final class StorageManager {
    let storage = Storage.storage()
    var downloadURL: URL?
    let appPath: String = "gs://albumize-9b6fb.appspot.com/"
    
    // プロフィール画像を保存
    func saveProfileImage(path: String, complition: @escaping (Bool) -> Void) {
        let reference = storage.reference()
        let imageRef = reference.child(path)
        
        let image = UIImage(named: "DefaultProfileImage")
        
        guard let data = image?.pngData() else {
            return
        }
        
        let uploadTask = imageRef.putData(data)
        
        uploadTask.observe(.success) { _ in
            imageRef.downloadURL { url, error in
                if let url = url {
                    self.downloadURL = url
                }
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let message = snapshot.error?.localizedDescription {
                print(message)
            }
        }
        
        print("FirebaseStorage保存完了[path:\(path)]")
        complition(true)
    }
}

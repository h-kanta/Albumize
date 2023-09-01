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
    
    // Firebase Storageに保存
    func saveStorage(image: String, path: String, complition: @escaping (Bool) -> Void) {
        let reference = storage.reference()
        let imageRef = reference.child(path)
        
        let image = UIImage(named: image)
        
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
        
        complition(true)
    }
    
//    let storage = Storage.storage()
//    let reference = storage.reference()
//
//    let path = "gs://[プロジェクト名].appspot.com/test/test.png"
//    let imageRef = reference.child(path)
//
//    let image = UIImage(named: "hari1")
//
//    guard let data = image?.pngData() else {
//        return
//    }
//    let uploadTask = imageRef.putData(data)
//
//    var downloadURL: URL?
//    uploadTask.observe(.success) { _ in
//        imageRef.downloadURL { url, error in
//            if let url = url {
//                downloadURL = url
//            }
//        }
//    }
//
//    uploadTask.observe(.failure) { snapshot in
//        if let message = snapshot.error?.localizedDescription {
//            print(message)
//        }
//    }
}

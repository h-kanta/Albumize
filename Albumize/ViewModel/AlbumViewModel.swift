//
//  AlbumViewModel.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/06.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

class AlbumViewModel: ObservableObject {
    @Published var albums: [Album] = []
    @Published var selectedAlbumID: UUID = .init()
    
    @Published var favoriteAlbums: [Album] = []
    
    // MARK: Storage
    // アルバム画像を保存
//    func saveAlbumImage(profileImageurl: String,
//                        photos: [PhotoAssetModel],
//                        complition: @escaping (Bool) -> Void) {
//        // ストレージ参照を作成する
//        let reference = Storage.storage().reference()
//
//        // アルバム画像アップロード
//        for photo in photos {
//            let imageName = "\(Int(Date().timeIntervalSince1970 * 1000)).jpg"
//            // アップロードするファイルへの参照を作成する
//            let imageRef = reference.child("\(profileImageurl)/\(imageName)")
//
//            if let thumbnail = photo.thumbnail {
//                // pngに変換する。できない場合は処理終了
//                guard let imageData = thumbnail.jpegData(compressionQuality: 0.8) else {
//                    // エラーが発生
//                    print("画像をjpgに変換できませんでした。")
//                    complition(false)
//                    return
//                }
//
//                // メタデータを設定
//                let metadata = StorageMetadata()
//                metadata.contentType = "image/jpeg"
//
//                // 画像をパスにアップロードする
//                let uploadTask = imageRef.putData(imageData, metadata: metadata)
//                //                    guard metadata != nil else {
//                //                        // エラーが発生
//                //                        print("アルバム画像のアップロードに失敗しました。)")
//                //                        complition(false)
//                //                        return
//                //                    }
//                //                }
//                // アップロード成功
//                uploadTask.observe(.failure) { snapshot in
//                    if let message = snapshot.error?.localizedDescription {
//                        print(message)
//                        complition(false)
//                    }
//                }
//                // アップロード失敗
//                uploadTask.observe(.success) { _ in
//                    print("アルバム画像のアップロードに成功しました。[url:\(profileImageurl)]")
//                    complition(true)
//                }
//            }
//        }
//
//        //complition(false)
//    }
    
    // MARK: アルバム保存
    // albumsサブコレクションに保存する
//    func saveAlbumData(userGorupCollection: String,
//                       userGroupid: String,
//                       albumId: String,
//                       albumName: String) {
//        let db = Firestore.firestore()
//        let userGroupRef = db.collection(userGorupCollection).document(userGroupid)
//        let albumRef = userGroupRef.collection("albums").document(albumId)
//
//        let albumUrl = "\(userGorupCollection)/\(userGroupid)/albums/\(albumId)"
//        let albumCreatedAt = Date()
//
//        let albumData: [String: Any] = [
//            "albumName": albumName,
//            "albumUrl": albumUrl,
//            "isFavorited": false,
//            "createdAt": Timestamp(date: albumCreatedAt),
//            "updatedAt": Timestamp(date: albumCreatedAt)
//        ]
//
//        // firestore に保存
//        albumRef.setData(albumData)
//
//        var albumPhotos: [Photo] = []
//
//        // 特定のStorage内にあるすべての画像を取得
//        getAllImagesFromDirectory(albumDirectoryPath: albumUrl) { imageUrls, error in
//            if let imageUrls = imageUrls {
//                // URL から Image を取得し、photos 配列に追加
////                for imageUrl in imageUrls {
////                    let uiImage = self.getImageByUrl(url: imageUrl.absoluteString)
////                    albumPhotos.append(Photo(image: Image(uiImage: uiImage)))
////                }
//                // アルバム情報に追加
//                self.albums.append(Album(id: albumId,
//                                         albumName: albumName,
//                                         albumUrl: albumUrl,
//                                         photos: albumPhotos,
//                                         isFavorited: false,
//                                         createdAt: albumCreatedAt,
//                                         updatedAt: albumCreatedAt))
//
//                print("Firestore登録完了[albums: \(albumData)]")
//                //completion(true)
//            } else {
//                print("画像の取得に失敗しました")
//                //completion(false)
//            }
//        }
//    }
    
    // MARK: アルバム情報を全件取得
//    func getAllAlbumData(userOrGroupCollection: String,
//                         userOrGroupId: String,
//                         completion:
//                         @escaping ([Album]?) -> Void) {
//        let db = Firestore.firestore()
//        let userGroupRef = db.collection(userOrGroupCollection).document(userOrGroupId)
//        let albumRef = userGroupRef.collection("albums")
//
//        // albumsコレクション全件取得する
//        albumRef.getDocuments() { querySnapshot, error in
//            if let error = error {
//                print("Error getting collection albums document \(userOrGroupId): \(error)")
//                completion(nil)
//            } else {
//                self.albums.removeAll()
//                for document in querySnapshot!.documents {
//                    self.setAlbumData(userOrGroupCollection: userOrGroupCollection,
//                                      userOrGroupId: userOrGroupId, document: document)
//                }
//
//                // アルバムが存在するか
//                if self.albums.isEmpty {
//                    // 存在しない場合は nil を返す
//                    print("Document does not exist")
//                    completion(nil)
//                } else {
//                    completion(self.albums)
//                }
//            }
//        }
//    }
    
    // MARK: アルバム情報をセット
//    func setAlbumData(userOrGroupCollection: String,
//                      userOrGroupId: String,
//                      document: QueryDocumentSnapshot) {
//        // データ取得成功時に User オブジェクトを返す
//        if document.exists {
//            let albumUrl = document["albumUrl"] as? String ?? ""
//            var albumPhotos: [Photo] = []
//
//            // 特定のStorage内にあるすべての画像を取得
//            getAllImagesFromDirectory(albumDirectoryPath: albumUrl) { imageUrls, error in
//                if let imageUrls = imageUrls {
//                    // URL から Image を取得し、photos 配列に追加
//                    //for imageUrl in imageUrls {
//                        //let uiImage = self.getImageByUrl(url: imageUrl.absoluteString)
//                        //albumPhotos.append(Photo(image: Image(uiImage: uiImage)))
//                    //}
//
//                    if (albumPhotos.count != 0) {
//                        let createdAt: Timestamp = document["createdAt"] as! Timestamp
//                        let updatedAt: Timestamp = document["updatedAt"] as! Timestamp
//                        // アルバム情報格納
//                        let album = Album(id: document.documentID,
//                                          albumName: document["albumName"] as? String ?? "",
//                                          albumUrl: albumUrl,
//                                          photos: albumPhotos,
//                                          isFavorited: document["isFavorited"] as? Bool ?? false,
//                                          createdAt: createdAt.dateValue(),
//                                          updatedAt: updatedAt.dateValue())
//                        print(album)
//                        self.albums.append(album)
//                    }
//                } else {
//                    print("画像の取得に失敗しました")
//                }
//            }
//        }
//    }
    
    // MARK: アルバム情報全件取得
    func loadAlbums(collection: String, id: String, complition: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            do {
                self.albums.removeAll()
                // albumsのドキュメントを全件取得
                let documents = try self.getAlbumDocuments(userOrGroupCollection: collection, userOrGroupId: id)
                for document in documents! {
                    let albumUrl = document["albumUrl"] as? String ?? ""
                    let items = try self.getAlbumDirectory(url: albumUrl)
                    let url = try self.getAlbumImageUrls(albumStorageItems: items)
                    let image = try self.getImageByUrl(imageUrls: url)
                    self.setAlbumData(document: document, albumPhotos: image)
                }
            } catch {
                // エラー処理
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                complition(true)
            }
        }
        
        complition(false)
    
//        getAllAlbumData(userOrGroupCollection: collection, userOrGroupId: id) { albumResult in
//            if let albumResult = albumResult {
//                self.albums = albumResult
//            }
//        }
        
        //self.albums = [
//            // USJ
//            Album(
//                name: "USJ",
//                createDate: "2023年4月14日",
//                thumbnail: Image("usjImage8"),
//                photos: [
//                    Photo(image: Image("usjImage1")), Photo(image: Image("usjImage2")), Photo(image: Image("usjImage3")), Photo(image: Image("usjImage4")), Photo(image: Image("usjImage5")), Photo(image: Image("usjImage6")), Photo(image: Image("usjImage7")), Photo(image: Image("usjImage8")), Photo(image: Image("usjImage9")),
//                ]
//            ),
//            // おぱんちゅうさぎ展
//            Album(
//                name: "おぱんちゅうさぎ展",
//                createDate: "2023年4月22日",
//                thumbnail: Image("img2"),
//                photos: [
//                    Photo(image: Image("img1")), Photo(image: Image("img2")), Photo(image: Image("img3")), Photo(image: Image("img4")), Photo(image: Image("img5")), Photo(image: Image("img6")),
//                ]
//            ),
//            // ハリーポッター
//            Album(
//                name: "ハリーポッター",
//                createDate: "2023年6月24日",
//                thumbnail: Image("hari8"),
//                photos: [
//                    Photo(image: Image("hari1")), Photo(image: Image("hari2")), Photo(image: Image("hari3")), Photo(image: Image("hari4")), Photo(image: Image("hari5")), Photo(image: Image("hari6")), Photo(image: Image("hari7")), Photo(image: Image("hari8")),
//                ]
//            ),
//            Album(
//                name: "ハリーポッター",
//                createDate: "2023年6月24日",
//                thumbnail: Image("hari8"),
//                photos: [
//                    Photo(image: Image("hari1")), Photo(image: Image("hari2")), Photo(image: Image("hari3")), Photo(image: Image("hari4")), Photo(image: Image("hari5")), Photo(image: Image("hari6")), Photo(image: Image("hari7")), Photo(image: Image("hari8")),
//                ]
//            )
        //]
    }
    
    //
    func getAlbumDocuments(userOrGroupCollection: String,
                             userOrGroupId: String) throws -> [QueryDocumentSnapshot]? {
        var documents: [QueryDocumentSnapshot]? = []
        let semaphore = DispatchSemaphore(value: 0)
        var errorOrNil: Error?
        
        let db = Firestore.firestore()
        let userGroupRef = db.collection(userOrGroupCollection).document(userOrGroupId)
        let albumRef = userGroupRef.collection("albums")
        
        albumRef.getDocuments() { querySnapshot, error in
            if let error = error {
                errorOrNil = error
                // 非同期処理終了
                semaphore.signal()
            } else {
                documents = querySnapshot?.documents
                // 非同期処理終了
                semaphore.signal()
            }
        }
        // エラー
        if let error = errorOrNil {
            throw error
        }
        // 非同期処理が終了するまで待つ
        semaphore.wait()
        return documents
    }
    
    //
    func getAlbumDirectory(url: String) throws -> [StorageReference] {
        var albumStorageItems: [StorageReference] = []
        var errorOrNil: Error?
        
        let storage = Storage.storage()
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let directoryRef = storage.reference().child(url)
        
        // ディレクトリ内のすべてのアイテムをリストアップ
        directoryRef.listAll { result, error in
            if let error = error {
                errorOrNil = error
                semaphore.signal()
            }
            
            if let result = result {
                albumStorageItems = result.items
                semaphore.signal()
            }
        }
        
        semaphore.wait()
        
        if let error = errorOrNil {
            throw error
        }
        
        return albumStorageItems
    }
    
    //
    func getAlbumImageUrls(albumStorageItems: [StorageReference]) throws -> [URL] {
        var imageUrls: [URL] = []
        var errorOrNil: Error?
        
        for item in albumStorageItems {
            let semaphore = DispatchSemaphore(value: 0)
            // アイテムのダウンロードURLを取得し、配列に追加
            item.downloadURL { url, error in
                if let error = error {
                    errorOrNil = error
                    semaphore.signal()
                }
                
                if let url = url {
                    imageUrls.append(url)
                    semaphore.signal()
                }
            }
            
            semaphore.wait()
        }
        
        if let error = errorOrNil {
            throw error
        }
        
        return imageUrls
    }
    
    //
    func getImageByUrl(imageUrls: [URL]) throws -> [Photo] {
        var albumPhotos: [Photo] = []
        
        for imageUrl in imageUrls {
            let url = URL(string: imageUrl.absoluteString)
            do {
                let imageData = try Data(contentsOf: url!)
                let uiImage = UIImage(data: imageData)!
                albumPhotos.append(Photo(image: Image(uiImage: uiImage)))
            } catch let err {
                throw err
            }
        }
        
        return albumPhotos
    }
    
    //
    func setAlbumData(document: QueryDocumentSnapshot, albumPhotos: [Photo]) -> Void {
        let createdAt: Timestamp = document["createdAt"] as! Timestamp
        let updatedAt: Timestamp = document["updatedAt"] as! Timestamp
        // アルバム情報格納
        let album = Album(id: document.documentID,
                          albumName: document["albumName"] as? String ?? "",
                          albumUrl: document["albumUrl"] as? String ?? "",
                          photos: albumPhotos,
                          isFavorited: document["isFavorited"] as? Bool ?? false,
                          createdAt: createdAt.dateValue(),
                          updatedAt: updatedAt.dateValue())

        self.albums.append(album)
    }
    
    
    // MARK: アルバム作成
    func createAlbum(albumStorageUrl: String,
                  albumPhotos: [PhotoAssetModel],
                  collection: String,
                  id: String,
                  albumId: String,
                  name: String,
                  complition: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            do {
                try self.saveAlbumStorage(albumStorageUrl: albumStorageUrl, photos: albumPhotos)
                var album = try self.saveAlbumData(userGorupCollection: collection, userGroupid: id, albumId: albumId, albumName: name)
                let items = try self.getAlbumDirectory(url: album.albumUrl)
                let url = try self.getAlbumImageUrls(albumStorageItems: items)
                let image = try self.getImageByUrl(imageUrls: url)
                
                album.photos = image
                self.albums.append(album)
            } catch {
                // エラー処理
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                complition(true)
            }
        }
    }
    
    enum StringError: Error {
        case message(String)
    }
    //
    func saveAlbumStorage(albumStorageUrl: String,
                        photos: [PhotoAssetModel]) throws -> Void {
        let semaphore = DispatchSemaphore(value: 0)
        var errorOrNil: Error?
        let reference = Storage.storage().reference()
        
        // アルバム画像アップロード
        for photo in photos {
            let imageName = "\(Int(Date().timeIntervalSince1970 * 1000)).jpg"
            // アップロードするファイルへの参照を作成する
            let imageRef = reference.child("\(albumStorageUrl)/\(imageName)")
            
            if let thumbnail = photo.thumbnail {
                // pngに変換する。できない場合は処理終了
                guard let imageData = thumbnail.jpegData(compressionQuality: 0.8) else {
                    // エラー
                    errorOrNil = StringError.message("画像をjpgに変換できませんでした。")
                    semaphore.signal()
                    throw errorOrNil!
                }
                // メタデータを設定
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                // 画像をパスにアップロードする
                let uploadTask = imageRef.putData(imageData, metadata: metadata)

                // アップロード失敗
                uploadTask.observe(.failure) { snapshot in
                    if let error = snapshot.error {
                        errorOrNil = error
                        semaphore.signal()
                    }
                }
                // アップロード成功
                uploadTask.observe(.success) { _ in
                    semaphore.signal()
                }
            }
            
            semaphore.wait()
        }

        // エラー
        if let error = errorOrNil {
            throw error
        }
    }
    
    //
    func saveAlbumData(userGorupCollection: String,
                       userGroupid: String,
                       albumId: String,
                       albumName: String) throws -> Album {
        let semaphore = DispatchSemaphore(value: 0)
        var errorOrNil: Error?
        
        let db = Firestore.firestore()
        let userGroupRef = db.collection(userGorupCollection).document(userGroupid)
        let albumRef = userGroupRef.collection("albums").document(albumId)
        
        let albumUrl = "\(userGorupCollection)/\(userGroupid)/albums/\(albumId)"
        let albumCreatedAt = Date()
        
        let albumData: [String: Any] = [
            "albumName": albumName,
            "albumUrl": albumUrl,
            "isFavorited": false,
            "createdAt": Timestamp(date: albumCreatedAt),
            "updatedAt": Timestamp(date: albumCreatedAt)
        ]
        
        // firestore に保存
        albumRef.setData(albumData) { error in
            if let error = error {
                errorOrNil = error
                semaphore.signal()
            } else {
                semaphore.signal()
            }
        }
        
        semaphore.wait()
        
        if let error = errorOrNil {
            throw error
        }
        
        let album = Album(id: albumId,
                              albumName: albumName,
                              albumUrl: albumUrl,
                              photos: [],
                              isFavorited: false,
                              createdAt: albumCreatedAt,
                              updatedAt: albumCreatedAt)
        
        return album
    }
}


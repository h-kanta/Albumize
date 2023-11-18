//
//  AlbumViewModel.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/06.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import Kingfisher

class AlbumViewModel: ObservableObject {
    @Published var albums: [Album] = []
    @Published var selectedAlbumID: UUID = .init()
    @Published var favoriteAlbums: [Album] = []
    
    var loadTask: Task<UIImage, Error>?
    // Kingfisher のキャッシュ
    let cache = ImageCache.default
    
    // MARK: アルバム情報全件取得
    func loadAlbums(collection: String, id: String, complition: @escaping (Bool) -> Void) {
        self.albums.removeAll()
        var albumDatas: [Album] = []
        
        DispatchQueue.global().async {
            do {
                // albumsのドキュメントを全件取得
                let documents = try self.getAlbumDocuments(userOrGroupCollection: collection, userOrGroupId: id)
                for document in documents! {
                    let albumUrl = document["albumUrl"] as? String ?? ""
                    let items = try self.getAlbumDirectory(url: albumUrl, isAll: true)
                    let urls = try self.getAlbumImageUrls(albumStorageItems: items)
                    albumDatas.append(self.setAlbumData(document: document, albumPhotos: urls))
                }
            } catch {
                // エラー処理
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self.albums = albumDatas
                complition(true)
            }
        }
        
        complition(false)
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
    func getAlbumDirectory(url: String, isAll: Bool = false) throws -> ([StorageReference]) {
        var albumStorageItems: [StorageReference] = []
        var errorOrNil: Error?
        
        let storage = Storage.storage()
        let semaphore = DispatchSemaphore(value: 0)
        let directoryRef = storage.reference().child(url)
        
        if isAll {
            // １つ目のディレクトリ内のアイテムをリストアップ
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
        } else {
            // １つ目のディレクトリ内のアイテムをリストアップ
            directoryRef.list(maxResults: 1) { result, error in
                if let error = error {
                    errorOrNil = error
                    semaphore.signal()
                }
                
                if let result = result {
                    albumStorageItems = result.items
                    semaphore.signal()
                }
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
        //var imageUrls: [(URL, String)] = []
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
                    //imageUrls.append((url, item.fullPath))
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
    //    func getImageByUrls(imageUrls: [(URL, String)]) throws -> [Photo] {
    //        var albumPhotos: [Photo] = []
    //
    //        for imageUrl in imageUrls {
    //            let dataUrl = imageUrl.0
    //            let storageUrl = imageUrl.1
    //
    //            let url = URL(string: dataUrl.absoluteString)
    //            do {
    //                let imageData = try Data(contentsOf: url!)
    //                let uiImage = UIImage(data: imageData)!
    //                // キャッシュに保存
    //                //cache.store(uiImage, forKey: storageUrl)
    //                albumPhotos.append(Photo(image: Image(uiImage: uiImage)))
    //            } catch let err {
    //                throw err
    //            }
    //        }
    //
    //        return albumPhotos
    //    }
    
    func setAlbumData(document: QueryDocumentSnapshot, albumPhotos: [URL]) -> Album {
        // 日付フォーマット（yyyy年MM月dd日）
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM",                                                                   options: 0,locale: Locale(identifier: "ja_JP"))
        
        let createdAt: Timestamp = document["createdAt"] as! Timestamp
        let updatedAt: Timestamp = document["updatedAt"] as! Timestamp
        
        // アルバム情報格納
        let album = Album(id: document.documentID,
                          albumName: document["albumName"] as? String ?? "",
                          albumUrl: document["albumUrl"] as? String ?? "",
                          photoUrls: albumPhotos,
                          photoCount: document["photoCount"] as? Int ?? 0,
                          isFavorited: document["isFavorited"] as? Bool ?? false,
                          createdAt: formatter.string(from: createdAt.dateValue()),
                          updatedAt: formatter.string(from: updatedAt.dateValue())
        )
        
        return album
    }
    
    // キャッシュから画像を読み込む
    func readCache(storageUrl: String) throws -> [Photo] {
        let semaphore = DispatchSemaphore(value: 0)
        var errorOrNil: Error?
        
        var image: [Photo] = []
        cache.retrieveImage(forKey: storageUrl) { result in
            switch result {
            case .success(let value):
                image.append(Photo(image: Image(uiImage: value.image!)))
                semaphore.signal()
            case .failure(let error):
                errorOrNil = error
                semaphore.signal()
            }
        }
        
        semaphore.wait()
        
        if let error = errorOrNil {
            throw error
        }
        
        return image
    }
    
    // MARK: アルバム作成
    func createAlbum(albumStorageUrl: String,
                     albumPhotos: [PhotoAssetModel],
                     collection: String,
                     id: String,
                     albumId: String,
                     name: String,
                     complition: @escaping (Bool) -> Void) {
        var albumData: Album = .init()
        
        DispatchQueue.global().async {
            do {
                try self.saveAlbumStorage(albumStorageUrl: albumStorageUrl, photos: albumPhotos)
                let albumUrl = "\(collection)/\(id)/albums/\(albumId)"
                let items = try self.getAlbumDirectory(url: albumUrl, isAll: true)
                let url = try self.getAlbumImageUrls(albumStorageItems: items)
                let album = try self.saveAlbumData(userGorupCollection: collection,
                                                   userGroupid: id,
                                                   albumId: albumId,
                                                   albumName: name,
                                                   urls: url)
                
                albumData = album
            } catch {
                // エラー処理
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self.albums.append(albumData)
                complition(true)
            }
        }
        
        complition(false)
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
            let storageUrl = "\(albumStorageUrl)/\(imageName)"
            // アップロードするファイルへの参照を作成する
            let imageRef = reference.child(storageUrl)
            
            if let thumbnail = photo.thumbnail {
                // jpgに変換する。できない場合は処理終了
                guard let imageData = thumbnail.jpegData(compressionQuality: 0.2) else {
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
                    // キャッシュに保存
                    //self.cache.store(UIImage(data: imageData)!, forKey: storageUrl)
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
                       albumName: String,
                       urls: [URL]) throws -> Album {
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
            "photoCount": urls.count,
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
        
        // 日付フォーマット（yyyy年MM月dd日）
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM",                                                                   options: 0,locale: Locale(identifier: "ja_JP"))
        
        let album = Album(id: albumId,
                          albumName: albumName,
                          albumUrl: albumUrl,
                          //photos: photos,
                          photoUrls: urls,
                          photoCount: urls.count,
                          isFavorited: false,
                          createdAt: formatter.string(from: albumCreatedAt),
                          updatedAt: formatter.string(from: albumCreatedAt))
        
        return album
    }
}

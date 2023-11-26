//
//  PhotosPickerModel.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/09.
//

import SwiftUI
import PhotosUI

class PhotoPickerViewModel: ObservableObject {
    // フェッチされた写真を保持
    @Published var fetchedPhotos: [PhotoAssetModel] = []
    // 選択された写真を保持
    @Published var selectedPhotos: [PhotoAssetModel] = []
    // 写真ライブラリ選択画面表示フラグ
    @Published var isPhotoPickerShowing: Bool = false
    
    //
    init() {
        //fetchPhotos()
        //phasset()
    }
    
    // 写真の取得
//    func fetchPhotos() {
//        let options = PHFetchOptions()
//        // PHAsset という iOS の写真フレームワークのクラスを使用して、
//        // ユーザーライブラリから画像のアセットを取得し、PhotoAssetModel に変換して fetchedPhotos に追加
//        // 希望に応じて変更します
//        options.fetchLimit = 100 // 一度に取得するアセット数
//        options.includeHiddenAssets = false
//        options.includeAssetSourceTypes = [.typeUserLibrary]
//        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)] // 作成日時で降順ソート
//        PHAsset.fetchAssets(with: .image, options: options).enumerateObjects { asset, _, _ in
//            let photoAsset: PhotoAssetModel = .init(asset: asset)
//            self.fetchedPhotos.append(photoAsset)
//        }
//    }
    
    // ライブラリの写真を取得
    func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        // imageのみ取得
        //fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        // 作成日時の降順でソート
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        fetchResult.enumerateObjects { asset, _, _ in
            let photoAsset: PhotoAssetModel = .init(asset: asset)
            self.fetchedPhotos.append(photoAsset)
//            DispatchQueue.global().async {
//                PHCachingImageManager().requestImage(for: asset,
//                                                     targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
//                                                     contentMode: .aspectFill,
//                                                     options: nil) { (image, nil) in
//                    DispatchQueue.main.async {
//                        if let image = image {
//                            self.fetchedImages.append(PhotoAssetModel(thumbnail: image))
//                        }
//                    }
//                }
//            }
        }
        
//        manager.requestImage(for: photoAsset.asset, targetSize: CGSize(width: photoAsset.asset.pixelWidth, height: photoAsset.asset.pixelHeight), contentMode: .aspectFill, options: nil) { photo,
//            _ in
//            photoAsset.thumbnail = photo
//        }
        
//        if let firstAsset = fetchResult.firstObject {
//            let options = PHContentEditingInputRequestOptions()
//            firstAsset.requestContentEditingInput(with: options) { (input, _) in
//                if let imageUrl = input?.fullSizeImageURL {
//                    // ここで取得したURLを利用する
//
//                }
//            }
//        }
    }
    
    //
    func showImage() {
        let manager: PHImageManager = .default()
        
        let requestOptions = PHImageRequestOptions()
        // 要求される画像のバージョン
        requestOptions.version = .current
        // 要求された画質と配信の優先順位
        requestOptions.deliveryMode = .highQualityFormat
        // 要求された画像のサイズを変更する方法を指定するモード
        requestOptions.resizeMode = .exact
        // 同期的に処理するか
        requestOptions.isSynchronous = true
        // iCloud からダウンロードできるかどうか
        requestOptions.isNetworkAccessAllowed = true
        
        //
        for i in 0..<self.fetchedPhotos.count {
            //if let targetPhotoAsset = self.fetchedPhotos.first(where: {  })
            manager.requestImage(for: self.fetchedPhotos[i].asset,
                                 targetSize: CGSize(width: self.fetchedPhotos[i].asset.pixelWidth,
                                                    height: self.fetchedPhotos[i].asset.pixelHeight),
                                 contentMode: .aspectFill,
                                 options: requestOptions) { (image, info) in
                DispatchQueue.main.async {
                    self.fetchedPhotos[i].thumbnail = image
                }
            }
        }
    }
}



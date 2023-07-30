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
    //
    // 写真ライブラリ選択画面表示フラグ
    @Published var isPhotoPickerShowing: Bool = false
    
    //
    init() {
        fetchPhotos()
    }
    
    // 写真の取得
    func fetchPhotos() {
        let options = PHFetchOptions()
        // PHAsset という iOS の写真フレームワークのクラスを使用して、
        // ユーザーライブラリから画像のアセットを取得し、PhotoAssetModel に変換して fetchedPhotos に追加
        // 希望に応じて変更します
        options.fetchLimit = 100 // 一度に取得するアセット数
        options.includeHiddenAssets = false
        options.includeAssetSourceTypes = [.typeUserLibrary]
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)] // 作成日時で降順ソート
        PHAsset.fetchAssets(with: .image, options: options).enumerateObjects { asset, _, _ in
            let photoAsset: PhotoAssetModel = .init(asset: asset)
            self.fetchedPhotos.append(photoAsset)
        }
    }
}



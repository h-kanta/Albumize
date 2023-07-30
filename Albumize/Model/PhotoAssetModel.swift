//
//  PhotoPicker.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/09.
//

import SwiftUI
import PhotosUI

struct PhotoAssetModel: Identifiable {
    var id: UUID = .init()
    var asset: PHAsset
    var thumbnail: UIImage?
    // 選択順
    var assetIndex: Int = -1
    // 選択状態か
    var isSelected: Bool = false
}


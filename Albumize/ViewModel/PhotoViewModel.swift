//
//  Photo.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/25.
//

import SwiftUI

class PhotoViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    // 写真が選択されているか
    @Published var isSelectedPhoto: Bool = false
    // 選択した写真
    @Published var selectedPhotoID: UUID = .init()
    // 写真位置
    @Published var photoPosition: CGSize = CGSize.zero
}

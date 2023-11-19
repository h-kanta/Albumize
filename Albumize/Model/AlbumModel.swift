//
//  AlbumModel.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/06.
//

import SwiftUI

struct Album: Identifiable {
    var id: String = ""
    var albumName: String = ""
    var albumUrl: String = ""
    var photos: [Photo] = []
    var photoCount: Int = 0
    var isFavorited: Bool = false
    var createdAt: String = ""
    var updatedAt: String = ""
}

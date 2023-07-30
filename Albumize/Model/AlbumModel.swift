//
//  AlbumModel.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/06.
//

import SwiftUI

struct Album: Identifiable {
    let id: UUID = UUID()
    var name: String = ""
    var createDate: String = ""
    var thumbnail: Image = .init("")
    var isFavorited: Bool = false
    var photos: [Photo] = []
}

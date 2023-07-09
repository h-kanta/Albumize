//
//  AlbumViewModel.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/06.
//

import SwiftUI

class AlbumViewModel: ObservableObject {
    @Published var albums: [Album] = []
    @Published var selectedAlbumID: UUID = .init()

    @Published var favoriteAlbums: [Album] = []
    
    init() {
        loadAlbums()
    }
    
    func loadAlbums() {
        self.albums = [
            // USJ
            Album(
                name: "USJ",
                createDate: "2023年4月14日",
                thumbnail: "usjImage8",
                photos: [
                    Photo(value: "usjImage1"), Photo(value: "usjImage2"), Photo(value: "usjImage3"), Photo(value: "usjImage4"), Photo(value: "usjImage5"), Photo(value: "usjImage6"), Photo(value: "usjImage7"), Photo(value: "usjImage8"), Photo(value: "usjImage9"),
                ]
            ),
            // おぱんちゅうさぎ展
            Album(
                name: "おぱんちゅうさぎ展",
                createDate: "2023年4月22日",
                thumbnail: "img2",
                photos: [
                    Photo(value: "img1"), Photo(value: "img2"), Photo(value: "img3"), Photo(value: "img4"), Photo(value: "img5"), Photo(value: "img6"),
                ]
            ),
            // ハリーポッター
            Album(
                name: "ハリーポッター",
                createDate: "2023年6月24日",
                thumbnail: "hari8",
                photos: [
                    Photo(value: "hari1"), Photo(value: "hari2"), Photo(value: "hari3"), Photo(value: "hari4"), Photo(value: "hari5"), Photo(value: "hari6"), Photo(value: "hari7"), Photo(value: "hari8"),
                ]
            )
        ]
    }
    
    func TodayPhotoSelected() {
        
    }
    
    
    
    
    
    
}


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
                thumbnail: Image("usjImage8"),
                photos: [
                    Photo(image: Image("usjImage1")), Photo(image: Image("usjImage2")), Photo(image: Image("usjImage3")), Photo(image: Image("usjImage4")), Photo(image: Image("usjImage5")), Photo(image: Image("usjImage6")), Photo(image: Image("usjImage7")), Photo(image: Image("usjImage8")), Photo(image: Image("usjImage9")),
                ]
            ),
            // おぱんちゅうさぎ展
            Album(
                name: "おぱんちゅうさぎ展",
                createDate: "2023年4月22日",
                thumbnail: Image("img2"),
                photos: [
                    Photo(image: Image("img1")), Photo(image: Image("img2")), Photo(image: Image("img3")), Photo(image: Image("img4")), Photo(image: Image("img5")), Photo(image: Image("img6")),
                ]
            ),
            // ハリーポッター
            Album(
                name: "ハリーポッター",
                createDate: "2023年6月24日",
                thumbnail: Image("hari8"),
                photos: [
                    Photo(image: Image("hari1")), Photo(image: Image("hari2")), Photo(image: Image("hari3")), Photo(image: Image("hari4")), Photo(image: Image("hari5")), Photo(image: Image("hari6")), Photo(image: Image("hari7")), Photo(image: Image("hari8")),
                ]
            )
        ]
    }
}


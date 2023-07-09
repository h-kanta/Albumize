//
//  AlbumizeApp.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/19.
//

import SwiftUI

@main
struct AlbumizeApp: App {
//    let photo = Photo()
//    let album = Album()
    var body: some Scene {
        WindowGroup {
//            ContentView(photoViewModel: .init(photo: photo))
            ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
        }
    }
}


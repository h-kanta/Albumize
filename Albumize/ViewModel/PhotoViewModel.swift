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
    
//    func photoLoader() {
//        self.photos = [Photo(value: "usjImage1"), Photo(value: "usjImage2"), Photo(value: "usjImage3"), Photo(value: "usjImage4"), Photo(value: "usjImage5"), Photo(value: "usjImage6"), Photo(value: "usjImage7"), Photo(value: "usjImage8"), Photo(value: "usjImage9"), Photo(value: "img1"), Photo(value: "img2"), Photo(value: "img3"), Photo(value: "img4"), Photo(value: "img5"), Photo(value: "img6"), Photo(value: "atumori1")]
//    }
}

//class Photo: ObservableObject{
//
//    @Published var images: [String] = ["usjImage1", "usjImage2", "usjImage3", "usjImage4", "usjImage5", "usjImage6", "usjImage7", "usjImage8", "usjImage9", "img1", "img2", "img3","img4", "img5", "img6", "atumori1"]
//
//    @Published var showPhotoViewer: Bool = false
//
//    @Published var selectedImageID: String = ""
//
//    @Published var photoViewerOffset: CGSize = .zero
//
//    @Published var bgOpacity: Double = 1
//
//    @Published var photoScale: CGFloat = 1
//
//    func onChange(value: CGSize) {
//
//        photoViewerOffset = value
//
//        let helgHeight = UIScreen.main.bounds.height / 2
//
//        let progress = photoViewerOffset.height / helgHeight
//
//        withAnimation(.default) {
//            bgOpacity = Double(1 - (progress < 0 ? -progress : progress))
//        }
//    }
//
//    func onEnd(value: DragGesture.Value) {
//        withAnimation(.easeOut) {
//            var translation = value.translation.height
//
//            if translation < 0 {
//                translation = -translation
//            }
//
//            if translation < 250 {
//                photoViewerOffset = .zero
//                bgOpacity = 1
//            } else {
//                showPhotoViewer.toggle()
//                photoViewerOffset = .zero
//                bgOpacity = 1
//            }
//
//        }
//    }
//}
//

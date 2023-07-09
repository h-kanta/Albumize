//
//  ContentView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/19.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var photoData: PhotoViewModel
    @StateObject var albumData: AlbumViewModel
    @StateObject var photoPicker: PhotoPickerViewModel
    
    var body: some View {
        BottomTabView(photoData: .init(), albumData: .init(), photoPicker: .init())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        let photo = PhotoModel()
//        ContentView(photoViewModel: .init(photo: photo))
        ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
    }
}


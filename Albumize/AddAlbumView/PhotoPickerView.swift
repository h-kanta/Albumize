//
//  PhotosPickerView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/09.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    
    @StateObject var alubmData: AlbumViewModel
    @StateObject var photoPicker: PhotoPickerViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
//                Color("Bg")
//                    .ignoresSafeArea()

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("キャンセル")
                        .foregroundColor(Color("Primary").opacity(0.8))
                        .font(.title3)
                        .onTapGesture {
                            photoPicker.isPhotoPickerShowing = false
                        }
                }
            }
            
        }
    }
}

struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerView(alubmData: .init(), photoPicker: .init())
    }
}

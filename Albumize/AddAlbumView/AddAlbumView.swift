//
//  AddAlbumView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/17.
//

import SwiftUI

struct AddAlbumView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var photoPicker: PhotoPickerViewModel
    @StateObject var albumData: AlbumViewModel
    // アルバム名入力テキスト
    @State var albumName: String = ""
    @State var photos: [Photo] = []
    
    @State private var gridColumns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 4)

    var body: some View {
        NavigationStack {
            ZStack {
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack {
                    // 上部メニュー
                    HStack {
                        // 戻るボタン
                        Button {
                            dismiss()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("戻る")
                            }
                            .font(.callout)
                            .foregroundColor(Color("Primary"))
                        }
                        
                        Spacer()
                        
                        // 追加ボタン
                        if albumName != "" {
                            Button {
                                albumData.albums.append(
                                    Album(
                                        name: albumName,
                                        createDate: "2023年7月18日",
                                        thumbnail: Image(uiImage: photoPicker.selectedPhotos[0].thumbnail!),
                                        photos: photos
                                    ))
                                photoPicker.selectedPhotos.removeAll()
                                photoPicker.isPhotoPickerShowing = false
    
    
                            } label: {
                                Text("追加")
                                    .font(.callout)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Primary"))
                            }
                        } else {
                            Text("追加")
                                .font(.callout)
                                .foregroundColor(Color("Primary").opacity(0.5))
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("アルバム名を入力してください。")
                            .foregroundColor(.black.opacity(0.6))
                        TextField("アルバム名", text: $albumName)
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: gridColumns, spacing: 4) {
                            ForEach(photoPicker.selectedPhotos) { photo in
                                if let thumbnail = photo.thumbnail {
                                    Rectangle()
                                        .overlay {
                                            Image(uiImage: thumbnail)
                                                .resizable()
                                                .scaledToFill()
                                        }
                                        .foregroundColor(Color("Bg"))
                                        .scaledToFit()
                                        .cornerRadius(3)
                                        .onAppear {
                                            photos.append(Photo(image: Image(uiImage: thumbnail)))
                                        }
                                }
                            }
                        }
                    }
                    .padding()
                    
                }
            }
            // ナビゲーションリンクの戻るボタンを非表示
            .navigationBarBackButtonHidden(true)
            // ナビゲーションバーなどの色設定
            .accentColor(Color("Primary").opacity(0.8))
        }
    }
}

struct AddAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
//        AddAlbumView()
    }
}

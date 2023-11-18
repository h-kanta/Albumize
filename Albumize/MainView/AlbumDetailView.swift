//
//  AlbumDetailView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/23.
//

import SwiftUI
import Kingfisher

struct AlbumDetailView: View {
    
    @StateObject var photoData: PhotoViewModel
    @StateObject var albumData: AlbumViewModel
    @Binding var album: Album
    
    @State private var gridColumns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 3)
    
    let deviceSize = UIScreen.main.bounds.size

    let cache = ImageCache.default
    let imageLoader = ImageLoader()
    @State var loadTask: Task<UIImage, Error>?

    var body: some View {
        NavigationStack {
            ZStack {
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            // アルバム名
                            Text(album.albumName)
                                .font(.title3)
                                .fontWeight(.bold)
                            // 作成日 - アルバム写真数
                            HStack(spacing: 3) {
                                Text(album.createdAt)
                                Text("-")
                                Text("\(album.photoCount) 写真")
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        FavoriteButtonView(album: $album)
                    }
                    .padding()
                    
                    ScrollView(showsIndicators: true) {
                        LazyVGrid(columns: gridColumns, spacing: 1) {
                            ForEach(album.photoUrls, id: \.self) { url in
//                                AsyncImage(url: url) { phase in
//                                    if let image = phase.image {
//                                        image
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: deviceSize.width/3-1, height: deviceSize.width/3-1)
//                                            .contentShape(Rectangle())
////                                            .matchedGeometryEffect(
////                                                id: photo.id,
////                                                in: photo.namespace,
////                                                isSource: !photoData.isSelectedPhoto
////                                            )
//                                            .clipped()
//                                            .onTapGesture {
//                                                withAnimation(.spring(response: 0.2, dampingFraction: 0.75)) {
//                                                    photoData.photos = album.photos
//                                                    photoData.photoPosition = .zero
//                                                    photoData.isSelectedPhoto = true
//                                                    //photoData.selectedPhotoID = photo.id
//                                                }
//                                            }
//                                    } else if let error = phase.error {
//                                        let error = error.localizedDescription
//                                        let _ = print(error) // デバッグ
//                                        Text(error)
//
//                                    } else {
//                                        ProgressView()
//                                            .frame(width: deviceSize.width/3-1, height: deviceSize.width/3-1)
//                                            .contentShape(Rectangle())
//                                            .background(.white)
//                                    }
//                                }
                                
//                                Rectangle()
//                                    .overlay {
//                                        photo.image
//                                            .resizable()
//                                            .scaledToFill()
//                                    }
//                                    .foregroundColor(.black)
//                                    .scaledToFit()
//                                    .cornerRadius(3)
//                                photo.image
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: deviceSize.width/3-1, height: deviceSize.width/3-1)
//                                    .contentShape(Rectangle())
//                                    .matchedGeometryEffect(
//                                        id: photo.id,
//                                        in: photo.namespace,
//                                        isSource: !photoData.isSelectedPhoto
//                                    )
//                                    .clipped()
//                                    .onTapGesture {
//                                        withAnimation(.spring(response: 0.2, dampingFraction: 0.75)) {
//                                            photoData.photos = album.photos
//                                            photoData.photoPosition = .zero
//                                            photoData.isSelectedPhoto = true
//                                            photoData.selectedPhotoID = photo.id
//                                        }
//                                    }

                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "ellipsis")
                        .fontWeight(.bold)
                }
            }
            .onAppear {
//                if (album.photoCount != album.photoUrls.count) {
//                    albumData.readAlbumPhoto(album: album) { urls in
//                        album.photoUrls = urls
//                    }
//                }
                
                for url in album.photoUrls {
                    print(url)
                }
            }
        }
    }
}

// MARK: プレビュー
struct AlbumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        //        ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
        ContentView()
    }
}

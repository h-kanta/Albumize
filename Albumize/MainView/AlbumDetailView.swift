//
//  AlbumDetailView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/23.
//

import SwiftUI
import CachedAsyncImage

struct AlbumDetailView: View {
    
    @StateObject var photoData: PhotoViewModel
    @StateObject var albumData: AlbumViewModel
    @Binding var album: Album
    // グリッドカラム
    @State private var gridColumns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 3)
    
    let deviceSize = UIScreen.main.bounds.size

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
                            ForEach(album.photos, id: \.self) { photo in
                                CachedAsyncImage(url: photo.imageUrl) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: deviceSize.width/3-5, height: deviceSize.width/3-5)
                                            .contentShape(Rectangle())
                                            .cornerRadius(10)
                                            .matchedGeometryEffect(
                                                id: photo.id,
                                                in: photo.namespace,
                                                isSource: !photoData.isSelectedPhoto
                                            )
                                            .clipped()
                                            .onTapGesture {
                                                withAnimation(.spring(response: 0.2, dampingFraction: 0.75)) {
                                                    photoData.photoUrls = album.photos
                                                    photoData.photoPosition = .zero
                                                    photoData.isSelectedPhoto = true
                                                    photoData.selectedPhotoID = photo.id
                                                }
                                            }
                                            .padding(.bottom, 4)
                                    } else {
                                        ProgressView()
                                            .frame(width: deviceSize.width/3-5, height: deviceSize.width/3-5)
                                            .contentShape(Rectangle())
                                            .cornerRadius(10)
                                            .background(.white)
                                    }
                                }
                            } // ForEach
                        } // LazyVGrid
                    } // ScrollView
                } // VStack
                .padding(.horizontal, 5)
            } // ZStack
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "ellipsis")
                        .fontWeight(.bold)
                }
            }
            .onAppear {

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


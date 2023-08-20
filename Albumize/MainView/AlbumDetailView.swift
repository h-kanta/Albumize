//
//  AlbumDetailView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/23.
//

import SwiftUI

struct AlbumDetailView: View {
    
    @StateObject var photoData: PhotoViewModel
    @Binding var album: Album
    
    @State private var gridColumns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 3)
    
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
                            Text(album.name)
                                .font(.title3)
                                .fontWeight(.bold)
                            // 作成日 - アルバム写真数
                            HStack(spacing: 3) {
                                Text(album.createDate)
                                Text("-")
                                Text("\(album.photos.count) 写真")
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        FavoriteButtonView(album: $album)
                    }
                    .padding()
                    
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            LazyVGrid(columns: gridColumns, spacing: 1) {
                                ForEach(album.photos) { photo in
//                                    Rectangle()
//                                        .overlay {
//                                            Image(photo.value)
//                                                .resizable()
//                                                .scaledToFill()
//                                        }
//                                        .foregroundColor(Color("Bg"))
//                                        .scaledToFit()
//                                        .cornerRadius(3)
                                    photo.image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: deviceSize.width/3-1, height: deviceSize.width/3-1)
                                        .contentShape(Rectangle())
                                        .matchedGeometryEffect(
                                            id: photo.id,
                                            in: photo.namespace,
                                            isSource: !photoData.isSelectedPhoto
                                        )
                                        .clipped()
                                        .onTapGesture {
                                            withAnimation(.spring(response: 0.2, dampingFraction: 0.75)) {
                                                photoData.photos = album.photos
                                                photoData.photoPosition = .zero
                                                photoData.isSelectedPhoto = true
                                                photoData.selectedPhotoID = photo.id
                                            }
                                        }
                                    
                                }
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
        }
    }
}

struct AlbumDetailView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
        ContentView()
    }
}

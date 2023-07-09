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
    
    @State private var gridColumns = Array(repeating: GridItem(.flexible(), spacing: 3), count: 3)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Bg")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(album.name)
                                .foregroundColor(Color("Primary"))
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Text(album.createDate)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        FavoriteButtonView(album: $album)
                    }
                    .padding([.top, .horizontal])
                    
                    ScrollView {
                        LazyVGrid(columns: gridColumns, spacing: 3) {
                            ForEach(album.photos) { photo in
                                Rectangle()
                                    .overlay {
                                        Image(photo.value)
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    .foregroundColor(Color("Bg"))
                                    .scaledToFit()
                                    .cornerRadius(3)
                                    .matchedGeometryEffect(
                                        id: photo.id,
                                        in: photo.namespace,
                                        isSource: !photoData.isSelectedPhoto
                                    )
                                    .onTapGesture {
                                        photoData.photos = album.photos
                                        photoData.photoPosition = .zero
//                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                        photoData.isSelectedPhoto = true
                                        photoData.selectedPhotoID = photo.id
//                                        }
                                    }
            
                            }
                        }
                        .padding(.vertical)
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
//        let photo = PhotoModel()
//        ContentView(photoViewModel: .init(photo: photo))
        ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
    }
}

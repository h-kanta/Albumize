//
//  AlbumView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/20.
//

import SwiftUI
import Foundation

// アルバム
struct AlbumView: View {
    
    @StateObject var photoData: PhotoViewModel
    @StateObject var albumData: AlbumViewModel
    @StateObject var userData: UserViewModel
    
    @State var searchText = ""
    
    let deviceWidth = UIScreen.main.bounds.width
//    @Binding var photos: [Photo]
//    @Binding var selectedPhoto: Photo?
//    @Binding var photoPosition: CGSize
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack {
                    Text("").frame(height: 0) // 空白を作るため
                    
                    ScrollView(showsIndicators: false) {
                        ZStack {
                            VStack(spacing: 10) {
                                LazyVStack {
                                    ForEach($albumData.albums) { album in
                                        ZStack {
                                            NavigationLink {
                                                AlbumDetailView(photoData: photoData, albumData: albumData, album: album)
                                            } label: {
                                                AlbumCardView(album: album)
                                            }
                                                
                                            FavoriteButtonView(album: album)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                                .padding()
                                            }
                                        }
                                    }
                                .padding([.horizontal, .bottom])
                            }
                            .zIndex(1)
                        }
                        
                    }
                }
            }
            .navigationBarTitle("アルバム", displayMode: .inline)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("アルバムを検索")
            )
        }
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
        //ContentView()
        MainView(userData: .init() ,photoData: .init(), albumData: .init(), photoPicker: .init())
    }
}

// アルバムカード
struct AlbumCardView: View {
    @Binding var album: Album
    
    let formatter = DateFormatter()
    
    var body: some View {
        ZStack {
            if album.photoUrls.count != 0 {
//                album.photos[0].image
//                    .resizable()
//                    .scaledToFill()
//                    .frame(height: 180, alignment: .center)
//                    .brightness(-0.3) // 明るさを調整
//                    .opacity(0.8) // 透明度を調整
//                    .cornerRadius(10)
                AsyncImage(url: album.photoUrls[0]) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180, alignment: .center)
                            .brightness(-0.3) // 明るさを調整
                            .opacity(0.8) // 透明度を調整
                            .cornerRadius(10)
                    } else if let error = phase.error {
                        Text(error.localizedDescription)
                    } else {
                        ProgressView()
                            .frame(height: 180, alignment: .center)
                            .brightness(-0.3) // 明るさを調整
                            .opacity(0.8) // 透明度を調整
                            .cornerRadius(10)
                    }
                }
                
                VStack(alignment: .leading) {
                    // アルバム名
                    Text(album.albumName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 3)
                    // 作成日 - アルバム写真数
                    HStack(spacing: 3) {
                        Text(album.createdAt)
                        Text(" - ")
                        Text("\(album.photoCount) 写真")
                    }
                    .font(.caption)
                }
                .padding()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding()
            }
        }
    }
}

// お気に入りボタン
struct FavoriteButtonView: View {
    @Binding var album: Album
    var body: some View {
        Image(systemName: album.isFavorited ? "suit.heart.fill" : "suit.heart")
            .font(.title2)
            .foregroundColor(Color("Sub"))
            .padding(8)
            .background(.white.opacity(0.8))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.10), radius: 5, x: 3, y: 3)
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    album.isFavorited.toggle()
                }
            }
    }
}

// 検索バー
//struct SearchBarView: View {
//    @State var searchText = ""
//    var body: some View {
//
//        HStack {
//            Image(systemName: "magnifyingglass")
//                .foregroundColor(Color("Primary"))
//
//            TextField("アルバムを検索", text: $searchText)
//                .submitLabel(.search)
//        }
//        .padding(4)
//        .background(.white)
//        .cornerRadius(10)
//    }
//}


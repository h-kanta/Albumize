//
//  AlbumView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/20.
//

import SwiftUI

// アルバム
struct AlbumView: View {
    
    @StateObject var photoData: PhotoViewModel
    @StateObject var albumData: AlbumViewModel
    
    @State var searchText = ""
    
    let deviceWidth = UIScreen.main.bounds.width
//    @Binding var photos: [Photo]
//    @Binding var selectedPhoto: Photo?
//    @Binding var photoPosition: CGSize
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Bg")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("").frame(height: 0) // 空白を作るため
                    
                    ScrollView {
//                        ZStack {
//                            VStack {
//                                HStack {
//                                    Spacer()
//
//                                    Button {
//                                    } label: {
//                                        Text("並び替え")
//
//                                        Image(systemName: "slider.vertical.3")
//                                            .font(.title2)
//                                            .fontWeight(.bold)
//                                    }
//                                    .foregroundColor(.black)
//                                    .padding(7)
//                                    .background(.white)
//                                    .cornerRadius(8)
//
//                                    Button {
//                                    } label: {
//                                        Text("編集")
//
//                                        Image(systemName: "square.and.pencil")
//                                            .font(.title2)
//                                            .fontWeight(.bold)
//                                    }
//                                    .foregroundColor(.black)
//                                    .padding(7)
//                                    .background(.white)
//                                    .cornerRadius(8)
//                                }
//                                .padding(.horizontal)
//                            }
//                        }
//                        .zIndex(2)
                        
                        ZStack {
                            VStack(spacing: 10) {
                                ForEach($albumData.albums) { album in
                                    ZStack {
                                        NavigationLink {
                                            AlbumDetailView(photoData: photoData, album: album)
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
            .navigationBarTitle("アルバム", displayMode: .inline)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("アルバムを選択")
            )
        }
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
//        let photo = PhotoModel()
//        ContentView(photoViewModel: PhotoViewModel(photo: photo))
        ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
    }
}

// アルバムカード
struct AlbumCardView: View {
    @Binding var album: Album
    var body: some View {
        ZStack {
            Image(album.thumbnail)
                .resizable()
                .scaledToFill()
                .frame(height: 180, alignment: .center)
                .brightness(-0.3) // 明るさを調整
                .opacity(0.8) // 透明度を調整
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(album.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.bottom, 3)
                Text(album.createDate)
                    .font(.caption)
            }
            .padding()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding()
        }
    }
}

// アルバムのお気に入りボタン
struct FavoriteButtonView: View {
    @Binding var album: Album
    var body: some View {
        Image(systemName: album.isFavorited ? "suit.heart.fill" : "suit.heart")
            .font(.title2)
            .foregroundColor(Color("Primary"))
            .padding(8)
            .background(.white.opacity(0.8))
            .cornerRadius(10)
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


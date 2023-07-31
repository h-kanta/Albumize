//
//  HomeView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/20.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var photoData: PhotoViewModel
    @StateObject var albumData: AlbumViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Bg")
                    .ignoresSafeArea()
                
//                VStack(alignment: .leading, spacing: 4) {
//
//                    if let album = albumData.albums.randomElement() {
//                        if let photo = album.photos.randomElement() {
//
//                            VStack(alignment: .leading, spacing: 0) {
//                                Text("アルバム名")
//                                    .font(.subheadline)
//                                    .foregroundColor(Color("Primary").opacity(0.8))
//                                    .padding(6)
//                                    .background(.white.opacity(0.5))
//                                    .cornerRadius(7)
//
//                                Text(album.name)
//                                    .font(.title3)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(Color("Primary"))
//                                    .padding(6)
//                                    .background(.white.opacity(0.5))
//                                    .cornerRadius(7)
//                            }
//                            .padding(.horizontal)
//
//                            photo.image
//                                .resizable()
//                                .scaledToFit()
//                                .border(Color("Primary"), width: 8)
//                                .cornerRadius(10)
//                                .padding()
//                        }
//                    }
//                }
//                .padding()
                
            }
            .navigationBarTitle("Albumize", displayMode: .inline)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
    }
}

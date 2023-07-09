//
//  BottomTabView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/20.
//

import SwiftUI
import PhotosUI

// 下部タブバー
struct BottomTabView: View {
    @StateObject var photoData: PhotoViewModel
    @StateObject var albumData: AlbumViewModel
    @StateObject var photoPicker: PhotoPickerViewModel
    // タブ
    @State var activeTab: Tab = .home
        
    var body: some View {
        ZStack {
            TabView(selection: $activeTab) {
                HomeView(photoData: photoData, albumData: albumData)
                    .tag(Tab.home)
                //                    .toolbar(.hidden, for: .tabBar)
                
                AlbumView(photoData: photoData, albumData: albumData)
                    .tag(Tab.album)
                
                PlanView()
                    .tag(Tab.plan)
                
                ProfileView()
                    .tag(Tab.profile)
            }
            
            CustomTabBar()
                .padding(.vertical, 20)
                .background(Color.white)
                .cornerRadius(8)
            //                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 0)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
            
            if photoData.isSelectedPhoto {
                PhotoView(photoData: photoData)
            }
        }
        // アルバム追加
        .fullScreenCover(isPresented: $photoPicker.isPhotoPickerShowing) {
            PhotoPickerView(alubmData: albumData, photoPicker: photoPicker)
        }
        
        // ナビゲーションバーなどの色設定
        .accentColor(Color("Primary").opacity(0.8))
    }
    
    // カスタムタブバー
    @ViewBuilder
    func CustomTabBar(_ tint: Color = .black, _ inactiveTint: Color = .black) -> some View {
        HStack(spacing: 0) {
            ForEach (Tab.allCases, id: \.rawValue) {
                TabItem(
                    photoPicker: photoPicker,
                    activeTab: $activeTab,
                    isPhotosPickerShowing: $photoPicker.isPhotoPickerShowing,
                    inactiveTint: inactiveTint,
                    tab: $0)
            }
        }
    }
}

// カスタムバーアイテム
struct TabItem: View {
    @State var photoPicker: PhotoPickerViewModel
    @Binding var activeTab: Tab
    @Binding var isPhotosPickerShowing: Bool
    var inactiveTint: Color
    var tab: Tab

    var body: some View {
        VStack(spacing: 2) {
            if tab.rawValue == "" {
                Image(systemName: tab.systemImage)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Primary"))
                    .scaleEffect(1.2)
                    .offset(y: -10)
                    .onTapGesture {
                        isPhotosPickerShowing = true
                    }
            } else {
                Image(systemName: tab.systemImage)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(activeTab == tab ? inactiveTint : .black.opacity(0.3))
                    .scaleEffect(activeTab == tab ? 1.1 : 1.0)
                    .offset(y: -5)
                
                Text(tab.rawValue)
                    .font(.caption)
                    .foregroundColor(activeTab == tab ? inactiveTint : .black.opacity(0.3))
                    .offset(y: -5)
            }
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            activeTab = tab
        }
    }
}

struct BottomTabView_Previews: PreviewProvider {
    static var previews: some View {
//        let photo = PhotoModel()
//        ContentView(photoViewModel: .init(photo: photo))
        ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
    }
}

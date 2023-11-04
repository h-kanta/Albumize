//
//  BottomTabView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/20.
//

import SwiftUI
import KRProgressHUD

// メイン画面
struct MainView: View {
    @StateObject var userData: UserViewModel
    @StateObject var photoData: PhotoViewModel
    @StateObject var albumData: AlbumViewModel
    @StateObject var photoPicker: PhotoPickerViewModel
    // 認証マネージャー
    @State var authManager = AuthManager()
    // タブ
    @State var activeTab: Tab = .home
    
    var body: some View {
        ZStack {
            TabView(selection: $activeTab) {
                // ホーム画面
                HomeView(photoData: photoData, albumData: albumData)
                    .tag(Tab.home)
                //                    .toolbar(.hidden, for: .tabBar)
                // アルバム画面
                AlbumView(photoData: photoData, albumData: albumData, userData: userData)
                    .tag(Tab.album)
                // 予定画面
                PlanView()
                    .tag(Tab.plan)
                // プロフィール画面１
                ProfileView()
                    .tag(Tab.profile)
            }

            // 下部タブバー
            CustomTabBar()
                .padding(.vertical, 23)
                .background(Color.white)
                .cornerRadius(8)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
            
            // 写真ビュー表示
            if photoData.isSelectedPhoto {
                PhotoView(photoData: photoData)
            }
        }
        // アルバム追加画面に遷移
        .fullScreenCover(isPresented: $photoPicker.isPhotoPickerShowing) {
            PhotoPickerView(alubmData: albumData,
                            photoPicker: photoPicker,
                            userData: userData)
        }
        // ナビゲーションバーなどの色設定
        .accentColor(.black.opacity(0.5))
        .onAppear {
            // ローディング表示
            withAnimation {
                KRProgressHUD.show(withMessage: "読み込み中...")
            }
            // ユーザー情報取得
            userData.loadUserInfo() { result in
                if (result) {
                    // アルバム情報取得
                    let collection = userData.userInfo.isInGroup ? "groups" : "users"
                    let id = userData.userInfo.isInGroup ? "" : userData.userInfo.id
                    albumData.loadAlbums(collection: collection, id: id) { result in
                        if result {
                            KRProgressHUD.dismiss()
                        }
                    }
                }
            }
        }
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

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
        //ContentView()
        MainView(userData: .init() ,photoData: .init(), albumData: .init(), photoPicker: .init())
    }
}

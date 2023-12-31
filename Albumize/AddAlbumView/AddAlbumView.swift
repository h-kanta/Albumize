//
//  AddAlbumView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/17.
//

import SwiftUI
import KRProgressHUD

struct AddAlbumView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var photoPicker: PhotoPickerViewModel
    @StateObject var albumData: AlbumViewModel
    @StateObject var userData: UserViewModel
    // アルバム名
    @State var albumName: String = ""
    // アルバム作成用写真
    @State var photos: [Image] = []
    // 4列グリッド
    @State private var gridColumns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 4)
    // エラーメッセージ
    @State var errMessage: String = ""
    // アラート表示フラグ
    @State var isShowingAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景
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
                            .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        // 追加ボタン
                        if albumName != "" {
                            Button {
                                withAnimation {
                                    KRProgressHUD.show(withMessage: "作成中...")
                                }
                                // フォルダ名を取得
                                let storageName = userData.userInfo.isInGroup ? "groups" : "users"
                                // グループID or ユーザーID取得
                                let id = userData.userInfo.isInGroup ? "" : userData.userInfo.id
                                // アルバムIDを取得
                                let albumId = "\(Int(Date().timeIntervalSince1970 * 1000))"
                                // 保存先のURL
                                let storageUrl = "/\(storageName)/\(id)/albums/\(albumId)/"
                                
                                // MARK: アルバム写真を保存
                                albumData.createAlbum(albumStorageUrl: storageUrl, albumPhotos: photoPicker.selectedPhotos, collection: storageName, id: id, albumId: albumId, name: albumName) { result in
                                    if result {
                                        // 選択した写真をクリア
                                        photoPicker.selectedPhotos.removeAll()
                                        // アルバム作成画面を閉じる
                                        photoPicker.isPhotoPickerShowing = false
                                        KRProgressHUD.dismiss()
                                    }
                                }
                                
                            } label: {
                                Text("作成")
                                    .font(.callout)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Primary"))
                            }
                        } else {
                            Text("作成")
                                .font(.callout)
                                .foregroundColor(.black.opacity(0.3))
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    // アルバム入力
                    VStack(alignment: .leading) {
                        Text("アルバム名を入力してください。")
                            .foregroundColor(.black.opacity(0.6))
                        TextField("アルバム名", text: $albumName)
                            .font(.title2)
                            .padding(10)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.10), radius: 5, x: 3, y: 3)
                    }
                    .padding()
                    
                    // 選択済み写真一覧
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
                                            photos.append(Image(uiImage: thumbnail))
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
            .accentColor(.black.opacity(0.5))
            // アラート（エラーメッセージ）表示
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text(errMessage))
            }
        }
    }
}

// MARK: プレビュー
struct AddAlbumView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
        ContentView()
    }
}

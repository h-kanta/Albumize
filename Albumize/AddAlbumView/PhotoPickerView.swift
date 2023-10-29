//
//  PhotosPickerView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/09.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @StateObject var alubmData: AlbumViewModel
    @StateObject var photoPicker: PhotoPickerViewModel
    @StateObject var userData: UserViewModel
    // グリッド
    @State private var gridColumns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 4)
    // デバイスサイズ
    let deviceSize = UIScreen.main.bounds.size
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        // キャンセルボタン
                        Button {
                            photoPicker.isPhotoPickerShowing = false
                        } label: {
                            Text("キャンセル")
                                .font(.callout)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        // 次へボタン
                        if photoPicker.selectedPhotos.isEmpty {
                            Text("次へ")
                                .font(.callout)
                                .foregroundColor(.black.opacity(0.3))
                        } else {
                            NavigationLink {
                                AddAlbumView(photoPicker: photoPicker,
                                             albumData: alubmData,
                                             userData: userData)
                            } label: {
                                Text("次へ")
                                    .font(.callout)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Primary"))
                            }
                        }
                    }
                    .padding()

                    ScrollView() {
                        // 写真ライブラリグリッド
                        LazyVGrid(columns: gridColumns, spacing: 1) {
                            ForEach($photoPicker.fetchedPhotos) { $photoAsset in
                                GridContent(photoAsset: photoAsset)
                                //                                if let thumbnail = photoAsset.thumbnail {
                                //                                    UIViewControllerImageView(image: thumbnail)
                                    .onAppear {
                                        if photoAsset.thumbnail == nil {
                                            let manager = PHCachingImageManager.default()
                                            manager.requestImage(for: photoAsset.asset, targetSize: CGSize(width: photoAsset.asset.pixelWidth, height: photoAsset.asset.pixelHeight), contentMode: .aspectFill, options: nil) { photo,
                                                _ in
                                                photoAsset.thumbnail = photo
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    
                    // 写真選択ガイド
                    VStack {
                        // 選択数テキスト
                        Text(photoPicker.selectedPhotos.isEmpty ? "写真を選択" :
                                "\(photoPicker.selectedPhotos.count)個を選択中")
                        .font(.callout)
                        .fontWeight(.semibold)

                        // 選択済みの写真一覧
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(photoPicker.selectedPhotos) { photo in
                                    if let thumbnail = photo.thumbnail {
                                        Image(uiImage: thumbnail)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(10)
                                            // ×ボタン
                                            .overlay(alignment: .topTrailing) {
                                                Image(systemName: "xmark")
                                                    .font(.system(size: 10))
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(.white)
                                                    .background(.black)
                                                    .clipShape(Circle())
                                                    .padding(3)
                                            }
                                            .onTapGesture {
                                                withAnimation(.linear(duration: 0.3)) {
                                                    if let index = photoPicker.selectedPhotos.firstIndex(where: {
                                                        $0.id == photo.id
                                                    }) {
                                                        photoPicker.selectedPhotos.remove(at: index)
                                                        photoPicker.selectedPhotos.enumerated().forEach { photo in
                                                            photoPicker.selectedPhotos[photo.offset].assetIndex = photo.offset
                                                        }
                                                    }
                                                }
                                                
                                            }
                                    }
                                }
                            }
                            .padding(3)
                            .padding(.bottom)
                        }
                    }
                    .padding()
                    .background(.white)
                    
                }
                .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: -3)
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .accentColor(Color("Primary").opacity(0.8))
    }
    
    // 写真ライブラリグリッド
    @ViewBuilder
    func GridContent(photoAsset: PhotoAssetModel) -> some View {
        // 選択中の写真の場合は、写真のインデックスを取得
        let selectedPhotoIndex = photoPicker.selectedPhotos.firstIndex(where: {
            $0.id == photoAsset.id
        })
        
        ZStack {
            // 写真
            if let thumbnail = photoAsset.thumbnail {
                if selectedPhotoIndex != nil {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                        .frame(width: deviceSize.width/4-1, height: deviceSize.width/4-1)
                        .contentShape(Rectangle())
                        .overlay {
                            Rectangle()
                                .foregroundColor(.black.opacity(0.5))
                        }
                } else {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                        .frame(width: deviceSize.width/4-1, height: deviceSize.width/4-1)
                        .contentShape(Rectangle())
                }
            } else {
                ProgressView()
            }
            
            // 選択数
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.black.opacity(0.3))
                
                Circle()
                    .fill(.white.opacity(0.25))
                Circle()
                    .stroke(.white, lineWidth: 1)
                
                if let selectedPhotoIndex {
                    Circle()
                        .fill(Color("Primary"))
                    
                    Text("\(photoPicker.selectedPhotos[selectedPhotoIndex].assetIndex + 1)")
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                }
            }
            .frame(width: 20, height: 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(5)
        }
        .clipped()
        
        .onTapGesture {
            // タップ時、選択されていない写真は選択状態にする
            withAnimation(.linear(duration: 0.3)) {
                if let selectedPhotoIndex {
                    photoPicker.selectedPhotos.remove(at: selectedPhotoIndex)
                    photoPicker.selectedPhotos.enumerated().forEach { photo in
                        photoPicker.selectedPhotos[photo.offset].assetIndex = photo.offset
                    }
                } else {
                    var newAsset = photoAsset
                    newAsset.isSelected = true
                    newAsset.assetIndex = photoPicker.selectedPhotos.count
                    photoPicker.selectedPhotos.append(newAsset)
                }
            }
        }
    }
        
}


//struct UIViewControllerImageView: UIViewControllerRepresentable {
//    class ImageViewController: UIViewController {
//        private let image: UIImage
//        var imageView: UIImageView!
//
//        init(image: UIImage) {
//            self.image = image
//            super.init(nibName: nil, bundle: nil)
//        }
//
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//
//            imageView = UIImageView(image: image)
//            imageView.contentMode = .scaleAspectFill
//            imageView.frame = view.bounds
//            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            view.addSubview(imageView)
//        }
//    }
//
//    let image: UIImage
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        ImageViewController(image: image)
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        guard let imageViewController = uiViewController as? ImageViewController else {
//            return
//        }
//        imageViewController.imageView.image = image
//    }
//}

// MARK: プレビュー
struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerView(alubmData: .init(), photoPicker: .init(), userData: .init())
    }
}


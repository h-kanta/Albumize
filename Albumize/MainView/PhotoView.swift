//
//  PhotoView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/25.
//

import SwiftUI

struct PhotoView: View {
    // PhotoModel
    @StateObject var photoData: PhotoViewModel
    //
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    
    var body: some View {
        ZStack {
            Color("Bg")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .opacity(!photoData.isSelectedPhoto ? 0 : min(1, max(0, 1 - abs(Double(photoData.photoPosition.height) / 800))))
            
            TabView(selection: $photoData.selectedPhotoID) {
                ForEach(photoData.photos) { photo in
                    Image(photo.value)
                        .resizable()
                        .scaledToFit()
                        .tag(photo.id)
                        .matchedGeometryEffect(
                            id: photoData.selectedPhotoID,
                            in: photo.namespace,
                            isSource: photoData.isSelectedPhoto
                        )
                        .offset(photoData.photoPosition)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged{ value in
                        photoData.photoPosition.height = value.translation.height
                    }.onEnded{ value in
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.75)) {
                            if 100 < abs(photoData.photoPosition.height) {
                                photoData.isSelectedPhoto = false
                                photoData.selectedPhotoID = .init()
                            } else {
                                photoData.photoPosition = .zero
                            }
                        }
                    }
            )
            .onTapGesture {
//              photoViewModel.isSelectedPhoto = false
//              photoViewModel.selectedPhotoID = .init()
                // TabViewでカルーセルが機能するように記載
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .overlay(alignment: .topTrailing) {
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        photoData.isSelectedPhoto = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Primary"))
                }
                .padding()
                .padding(.top, windowScene?.windows.first?.safeAreaInsets.top)
                .opacity(!photoData.isSelectedPhoto ? 0 : min(1, max(0, 1 - abs(Double(photoData.photoPosition.height) / 800))))
            }
            .edgesIgnoringSafeArea(.all)
            .ignoresSafeArea()
        }
    }
    
    
//    @EnvironmentObject var photoData: Photo
//    @GestureState var draggingOffset: CGSize = .zero
    
//    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    
//    var body: some View {
//        ZStack {
//            TabView(selection: $photoData.selectedImageID) {
//                ForEach(photoData.images, id: \.self) { image in
//                    Image(image)
//                        .resizable()
//                        .scaledToFit()
//                        .tag(image)
//                        .scaleEffect(photoData.selectedImageID == image ? (photoData.photoScale > 1 ? photoData.photoScale : 1) : 1)
//                        .offset(y: photoData.photoViewerOffset.height)
//                        .gesture(
//                            MagnificationGesture().onChanged({ value in
//                                photoData.photoScale = value
//                            }).onEnded({ _ in
//                                withAnimation(.spring()) {
//                                    photoData.photoScale = 1
//                                }
//                            })
//                            .simultaneously(with: TapGesture(count: 2).onEnded({
//                                withAnimation {
//                                    photoData.photoScale = photoData.photoScale > 1 ? 1 : 4
//                                }
//                            }))
//                        )
//                }
//            }
//            // 点
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
//            .overlay(alignment: .topLeading) {
//                Button {
//                    withAnimation(.default) {
//                        photoData.showPhotoViewer.toggle()
//                    }
//                } label: {
//                    Image(systemName: "xmark")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .foregroundColor(Color("Primary"))
//                }
//                .padding()
//                .padding(.top, windowScene?.windows.first?.safeAreaInsets.top)
//                .opacity(photoData.bgOpacity)
//            }
//            .edgesIgnoringSafeArea(.all)
//        }
//        .gesture(DragGesture().updating($draggingOffset, body: { (value, outValue, _) in
//            outValue = value.translation
//            photoData.onChange(value: draggingOffset)
//
//        }).onEnded(photoData.onEnd(value:)))
//        .transition(.move(edge: .bottom))
//    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
//        let photo = PhotoModel()
//        ContentView(photoViewModel: .init(photo: photo))
        ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
    }
}

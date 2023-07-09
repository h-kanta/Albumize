////
////  AlbumDetailView.swift
////  Mepho
////
////  Created by 堀川貫太 on 2023/06/08.
////
//
//import SwiftUI
//
//struct AlbumDetailView: View {
//    // App の PhotoDataModel にアクセス
//    // @EnvironmentObject: 環境オブジェクトにアクセスできる。
//    @EnvironmentObject var photoDataModel: PhotoDataModel
//
//    var imageArray1 = ["usjImage1", "usjImage2", "usjImage3","atumori1", "usjImage4", "usjImage5", "usjImage6", "usjImage7", "usjImage8", "usjImage9", "img1", "img2", "img3", "img4", "img5", "img6"]
//
//    private static let initialColumns = 3
//    @State private var numColumns = initialColumns
////    @State private var gridColumns = Array(repeating: GridItem(.flexible(), spacing: 3), count: initialColumns)
//    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: initialColumns)
//
//    @State private var selectedTab = 0
//    var list: [String] = ["写真", "動画"]
//
//    @State private var isShowPhotoModal = false
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                
////                Stepper("", value: $numColumns, in: 1...4, step: 1) { _ in
////                    withAnimation { gridColumns = Array(repeating: GridItem(.flexible()), count: numColumns) }
////                }
////                .padding()
//
//                HStack(spacing: 0) {
//                    Button {
//                        numColumns = 1
//                        withAnimation { gridColumns = Array(repeating: GridItem(.flexible()), count: numColumns) }
//                    } label: {
//                        Image(systemName: numColumns == 1 ? "rectangle.grid.1x2.fill" : "rectangle.grid.1x2")
//                            .foregroundColor(Color("subColor"))
//                            .padding(7)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 4)
//                                    .stroke(Color("subColor"), lineWidth: 1.0)
//                            )
//                    }
//                    Button {
//                        numColumns = 2
//                        withAnimation { gridColumns = Array(repeating: GridItem(.flexible()), count: numColumns) }
//                    } label: {
//                        Image(systemName: numColumns == 2 ? "square.grid.2x2.fill" : "square.grid.2x2")
//                            .foregroundColor(Color("subColor"))
//                            .padding(7)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 4)
//                                    .stroke(Color("subColor"), lineWidth: 1.0)
//                            )
//                    }
//                    Button {
//                        numColumns = 3
//                        withAnimation { gridColumns = Array(repeating: GridItem(.flexible()), count: numColumns) }
//                    } label: {
//                        Image(systemName: numColumns == 3 ? "rectangle.grid.3x2.fill" : "rectangle.grid.3x2")
//                            .foregroundColor(Color("subColor"))
//                            .padding(7)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 4)
//                                    .stroke(Color("subColor"), lineWidth: 1.0)
//                            )
//                    }
//
//                    Spacer()
//                }
//                .font(.title3)
//                .padding([.top, .leading, .trailing])
//
//                TopTabView(list: list, selectedTab: $selectedTab)
//
//                ScrollView {
//                    LazyVGrid(columns: gridColumns) {
//                        ForEach($photoDataModel.photoItems) { $photoItem in
//
////                            NavigationLink {
////                                PhotoDetailView(photoItem: $photoItem)
////                            } label: {
////                                Rectangle()
////                                    .overlay {
////                                        PhotoGridItemView(photoItem: photoItem)
////                                    }
////                            }
////                            .cornerRadius(15)
////                            .aspectRatio(contentMode: .fit)
//
//                            Rectangle()
//                                .overlay {
//                                    PhotoGridItemView(photoItem: photoItem)
//                                }
//                                .cornerRadius(8)
//                                .aspectRatio(contentMode: .fit)
//                        }
//                    }
//                    .padding()
//                }
//            }
//            .navigationBarTitle("ユニバーサル・スタジオ・ジャパン", displayMode: .inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//
//                    }, label: {
//                        Image(systemName: "ellipsis.circle")
//                            .foregroundColor(Color("subColor"))
//                            .font(.title2)
//                    })
//                }
//            }
//        }
//    }
//}
//
//extension View {
//    func GridWidthResize(_ num: Int) -> some View {
//        switch(num) {
//        case 1:
//            return aspectRatio(contentMode: .fill)
//        default:
//            return aspectRatio(contentMode: .fit)
//        }
//    }
//}
//
////struct AlbumDetailView_Previews: PreviewProvider {
////    static var previews: some View {
////        AlbumDetailView()
////            .environmentObject(PhotoDataModel())
////    }
////}

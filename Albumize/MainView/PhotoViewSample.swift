//
//  PhotoViewSample.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/11/19.
//

import SwiftUI

struct PhotoViewSample: View {
    var body: some View {
//        Image("kuma")
//            .resizable()
//            .scaledToFit()
//            .ignoresSafeArea()
        GeometryReader { proxy in
//            Image("hari1")
            Image("kuma")
                .resizable()
                .scaledToFit()
                .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea()
    }
}

struct PhotoViewSample_Previews: PreviewProvider {
    static var previews: some View {
        PhotoViewSample()
    }
}

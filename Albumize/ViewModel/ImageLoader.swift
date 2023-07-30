//
//  ImageLoader.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/12.
//

import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    func loadImage(from image: UIImage) {
        DispatchQueue.global().async {
//            if let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
//            }
        }
    }
    

}







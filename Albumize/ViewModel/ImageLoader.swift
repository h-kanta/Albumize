//
//  ImageLoader.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/11/08.
//

import Foundation
import UIKit

public enum LoadingImage {
    case cached(UIImage)
    case inProgress(Task<UIImage, any Error>)
}

public struct InvalidImageDataError: Error {
    public var url: URL
    public init(url: URL) {
        self.url = url
    }
}

public final class ImageLoader {
    private let session: URLSession
    private let memoryCache = NSCache<NSURL, UIImage>()
    
    public init() {
        let configuration = URLSessionConfiguration.default
        let cacheDirectoryURL: URL?
        do {
            let systemCahceURL = try FileManager.default.url(for: .cachesDirectory,
                                                             in: .userDomainMask,
                                                             appropriateFor: nil,
                                                             create: true)
            cacheDirectoryURL = systemCahceURL.appendingPathComponent("AlbumizeImageLoader", isDirectory: true)
        } catch {
            assertionFailure("Could not create path: \(error)")
            cacheDirectoryURL = nil
        }
        
        // デフォルトでは'URLCache.shared'が使われるが、もう少しディスク容量を使える画像専用のを使う。
        configuration.urlCache = URLCache (
            // 'memoryCapacity'は試した限り 0 でも問題なく動きそうだが、一応念の為少しのメモリを割り当てる。
            memoryCapacity: URLCache.shared.memoryCapacity,
            diskCapacity: URLCache.shared.diskCapacity,
            directory: cacheDirectoryURL
        )
        session = .init(configuration: configuration)
    }
}

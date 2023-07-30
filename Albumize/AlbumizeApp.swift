//
//  AlbumizeApp.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/19.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct AlbumizeApp: App {
//    let photo = Photo()
//    let album = Album()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            ContentView(photoViewModel: .init(photo: photo))
            ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
        }
    }
}


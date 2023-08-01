//
//  ContentView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/19.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    var body: some View {
        MainView(photoData: .init(), albumData: .init(), photoPicker: .init())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView(photoData: .init(), albumData: .init(), photoPicker: .init())
        ContentView()
    }
}


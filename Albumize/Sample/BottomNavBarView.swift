//
//  BottomNavBarView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/20.
//

import SwiftUI

struct BottomNavBarView: View {
    var body: some View {
        HStack {
            BottomNavBarItem(image: Image(systemName: "house")) {}
            BottomNavBarItem(image: Image(systemName: "person.2.square.stack")) {}
            BottomNavBarItem(image: Image(systemName: "list.bullet.rectangle")) {}
            BottomNavBarItem(image: Image(systemName: "person")) {}
        }
        .padding()
        .background(Color.white)
        .clipShape(Capsule())
        .padding(.horizontal)
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 2, y: 6)
        .frame(maxHeight: .infinity, alignment: .bottom)
//        .edgesIgnoringSafeArea(.all)
    }
}

struct BottomNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavBarView()
    }
}

struct BottomNavBarItem: View {
    let image: Image
    let action: () -> Void
    var body: some View {
        Button(action: action, label: {
            image
                .foregroundColor(.black.opacity(0.4))
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
        })
    }
}

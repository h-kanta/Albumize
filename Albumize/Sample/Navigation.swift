//
//  Navigation.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/20.
//

import SwiftUI

struct Navigation: View {
    var body: some View {
        NavigationStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationBarTitle("PhotoAlbum", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Mepho")
                            .font(.title)
                            .foregroundColor(Color("subColor"))
                    }
                }
        }

    }
}

struct Navigation_Previews: PreviewProvider {
    static var previews: some View {
        Navigation()
    }
}

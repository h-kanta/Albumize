//
//  serach.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/20.
//

import SwiftUI

struct serach: View {
    
    @State var searchText = ""
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color("Primary"))
            TextField("アルバムを検索", text: $searchText)
                .submitLabel(.search) // キーボードの改行を検索に変更
        }
        .padding(8)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black, lineWidth: 1)
        )
        .padding([.leading, .trailing, .bottom])
    }
}

struct serach_Previews: PreviewProvider {
    static var previews: some View {
        serach()
    }
}

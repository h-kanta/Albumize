//
//  UserView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/20.
//

import SwiftUI

struct ProfileView: View {
    
    var body: some View {
        ZStack {
            Color("Bg")
                .ignoresSafeArea()
            
            Text("user")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

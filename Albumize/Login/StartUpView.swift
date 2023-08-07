//
//  StartUpView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/08/04.
//

import SwiftUI

struct StartUpView: View {
    @State var loginAuthIsPresented: Bool = false
    @State var entryAuthIsPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Bg")
                    .ignoresSafeArea()
                
                VStack() {
                    Text("Albumize")
                        .font(.largeTitle)
                        .foregroundColor(Color("Primary"))
                        .padding(50)
                    
                    VStack(spacing: 40) {
                        ButtonView(text: "ログインはこちらから", color: Color("Primary"))
                            .onTapGesture {
                                loginAuthIsPresented = true
                            }
                        
                        ButtonView(text: "新規登録はこちらから", color: Color("Sub"))
                            .onTapGesture {
                                entryAuthIsPresented = true
                            }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            // ログイン画面表示
            .sheet(isPresented: $loginAuthIsPresented) {
                LoginAuthView(loginAuthIsPresented: $loginAuthIsPresented)
            }
            // 新規登録画面表示
            .sheet(isPresented: $entryAuthIsPresented) {
                EntryAuthView(entryAuthIsPresented: $entryAuthIsPresented)
            }
        }
    }
}

struct StartUpView_Previews: PreviewProvider {
    static var previews: some View {
        StartUpView()
    }
}

struct ButtonView: View {
    var text: String
    var color: Color
    var body: some View {
        Text(text)
            .padding()
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(color)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.10), radius: 5, x: 3, y: 3)
    }
}

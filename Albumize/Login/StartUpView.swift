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
                
                VStack {
                    // アイコン画像
                    Image("Icon")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                    //
                    VStack(spacing: 5) {
                        Text("ようこそ！")
                            .font(.title3)
                        HStack(spacing: 5) {
                            Text("Albumize")
                                .font(.title)
                                .foregroundColor(Color("Primary"))
                            Text("へ！")
                                .font(.title3)
                        }
                    }
                    .padding(.bottom)
                    
                    // ログイン or 新規登録ボタン
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
                    .padding(.top)
                    
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

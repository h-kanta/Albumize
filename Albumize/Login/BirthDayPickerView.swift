//
//  BirthDayPickerView.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/09/03.
//

import SwiftUI

// 生年月日ピッカーダイアログ
struct BirthDayPickerView: View {
    // 生年月日
    @Binding var birth: String
    // ダイアログ表示フラグ
    @Binding var isShowingPickerDialog: Bool
    // 生年月日入力用
    @State var birthYear: Int = 2000
    @State var birthMonth: Int = 1
    @State var birthDay: Int = 1
    
    var body: some View {
        NavigationStack {
            HStack {
                Picker("年", selection: $birthYear) {
                    ForEach(1900..<2100, id: \.self) { year in
                        Text("\(year)年").tag(year)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
                
                Picker("月", selection: $birthMonth) {
                    ForEach(1..<13, id: \.self) { month in
                        Text("\(month)月").tag(month)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
                
                Picker("日", selection: $birthDay) {
                    ForEach(1..<32, id: \.self) { day in
                        Text("\(day)日").tag(day)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100)
            }
            .navigationBarTitle("生年月日", displayMode: .inline)
            // OKボタン
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("OK")
                        .font(.title2)
                        .onTapGesture {
                            birth = "\(birthYear)年\(birthMonth)月\(birthDay)日"
                            isShowingPickerDialog = false
                        }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

struct BirthDayPickerView_Previews: PreviewProvider {
    static var previews: some View {
        @State var birth: String = "yyyy年MM月dd日"
        @State var isShowingPickerDialog: Bool = true
        BirthDayPickerView(birth: $birth, isShowingPickerDialog: $isShowingPickerDialog)
    }
}

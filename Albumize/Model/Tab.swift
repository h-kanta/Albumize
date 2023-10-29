//
//  Tab.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/06/20.
//

import SwiftUI

// 下部タブバー用
enum Tab: String, CaseIterable {
    case home = "ホーム"
    case album = "アルバム"
    case plus = ""
    case plan = "予定"
    case profile = "アカウント"
    
    // タブアイコン
    var systemImage: String {
        switch self {
        case .home:
            return "house.fill"
        case .album:
            return "person.2.square.stack.fill"
        case .plus:
            return "plus.app.fill"
        case .plan:
            return "list.bullet.rectangle"
        case .profile:
            return "person.fill"
        }
    }
}

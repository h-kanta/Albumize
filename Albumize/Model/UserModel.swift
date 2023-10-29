//
//  UserModel.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/08/20.
//

import SwiftUI

struct User: Identifiable {
    var id: String = ""
    var name: String = ""
    var gender: String = ""
    var email: String = ""
    var birthday: String = ""
    var profileImageUrl: String = ""
    var isInGroup: Bool = false
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
}


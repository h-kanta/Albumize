//
//  UserModel.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/08/20.
//

import SwiftUI

struct User: Identifiable {
    let id: UUID = .init()
    var name: String = ""
    var email: String = ""
    var imageURL: String = ""
    var createdAt: Date = .init()
    var updatedAt: Date = .init()
}

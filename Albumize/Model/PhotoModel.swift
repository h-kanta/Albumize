//
//  PhotoModel.swift
//  Albumize
//
//  Created by 堀川貫太 on 2023/07/02.
//

import SwiftUI

struct Photo: Identifiable {
    let id: UUID = .init()
    let namespace: Namespace.ID = Namespace().wrappedValue
    var value: String = ""
}

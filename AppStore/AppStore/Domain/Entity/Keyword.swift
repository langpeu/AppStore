//
//  Keyword.swift
//  AppStore
//
//  Created by Langpeu on 12/28/25.
//

import Foundation
import SwiftData

@Model
final class Keyword: Identifiable {
    var title: String
    var date: Date
    
    init(title: String, date: Date) {
        self.title = title
        self.date = date
    }
}

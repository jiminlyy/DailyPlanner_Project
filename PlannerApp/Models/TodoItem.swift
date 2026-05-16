//
//  TodoItem.swift
//  PlannerApp
//
//  Created by 이지민 on 5/16/26.
//

import Foundation

struct TodoItem: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var isDone: Bool
    var colorHex: String   // 시간표에 칠할 색

    init(id: UUID = UUID(), title: String = "", isDone: Bool = false, colorHex: String = "#A8D8EA") {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.colorHex = colorHex
    }
}

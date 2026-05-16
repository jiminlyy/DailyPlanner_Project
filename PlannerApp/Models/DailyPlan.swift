//
//  DailyPlan.swift
//  PlannerApp
//
//  Created by 이지민 on 5/16/26.
//

import Foundation

/// 하루치 데이터
struct DailyPlan: Codable {
    var date: Date                          // 그날 (자정 기준)
    var todos: [TodoItem]                   // 왼쪽 리스트 (최대 24개 정도)
    var timetable: [[UUID?]]                // [24시간][10분 6칸] = TodoItem.id 매핑
    var summary: String                     // 일기

    static func empty(for date: Date) -> DailyPlan {
        let palette = ColorPalette.todoColors
        let todos = (0..<24).map { i in
            TodoItem(colorHex: palette[i % palette.count])
        }
        return DailyPlan(
            date: Calendar.current.startOfDay(for: date),
            todos: todos,
            timetable: Array(repeating: Array(repeating: nil, count: 6), count: 24),
            summary: ""
        )
    }
}

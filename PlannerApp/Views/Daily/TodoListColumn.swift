//
//  TodoListColumn.swift
//  PlannerApp
//
//  Created by 이지민 on 5/16/26.
//

import SwiftUI

struct TodoListColumn: View {
    let date: Date
    @Environment(PlannerStore.self) private var store

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("SCHEDULE & TO DO")
                .font(.caption).bold().foregroundStyle(.secondary)

            let plan = store.plan(for: date)
            ForEach(plan.todos.indices, id: \.self) { i in
                TodoRow(date: date, index: i)
            }
        }
    }
}

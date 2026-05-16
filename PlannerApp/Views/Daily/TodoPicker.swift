//
//  TodoPicker.swift
//  PlannerApp
//
//  Created by 이지민 on 5/16/26.
//

import SwiftUI

struct TodoPicker: View {
    let date: Date
    @Binding var selected: UUID?
    @Environment(PlannerStore.self) private var store

    var body: some View {
        let plan = store.plan(for: date)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                Button { selected = nil } label: {
                    Text("지우개").font(.caption2)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(selected == nil ? .gray.opacity(0.3) : .clear)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                ForEach(plan.todos.indices.filter { !plan.todos[$0].title.isEmpty }, id: \.self) { i in
                    let todo = plan.todos[i]
                    let isActive = (selected == todo.id)
                    Button { selected = todo.id } label: {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color(hex: todo.colorHex))
                                .frame(width: 8, height: 8)
                            Text(todo.title)
                                .font(.caption2).lineLimit(1)
                                .foregroundStyle(isActive ? .white : .primary)
                        }
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(isActive ? Color(hex: todo.colorHex) : .clear)
                        .overlay(
                            Capsule().strokeBorder(Color(hex: todo.colorHex), lineWidth: isActive ? 0 : 1)
                        )
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

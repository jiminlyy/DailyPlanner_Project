//
//  TodoRow.swift
//  PlannerApp
//
//  Created by 이지민 on 5/16/26.
//

import SwiftUI

struct TodoRow: View {
    let date: Date
    let index: Int
    @Environment(PlannerStore.self) private var store

    var body: some View {
        var plan = store.plan(for: date)
        let item = plan.todos[index]

        HStack(spacing: 8) {
            // 색깔 표시 (탭하면 색 변경)
            Circle()
                .fill(Color(hex: item.colorHex))
                .frame(width: 14, height: 14)
                .onTapGesture {
                    plan.todos[index].colorHex = nextColor(after: item.colorHex)
                    store.update(plan)
                }

            // 체크박스
            Image(systemName: item.isDone ? "checkmark.square.fill" : "square")
                .onTapGesture {
                    plan.todos[index].isDone.toggle()
                    store.update(plan)
                }

            // 텍스트 입력
            TextField("", text: Binding(
                get: { item.title },
                set: { newValue in
                    plan.todos[index].title = newValue
                    store.update(plan)
                }
            ))
            .font(.footnote)
        }
        .frame(height: 24)
        .overlay(
            Rectangle().frame(height: 0.5).foregroundStyle(.gray.opacity(0.3)),
            alignment: .bottom
        )
    }

    private func nextColor(after hex: String) -> String {
        let palette = ColorPalette.todoColors
        let idx = palette.firstIndex(of: hex) ?? 0
        return palette[(idx + 1) % palette.count]
    }
}

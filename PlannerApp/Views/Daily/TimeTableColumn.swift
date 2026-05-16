//
//  TimeTableColumn.swift
//  PlannerApp
//
//  Created by 이지민 on 5/16/26.
//

import SwiftUI

struct TimeTableColumn: View {
    let date: Date
    @Environment(PlannerStore.self) private var store
    @State private var selectedTodoID: UUID? = nil
    @State private var lastPainted: PaintedCell? = nil

    private let labelWidth: CGFloat = 24
    private let rowHeight: CGFloat = 24
    private let rowCount = 24
    private let slotCount = 6

    private struct PaintedCell: Equatable {
        let hour: Int
        let slot: Int
    }

    var body: some View {
        let plan = store.plan(for: date)

        VStack(alignment: .leading, spacing: 6) {
            Text("TIME TABLE")
                .font(.caption).bold().foregroundStyle(.secondary)

            TodoPicker(date: date, selected: $selectedTodoID)

            // 임시 디버그: 현재 칠하기 모드 표시
            if let id = selectedTodoID,
               let todo = plan.todos.first(where: { $0.id == id }) {
                HStack(spacing: 4) {
                    Circle().fill(Color(hex: todo.colorHex)).frame(width: 8, height: 8)
                    Text("칠하는 중: \(todo.title)").font(.caption2).foregroundStyle(.secondary)
                }
            } else {
                Text("지우개 모드").font(.caption2).foregroundStyle(.secondary)
            }

            GeometryReader { geo in
                let cellWidth = (geo.size.width - labelWidth) / CGFloat(slotCount)

                VStack(spacing: 0) {
                    ForEach(0..<rowCount, id: \.self) { hour in
                        HStack(spacing: 0) {
                            Text(String(format: "%02d", hour))
                                .font(.caption2)
                                .frame(width: labelWidth, alignment: .leading)

                            ForEach(0..<slotCount, id: \.self) { slot in
                                let todoID = plan.timetable[hour][slot]
                                let color = colorFor(todoID: todoID, plan: plan)

                                Rectangle()
                                    .fill(color)
                                    .frame(height: rowHeight)
                                    .overlay(Rectangle().stroke(.gray.opacity(0.3), lineWidth: 0.5))
                            }
                        }
                    }
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            paintAt(location: value.location, cellWidth: cellWidth)
                        }
                        .onEnded { _ in
                            lastPainted = nil
                        }
                )
            }
            .frame(height: rowHeight * CGFloat(rowCount))
        }
    }

    private func colorFor(todoID: UUID?, plan: DailyPlan) -> Color {
        guard let id = todoID,
              let todo = plan.todos.first(where: { $0.id == id }) else {
            return .white
        }
        return Color(hex: todo.colorHex)
    }

    private func paintAt(location: CGPoint, cellWidth: CGFloat) {
        let x = location.x - labelWidth
        let y = location.y
        guard x >= 0, y >= 0, cellWidth > 0 else { return }
        let slot = Int(x / cellWidth)
        let hour = Int(y / rowHeight)
        guard (0..<rowCount).contains(hour), (0..<slotCount).contains(slot) else { return }

        let cell = PaintedCell(hour: hour, slot: slot)
        if lastPainted == cell { return }   // 같은 칸 연속 처리 방지
        lastPainted = cell
        paint(hour: hour, slot: slot)
    }

    private func paint(hour: Int, slot: Int) {
        var plan = store.plan(for: date)
        if let id = selectedTodoID,
           plan.todos.contains(where: { $0.id == id }) {
            plan.timetable[hour][slot] = id
        } else {
            plan.timetable[hour][slot] = nil   // 지우개
        }
        store.update(plan)
    }
}

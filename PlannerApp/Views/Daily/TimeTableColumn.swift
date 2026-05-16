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

            GeometryReader { geo in
                let cellWidth = (geo.size.width - labelWidth) / CGFloat(slotCount)

                VStack(spacing: 0) {
                    ForEach(0..<rowCount, id: \.self) { hour in
                        HStack(spacing: 0) {
                            Text(String(format: "%02d", hour))
                                .font(.caption2)
                                .frame(width: labelWidth, alignment: .leading)

                            ForEach(0..<slotCount, id: \.self) { slot in
                                cell(hour: hour, slot: slot, plan: plan)
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

    @ViewBuilder
    private func cell(hour: Int, slot: Int, plan: DailyPlan) -> some View {
        let todoID = plan.timetable[hour][slot]
        let todo = todoID.flatMap { id in plan.todos.first(where: { $0.id == id }) }
        let color = todo.map { Color(hex: $0.colorHex) } ?? .white

        Rectangle()
            .fill(color)
            .frame(height: rowHeight)
            .overlay(Rectangle().stroke(.gray.opacity(0.3), lineWidth: 0.5))
            .overlay {
                if let title = todo?.title,
                   !title.isEmpty,
                   isMiddleOfGroup(hour: hour, slot: slot, plan: plan) {
                    Text(title)
                        .font(.system(size: 9))
                        .lineLimit(1)
                        .fixedSize()
                        .foregroundStyle(.primary.opacity(0.8))
                        .allowsHitTesting(false)
                }
            }
    }

    /// 현재 셀이 동일 todo로 연속 칠해진 구간의 중앙(또는 그 근처)인지
    private func isMiddleOfGroup(hour: Int, slot: Int, plan: DailyPlan) -> Bool {
        let currentID = plan.timetable[hour][slot]
        guard currentID != nil else { return false }

        let totalSlots = rowCount * slotCount
        let currentIdx = hour * slotCount + slot

        var startIdx = currentIdx
        while startIdx > 0 {
            let prev = startIdx - 1
            if plan.timetable[prev / slotCount][prev % slotCount] != currentID { break }
            startIdx = prev
        }

        var endIdx = currentIdx
        while endIdx < totalSlots - 1 {
            let next = endIdx + 1
            if plan.timetable[next / slotCount][next % slotCount] != currentID { break }
            endIdx = next
        }

        return currentIdx == (startIdx + endIdx) / 2
    }

    private func paintAt(location: CGPoint, cellWidth: CGFloat) {
        let x = location.x - labelWidth
        let y = location.y
        guard x >= 0, y >= 0, cellWidth > 0 else { return }
        let slot = Int(x / cellWidth)
        let hour = Int(y / rowHeight)
        guard (0..<rowCount).contains(hour), (0..<slotCount).contains(slot) else { return }

        let cell = PaintedCell(hour: hour, slot: slot)
        if lastPainted == cell { return }
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

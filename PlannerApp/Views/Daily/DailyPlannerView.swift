//
//  DailyPlannerView.swift
//  PlannerApp
//
//  Created by 이지민 on 5/16/26.
//

import SwiftUI

struct DailyPlannerView: View {
    @Binding var date: Date
    @Environment(PlannerStore.self) private var store

    var body: some View {
        VStack(spacing: 0) {
            DateHeader(date: $date)

            ScrollView {
                HStack(alignment: .top, spacing: 12) {
                    TodoListColumn(date: date)
                    TimeTableColumn(date: date)
                }
                .padding(.horizontal, 12)

                SummaryBox(date: date)
                    .padding(12)
            }
        }
        // 좌우 스와이프로 날짜 이동
        .gesture(
            DragGesture(minimumDistance: 40)
                .onEnded { value in
                    if value.translation.width < -40 {
                        date = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
                    } else if value.translation.width > 40 {
                        date = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? date
                    }
                }
        )
    }
}

#Preview {
    DailyPlannerView(date: .constant(Date()))
        .environment(PlannerStore())
}

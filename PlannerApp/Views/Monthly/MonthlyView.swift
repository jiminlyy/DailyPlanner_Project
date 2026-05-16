//
//  MonthlyView.swift
//  PlannerApp
//
//  Created by 이지민 on 5/16/26.
//

import SwiftUI

struct MonthlyView: View {
    @Binding var selectedDate: Date
    var switchToDaily: () -> Void
    @State private var displayedMonth: Date = Date()
    
    private let cal = Calendar.current
    
    var body: some View {
        VStack {
            // 월 이동 헤더
            HStack {
                Button { shiftMonth(-1) } label: { Image(systemName: "chevron.left") }
                Spacer()
                Text(monthTitle).font(.headline)
                Spacer()
                Button { shiftMonth(1) } label: { Image(systemName: "chevron.right") }
            }
            .padding()
            
            // 요일 헤더
            HStack {
                ForEach(["일","월","화","수","목","금","토"], id: \.self) { d in
                    Text(d).font(.caption).frame(maxWidth: .infinity)
                }
            }
            
            // 날짜 그리드
            let days = daysInMonth()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(days.indices, id: \.self) { i in
                    if let day = days[i] {
                        Button {
                            selectedDate = day
                            switchToDaily()
                        } label: {
                            Text("\(cal.component(.day, from: day))")
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(cal.isDateInToday(day) ? .blue.opacity(0.2) : .clear)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .foregroundStyle(.primary)
                    } else {
                        Color.clear.frame(minHeight: 40)
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
        }
    }
    
    private var monthTitle: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyy년 M월"
        return f.string(from: displayedMonth)
    }
    
    private func shiftMonth(_ delta: Int) {
        displayedMonth = cal.date(byAdding: .month, value: delta, to: displayedMonth) ?? displayedMonth
    }
    
    /// 해당 월을 7×N 그리드용으로 [Date?] 반환 (빈칸은 nil)
    private func daysInMonth() -> [Date?] {
        let start = cal.date(from: cal.dateComponents([.year, .month], from: displayedMonth))!
        let range = cal.range(of: .day, in: .month, for: start)!
        let firstWeekday = cal.component(.weekday, from: start) // 1=일
        
        var result: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        for day in range {
            result.append(cal.date(byAdding: .day, value: day - 1, to: start))
        }
        while result.count % 7 != 0 { result.append(nil) }
        return result
    }
}

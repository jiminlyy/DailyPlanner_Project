//
//  DateHeader.swift
//  PlannerApp
//
//  Created by 이지민 on 5/16/26.
//

import SwiftUI

struct DateHeader: View {
    @Binding var date: Date

    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyy. MM. dd. (E)"
        return f
    }()

    var body: some View {
        HStack {
            Button {
                date = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? date
            } label: {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text(formatter.string(from: date)).font(.headline)
            Spacer()
            Button {
                date = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .padding()
        .overlay(
            Rectangle().frame(height: 1).foregroundStyle(.primary),
            alignment: .bottom
        )
    }
}

//
//  SummaryBox.swift
//  PlannerApp
//
//  Created by 이지민 on 5/17/26.
//

import SwiftUI

struct SummaryBox: View {
    let date: Date
    @Environment(PlannerStore.self) private var store
    
    var body: some View {
        var plan = store.plan(for: date)
        VStack(alignment: .leading, spacing: 6) {
            Text("SUMMARY").font(.caption).bold().foregroundStyle(.secondary)
            TextEditor(text: Binding(
                get: { plan.summary },
                set: { plan.summary = $0; store.update(plan) }
            ))
            .frame(minHeight: 100)
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(.gray.opacity(0.4)))
        }
    }
}

//
//  RootTabView.swift
//  PlannerApp
//
//  Created by 이지민 on 5/16/26.
//

import SwiftUI

struct RootTabView: View {
    @Binding var selectedDate: Date
    @State private var tab = 0

    var body: some View {
        TabView(selection: $tab) {
            DailyPlannerView(date: $selectedDate)
                .tabItem { Label("Daily", systemImage: "list.bullet.rectangle") }
                .tag(0)

            MonthlyView(selectedDate: $selectedDate, switchToDaily: { tab = 0 })
                .tabItem { Label("Monthly", systemImage: "calendar") }
                .tag(1)
        }
    }
}

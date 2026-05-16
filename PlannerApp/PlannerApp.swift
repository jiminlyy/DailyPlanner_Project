//
//  PlannerApp.swift
//  PlannerApp
//
//  Created by 이지민 on 5/16/26.
//

import SwiftUI

@main
struct PlannerApp: App {
    @State private var store = PlannerStore()
    @State private var selectedDate = Date()

    var body: some Scene {
        WindowGroup {
            RootTabView(selectedDate: $selectedDate)
                .environment(store)
        }
    }
}

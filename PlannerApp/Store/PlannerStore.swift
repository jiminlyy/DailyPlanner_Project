//
//  PlannerStore.swift
//  PlannerApp
//
//  Created by 이지민 on 5/16/26.
//

import Foundation
import Observation

@Observable
final class PlannerStore {
    private var plans: [Date: DailyPlan] = [:]   // 자정 기준 Date → DailyPlan

    func plan(for date: Date) -> DailyPlan {
        let key = Calendar.current.startOfDay(for: date)
        if let p = plans[key] { return p }
        let new = DailyPlan.empty(for: key)
        plans[key] = new
        return new
    }

    func update(_ plan: DailyPlan) {
        let key = Calendar.current.startOfDay(for: plan.date)
        plans[key] = plan
        persist()
    }

    // MARK: Persistence (UserDefaults 임시)
    private let storageKey = "PlannerStore.plans.v1"

    init() { load() }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([DailyPlan].self, from: data) else { return }
        let palette = ColorPalette.todoColors
        var migrated = false
        for var p in decoded {
            for i in p.todos.indices where p.todos[i].colorHex == "#A8D8EA" {
                p.todos[i].colorHex = palette[i % palette.count]
                migrated = true
            }
            plans[Calendar.current.startOfDay(for: p.date)] = p
        }
        if migrated { persist() }
    }

    private func persist() {
        let array = Array(plans.values)
        if let data = try? JSONEncoder().encode(array) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}

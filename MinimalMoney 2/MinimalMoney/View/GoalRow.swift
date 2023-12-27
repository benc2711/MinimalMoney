//
//  GoalRow.swift
//  MinimalMoney
//
//  Created by Ben Crotty on 12/5/23.
//

import SwiftUI

struct GoalRow: View {
    let goal: FinancialGoal

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(goal.title)
                    .font(.headline)
                Text("Target: \(goal.targetAmount, specifier: "%.2f")")
                    .font(.subheadline)
               
            }
            Spacer()
            Image(systemName: "target")
                .foregroundColor(.blue)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
        .padding(.horizontal)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

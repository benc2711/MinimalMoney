//
//  FinancialGoalSheetView.swift
//  MinimalMoney
//
//  Created by Ben Crotty on 12/4/23.
//

import SwiftUI

struct FinancialGoalSheetView: View {
    @ObservedObject var viewModel: AccountViewModel
    @State private var newGoalTitle: String = ""
    @State private var newGoalAmount: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add New Goal")) {
                    TextField("Goal Title", text: $newGoalTitle)
                    TextField("Target Amount", text: $newGoalAmount)
                        .keyboardType(.decimalPad)
                }
                Button("Add Goal") {
                    if let targetAmount = Double(newGoalAmount) {
                        let goal = FinancialGoal(id: UUID().uuidString, title: newGoalTitle, targetAmount: targetAmount)
                        viewModel.addGoal(goal: goal)
                        newGoalTitle = ""
                        newGoalAmount = ""
                    }
                }
                
            }
            .navigationBarTitle("Financial Goals", displayMode: .inline)
        }
    }
}

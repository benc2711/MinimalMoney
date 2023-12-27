//  AccountView.swift
//  MinimalMoney
//
//  Created by Ben Crotty on 12/3/23.
//

import SwiftUI

struct AccountView: View {
    @ObservedObject var viewModel: AccountViewModel
    @ObservedObject var purchaseViewModel: PurchaseViewModel
    @ObservedObject var loginViewModel: LoginViewModel
    @State private var newBudget: String = ""
    @State private var newBalance: String = ""
    @State private var newCategory: String = ""
    @State private var showingGoalSheet: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // Daily Budget Entry
                    HStack {
                        TextField("Enter new budget", text: $newBudget)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        Button("Set Budget") {
                            if let budget = Double(newBudget) {
                                viewModel.modifyDailyBudget(newBudget: budget)
                                purchaseViewModel.dailyBudget = budget
                                newBudget = ""
                            }
                        }
                    }
                    .padding()

                    // Modify Balance Entry
                    HStack {
                        TextField("Enter new balance", text: $newBalance)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        Button("Set Balance") {
                            if let balance = Double(newBalance) {
                                viewModel.modifyAccountBalance(newBalance: balance)
                                purchaseViewModel.user.linkedBankAccounts?.balance = balance
                                newBalance = ""
                            }
                        }
                    }
                    .padding()

                    // Add Spending Category
                    HStack {
                        TextField("New Category", text: $newCategory)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Add Category") {
                            viewModel.addSpendingCategory(category: newCategory)
                            purchaseViewModel.user.spendingCategories?.append(newCategory)
                            newCategory = ""
                        }
                    }
                    .padding()

                    Button("Add Financial Goal") {
                        showingGoalSheet = true
                    }
                    .sheet(isPresented: $showingGoalSheet) {
                        FinancialGoalSheetView(viewModel: viewModel)
                    }
                    .padding()

                    // Financial Goals Section
                    if !viewModel.goals.isEmpty {
                        Text("Financial Goals")
                            .font(.title2)
                            .padding()
                        ForEach(viewModel.goals, id: \.id) { goal in
                            GoalRow(goal: goal)
                        }
                        
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Text(viewModel.user.linkedBankAccounts?.accountName ?? "Account")
                        .font(.headline)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Logout") {
                        Task {
                            await loginViewModel.signOut()
                        }
                    }
                }
            }
        }
    }
}

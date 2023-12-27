//  SnapshotView.swift
//  MinimalMoney
//
//  Created by Ben Crotty on 12/3/23.
//

import SwiftUI

struct SnapshotView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    @State private var selectedDays: Int = 2
    @State private var isAccountDetailsVisible: Bool = false
    @State private var selectedDaysAsDouble: Double = 2
    @State private var showFullScreenChart: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                // Account Name with Toggle for Details
                HStack {
                    Text("Account Name: \(viewModel.user.linkedBankAccounts?.accountName ?? "N/A")")
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: isAccountDetailsVisible ? "chevron.up" : "chevron.down")
                }
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(10)
                .onTapGesture {
                    withAnimation {
                        isAccountDetailsVisible.toggle()
                    }
                }
                
                HStack {
                    Text("Days: \(selectedDays)")
                        .fontWeight(.bold)
                    Slider(value: $selectedDaysAsDouble, in: 2...365, step: 1)
                        .onChange(of: selectedDaysAsDouble) { newValue in
                            selectedDays = Int(newValue.rounded()) // Convert to Int
                            viewModel.updateData(for: selectedDays)
                        }
                }
                .padding()
                if isAccountDetailsVisible {
                    VStack(alignment: .leading) {
                        Text("Balance: \(viewModel.user.linkedBankAccounts?.balance ?? 0, specifier: "%.2f")")
                    }
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(10)
                    .transition(.move(edge: .top))
                }
                Spacer().frame(height: 20)

                
                // Spending line chart
                Button("Show Spending By Day") {
                    showFullScreenChart = true
                }
                .sheet(isPresented: $showFullScreenChart) {
                   
                    
                }
                .padding()
                
                // Pie Chart for spending by category
                if #available(iOS 17.0, *) {
                    PieChartView(viewModel: viewModel, days: selectedDays)
                        .padding()
                }
                // Transactions based on slider
                VStack(alignment: .leading, spacing: 10) {
                    Text("Transactions")
                        .font(.headline)
                        .padding(.leading)
                    
                    ForEach(viewModel.transactionsForPeriod, id: \.transactionID) { transaction in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(transaction.category)
                                    .font(.subheadline)
                                Text("Amount: $\(transaction.amount, specifier: "%.2f")")
                                    .font(.caption)
                            }
                            Spacer()
                            Text(transaction.date, style: .date)
                                .font(.caption)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
            }
        }
    }
}

import SwiftUI

struct PurchaseView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    @State private var purchaseAmount: String = ""
    @State private var purchaseTitle: String = ""
    @State private var selectedCategory: String = ""
    @State private var isAccountDetailsVisible: Bool = false

    private var categories: [String] {
        viewModel.user.spendingCategories ?? ["Select a Category"]
    }

    var body: some View {
        ScrollView{
            LazyVStack {
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
                
                // Daily Budget Display
                HStack {
                    Text("Today's Budget:")
                    Spacer()
                    Text("$\(viewModel.dailyBudget, specifier: "%.2f")")
                        .fontWeight(.bold)
                        .padding(8)
                        .background(viewModel.dailyBudget > 0 ? Color.blue : Color.red)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                // Collapsible Account Details
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
                
                //             Spending Pie Chart
                if #available(iOS 17.0, *) {
                    PieChartView(viewModel: viewModel, days: 1)
                        .frame(height: 200)
                        .padding()
                }
                // Purchase Title Field
                HStack {
                    TextField("Enter title for the transaction", text: $purchaseTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
                .padding()
                
                // Purchase Input Fields
                HStack {
                    Button(action: { incrementAmount(-1) }) {
                        Image(systemName: "minus.circle")
                    }
                    TextField("Enter purchase amount", text: $purchaseAmount)
                        .keyboardType(.decimalPad)
                        .frame(width: 100)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: { incrementAmount(1) }) {
                        Image(systemName: "plus.circle")
                    }
                }
                .padding()
                
                // Category Picker
                Picker("Select Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                // Add Purchase Button
                Button(action: addPurchase) {
                    Text("Add Purchase")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
                // ScrollView for Today's Transactions
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Today's Transactions")
                            .font(.headline)
                            .padding(.leading)
                        
                        ForEach(viewModel.getTransactionsForTime(days: 1), id: \.transactionID) { transaction in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(transaction.description ?? "")
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
                .frame(maxHeight: 200)
                
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.selectedCatagory = ""
                viewModel.updateData(for: 1)
                if let firstCategory = viewModel.user.spendingCategories?.first {
                    selectedCategory = firstCategory
                }
            }
        }
    }

    private func incrementAmount(_ delta: Int) {
        if let currentAmount = Int(purchaseAmount) {
            let newAmount = max(currentAmount + delta, 0)
            purchaseAmount = "\(newAmount)"
        } else {
            purchaseAmount = delta > 0 ? "1" : "0"
        }
    }

    private func addPurchase() {
        guard let amount = Double(purchaseAmount), amount > 0 else {
            print("Invalid amount")
            return
        }

        let newTransaction = Transaction(
            transactionID: UUID().uuidString,
            amount: amount,
            date: Date(),
            category: selectedCategory,
            accountID: viewModel.user.linkedBankAccounts?.accountID ?? "N/A",
            description: purchaseTitle
        )

        viewModel.addPurchase(transaction: newTransaction)
        purchaseAmount = ""
        purchaseTitle = ""
    }
}


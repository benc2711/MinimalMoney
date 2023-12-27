//
//  PurchaseViewModel.swift
//  MinimalMoney
//
//  Created by Ben Crotty on 12/2/23.
//

import Foundation
import FirebaseFirestore
import Firebase




class PurchaseViewModel : ObservableObject {
    @Published var user = UserManager.shared.current
    @Published var dailyBudget = UserManager.shared.current.budgetLimit ?? 0
    @Published var purchases = UserManager.shared.current.transactions ?? []
    @Published var spendingDataForChart: [Double] = []
    @Published var purchaseCount = 0
    @Published var transactionsForPeriod: [Transaction] = []
    @Published var selectedCatagory: String = ""
    
    private var db = Firestore.firestore()



    init() {
        updateDailyBudget()
        updateData(for: 2)
        
    }
    
    private func updateDailyBudget() {
           let totalSpentToday = purchases.filter { Calendar.current.isDateInToday($0.date) }
                                           .reduce(0) { $0 + $1.amount }
           self.dailyBudget -= totalSpentToday 
       }
    
    func addPurchase(transaction: Transaction) {
        // Add transaction to purchases array
        self.purchases.append(transaction)
        self.user.transactions?.append(transaction)

        // Update daily budget
        self.dailyBudget -= transaction.amount

        // Check and update the linked bank account's balance
        if var linkedAccount = self.user.linkedBankAccounts {
            linkedAccount.balance -= transaction.amount
            self.user.linkedBankAccounts = linkedAccount // Update the linked account in the user object
        }
        purchaseCount += 1
        // Save transactions and updated bank account balance to Firestore
        saveTransactionsAndBankAccountBalanceToFirestore()
        updateData(for: 2)

    }
    
    func spendingByCategory(for days: Int) -> [String: Double] {
           let todaysPurchases = getTransactionsForTime(days: 1)
        
           return Dictionary(grouping: todaysPurchases, by: { $0.category })
                  .mapValues { $0.reduce(0) { $0 + $1.amount } }
       }
    
    func updateData(for days: Int) {
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        transactionsForPeriod = user.transactions?.filter { $0.date >= startDate } ?? []
    }
    func getTransactionsForTime(days: Int) -> [Transaction] {
        
        print("Ran")
        if self.selectedCatagory.isEmpty {
            print(transactionsForPeriod)
            return transactionsForPeriod
        } else {
            print(transactionsForPeriod)
            return transactionsForPeriod.filter { $0.category == selectedCatagory }
        }
    }
    

    private func saveTransactionsAndBankAccountBalanceToFirestore() {
        guard let userID = self.user.userID else {
            print("Error: User ID is missing")
            return
        }

        let transactionsData = self.purchases.map { $0.toDictionary() }
        
        // Prepare data for updating bank account balance
        let bankAccountData: [String: Any] = [
            "accountID": self.user.linkedBankAccounts?.accountID ?? "",
            "accountName": self.user.linkedBankAccounts?.accountName ?? "",
            "balance": self.user.linkedBankAccounts?.balance ?? 0
        ]

        // Update Firestore with new transaction data and bank account balance
        db.collection("users").document(userID).updateData([
            "transactions": transactionsData,
            "linkedBankAccounts": bankAccountData
        ]) { error in
            if let error = error {
                print("Error updating user data: \(error)")
            } else {
                print("User data successfully updated")
            }
        }
    }


}

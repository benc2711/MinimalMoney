//
//  user.swift
//  MinimalMoney
//
//  Created by Ben Crotty on 11/30/23.
//

import Foundation
import Firebase
import FirebaseFirestore



// User Account Model
struct UserAccount : Codable{
    @DocumentID var userID: String?        // Unique identifier for the user
    var email: String?             // User's email address
    

    var budgetLimit: Double?       // User's budget limit
    var spendingCategories: [String]?
    var linkedBankAccounts: BankAccount?
    var transactions : [Transaction]?
    
    var goals : [FinancialGoal]?
    var expectedTransactions : [Transaction]?

    // Initializer for a user account
    init(userID: String, email: String? = nil) {
        self.userID = userID
        self.email = email
        
    }
    
    init() {
            self.userID = nil
            self.email = nil
            // Set other properties to default or nil values
            self.budgetLimit = nil
            self.spendingCategories = nil
            self.linkedBankAccounts = nil
            self.transactions = nil
            self.goals = nil
            self.expectedTransactions = nil
        }

   
}

struct BankAccount : Codable{
    var accountID: String
    var accountName: String
    var balance: Double
}

struct FinancialGoal: Codable {
    var id: String
    var title: String
    var targetAmount: Double

    // Dictionary-based initializer
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let title = dictionary["title"] as? String,
              let targetAmount = dictionary["targetAmount"] as? Double else {
            return nil
        }

        self.id = id
        self.title = title
        self.targetAmount = targetAmount
    }

    init(id: String, title: String, targetAmount: Double) {
        self.id = id
        self.title = title
        self.targetAmount = targetAmount
    }
}

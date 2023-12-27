//
//  Transaction.swift
//  MinimalMoney
//
//  Created by Ben Crotty on 12/2/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Transaction: Codable, Equatable{
    var transactionID: String
    var amount: Double
    var date: Date
    var category: String
    var accountID: String
    var description: String?

    init(transactionID: String, amount: Double, date: Date, category: String, accountID: String, description: String? = nil) {
        self.transactionID = transactionID
        self.amount = amount
        self.date = date
        self.category = category
        self.accountID = accountID
        self.description = description
    }

    // Custom initializer to create a Transaction from a Firestore document
    init?(document: [String: Any]) {
        guard let transactionID = document["transactionID"] as? String,
              let amount = document["amount"] as? Double,
              let timestamp = document["date"] as? Timestamp,
              let category = document["category"] as? String,
              let accountID = document["accountID"] as? String else {
            return nil
        }

        self.transactionID = transactionID
        self.amount = amount
        self.date = timestamp.dateValue() // Convert Timestamp back to Date
        self.category = category
        self.accountID = accountID
        self.description = document["description"] as? String
    }

    // Method to convert a Transaction instance to a dictionary for Firestore
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "transactionID": transactionID,
            "amount": amount,
            "category": category,
            "accountID": accountID,
            // Convert Date to Firestore Timestamp
            "date": Timestamp(date: date)
        ]
        
        if let description = description {
            dict["description"] = description
        }

        return dict
    }
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
            return lhs.transactionID == rhs.transactionID
        }
}

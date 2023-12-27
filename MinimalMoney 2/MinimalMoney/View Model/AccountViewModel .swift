//
//  AccountViewModel .swift
//  MinimalMoney
//
//  Created by Ben Crotty on 12/4/23.
//

import Foundation
import Combine
import FirebaseFirestore
import Firebase

class AccountViewModel: ObservableObject {
    @Published var user: UserAccount
    @Published var dailyBudget: Double
    @Published var accountBalance: Double
    @Published var spendingCategories: [String]
    @Published var goals: [FinancialGoal]
    
    private var db = Firestore.firestore()


   

    init() {
        let currentUser = UserManager.shared.current
        self.user = currentUser
        self.dailyBudget = currentUser.budgetLimit ?? 0
        self.accountBalance = currentUser.linkedBankAccounts?.balance ?? 0
        self.spendingCategories = currentUser.spendingCategories ?? []
        self.goals = currentUser.goals ?? []

    }

    
    func modifyDailyBudget(newBudget: Double) {
        dailyBudget = newBudget
        self.user.budgetLimit = newBudget
        UserManager.shared.updateUser(with: self.user)
        saveToFirestore("budgetLimit", newBudget)
    }

    func modifyAccountBalance(newBalance: Double) {
        accountBalance = newBalance
        self.user.linkedBankAccounts?.balance = newBalance
        UserManager.shared.updateUser(with: self.user)


        user.linkedBankAccounts?.balance = newBalance

        saveToFirestore("linkedBankAccounts.balance", newBalance)
    }


    func addSpendingCategory(category: String) {
        spendingCategories.append(category)
        self.user.spendingCategories?.append(category)
        UserManager.shared.updateUser(with: self.user)
        saveToFirestore("spendingCategories", spendingCategories)
    }

    func addGoal(goal: FinancialGoal) {
        goals.append(goal)
        
        guard let userID = self.user.userID else {
            print("Error: User ID is missing")
            return
        }

        let goalDict: [String: Any] = [
            "id": goal.id,
            "title": goal.title,
            "targetAmount": goal.targetAmount,
        ]

        db.collection("users").document(userID).updateData([
            "goals": FieldValue.arrayUnion([goalDict])
        ]) { error in
            if let error = error {
                print("Error adding goal: \(error)")
            }
        }
    }


    
    private func saveToFirestore(_ field: String, _ value: Any) {
           guard let userID = self.user.userID else {
               print("Error: User ID is missing")
               return
           }

           db.collection("users").document(userID).updateData([field: value]) { error in
               if let error = error {
                   print("Error updating \(field): \(error)")
               } else {
                   print("\(field) successfully updated")
               }
           }
       }
   
    

    
  
    
    
}




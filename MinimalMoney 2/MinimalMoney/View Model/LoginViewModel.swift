//
//  LoginViewModel.swift
//  MinimalMoney
//
//  Created by Ben Crotty on 12/2/23.
//



import Foundation
import Firebase
import AuthenticationServices
import FirebaseFirestore
import UserNotifications

@MainActor
class LoginViewModel: ObservableObject {
    @Published var success = false
    @Published var user = UserAccount(userID: "", email: "")
    @Published var isLoading = false
    @Published var invalidLogin = false
    @Published var invalidRegister = false

    // User Registration
    func registerUser(email: String, password: String) async {
        invalidRegister = false
        invalidLogin = false
        isLoading = true
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            user.userID = authResult.user.uid
            user.email = email
            
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(user.userID!)
            try docRef.setData(from: self.user)
            createDefaultUserData(userId: user.userID!)
            UserManager.shared.updateUser(with: self.user)
            success = true
        } catch {
            print("Error registering user: \(error)")
            invalidRegister = true
        }
        isLoading = false
    }
    
    private func createDefaultUserData(userId: String) {
        let defaultBankAccount = BankAccount(accountID: UUID().uuidString, accountName: "Default", balance: 2000)
        var newUser = UserAccount(userID: userId, email: self.user.email)
        newUser.linkedBankAccounts = defaultBankAccount
        newUser.spendingCategories = ["Groceries", "Food", "Big Purchases"]
        newUser.budgetLimit = 40
        newUser.transactions = []
        newUser.goals = []

        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userId)
        do {
            try docRef.setData(from: newUser)
            UserManager.shared.updateUser(with: newUser)
            
        } catch {
            print("Error setting default user data: \(error)")
        }
    }
    
    // Local Login with Firebase
    func signIn(email: String, password: String) async {
        invalidRegister = false
        invalidLogin = false
        isLoading = true
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let userId = authResult.user.uid
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(userId)

            docRef.getDocument { [weak self] (document, error) in
                guard let self = self else { return }

                if let document = document, document.exists, var userAccount = try? document.data(as: UserAccount.self) {
                    // Fetch transactions data separately
                    if let transactionsData = document.get("transactions") as? [[String: Any]] {
                        let transactions = transactionsData.compactMap(Transaction.init)
                        userAccount.transactions = transactions
                    }
                    if let goalsData = document.get("goals") as? [[String: Any]] {
                      let goals = goalsData.compactMap { FinancialGoal(dictionary: $0) }
                      userAccount.goals = goals
                  }

                    
                    self.user = userAccount
                    UserManager.shared.updateUser(with: self.user)
                    self.success = true
                } else {
                    invalidLogin = true
                    print("User data not found or error: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        } catch {
            invalidLogin = true
            print("Error signing in: \(error)")
        }
        isLoading = false
    }
    
  

    // Local Signout with Firebase
    func signOut() async {
        do {
            try Auth.auth().signOut()
            UserManager.shared.logout()
            success = false
        } catch {
            print("Error signing out: \(error)")
        }
    }
    
    // Error Handling
    enum LoginError: Error {
        case missingCredentials
        case missingGoogleToken
        case unknownError
        case userDataNotFound
    }
}

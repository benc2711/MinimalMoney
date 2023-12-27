//
//  UserManager.swift
//  MinimalMoney
//
//  Created by Ben Crotty on 11/30/23.
//
import Foundation

class UserManager : ObservableObject{
    static let shared = UserManager()

    @Published var currentUser: UserAccount
    @Published var log = false

    private init() {
        // Initialize with a default UserAccount
        self.currentUser = UserAccount(userID: "default", email: "default@example.com")
    }

    func updateUser(with user: UserAccount) {
        self.currentUser = user
    }

    var current: UserAccount {
        return currentUser
    }

    func logout() {
        updateUser(with: UserAccount())
        self.log = true

    }
}

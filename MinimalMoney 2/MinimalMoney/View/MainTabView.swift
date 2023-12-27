//
//  MainTabView.swift
//  MinimalMoney
//
//  Created by Ben Crotty on 12/2/23.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var purchaseViewModel = PurchaseViewModel()
    @StateObject var accountViewModel = AccountViewModel()
    @ObservedObject var loginView: LoginViewModel

    var body: some View {
        TabView {
            PurchaseView(viewModel: purchaseViewModel)
                .tabItem {
                    Label("Purchase", systemImage: "dollarsign")
                }
            SnapshotView(viewModel: purchaseViewModel)
                .tabItem {
                    Label("Snapshot", systemImage: "camera.circle")
                }
            AccountView(viewModel: accountViewModel, purchaseViewModel: purchaseViewModel, loginViewModel: loginView)
                .tabItem {
                    Label("Account", systemImage: "info.circle")
                }
        }
    }
}

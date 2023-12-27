//
//  ContentView.swift
//  MinimalMoney
//
//  Created by Ben Crotty on 11/20/23.
//
import SwiftUI
struct ContentView: View {
    @StateObject var loginViewModel = LoginViewModel()

    var body: some View {
        if loginViewModel.success {
            MainTabView(loginView: loginViewModel)
                
        } else {
            LoginView(viewModel: loginViewModel)
                
        }
    }
    
    
    
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


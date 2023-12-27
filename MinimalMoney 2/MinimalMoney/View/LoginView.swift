//
//  LoginView.swift
//  MinimalMoney
//
//  Created by Ben Crotty on 12/2/23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject var viewModel : LoginViewModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            if viewModel.isLoading{
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
            else{
                // Banner with App Name
                Text("Minimal Money")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Image("banner2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 320, height: 200)
                    .cornerRadius(20)
                
                Text("Be in the Know, So Your Money Won't Go")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
                
                // Email TextField
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Password SecureField
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Login Button
                Button("Sign In") {
                    Task {
                        await viewModel.signIn(email: email, password: password)
                        if viewModel.success {
                            print("Login successful")
                            // Navigate to next screen or perform further actions
                        } else {
                            print("Login failed")
                            // Show error message to user
                        }
                    }
                }
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
                
                // SignUp / Register Button
                Button("Register") {
                    Task {
                        await viewModel.registerUser(email: email, password: password)
                        if viewModel.user.userID != "" {
                            print("Registration successful")
                            // Navigate to next screen or perform further actions
                        } else {
                            print("Registration failed")
                            // Show error message to user
                        }
                    }
                }
                .padding()
                if viewModel.invalidLogin{
                    Text("Invalid Login Information")
                        .foregroundStyle(Color.red)
                }
                if viewModel.invalidRegister{
                    Text("Invalid Register Information")
                        .foregroundStyle(Color.red)
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.green.opacity(0.2))
    }
}







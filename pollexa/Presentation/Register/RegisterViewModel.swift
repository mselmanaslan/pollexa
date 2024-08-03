//
//  RegisterViewModel.swift
//  pollexa
//
//  Created by Selman Aslan on 6.06.2024.
//

import Foundation

class RegisterViewModel {
  
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var errorMessage: String?
    
    func validateFields() -> Bool {
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "All fields are required."
            return false
        }
        
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return false
        }
        
        return true
    }
    
    func registerUser(completion: @escaping (Result<Void, Error>) -> Void) {
        AuthService.shared.registerUser(email: email, password: password) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                if error.localizedDescription == "Email already exists" {
                    self.errorMessage = "Email already exists."
                } else {
                    self.errorMessage = "Registration failed: \(error.localizedDescription)"
                }
                completion(.failure(error))
            }
        }
    }
}

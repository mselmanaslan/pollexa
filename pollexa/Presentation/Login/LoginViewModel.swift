//
//  LoginViewModel.swift
//  pollexa
//
//  Created by Selman Aslan on 7.06.2024.
//

import Foundation

class LoginViewModel {
    var email: String = ""
    var password: String = ""
    var errorMessage: String?
    
    func validateFields() -> Bool {
        if email.isEmpty || password.isEmpty {
            errorMessage = "All fields are required."
            return false
        }
        return true
    }
    
    func loginUser(completion: @escaping (Result<Void, Error>) -> Void) {
        AuthService.shared.loginUser(email: email, password: password) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                self.errorMessage = "Login failed: \(error.localizedDescription)"
                completion(.failure(error))
            }
        }
    }
}

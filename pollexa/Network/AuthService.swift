//
//  AuthService.swift
//  pollexa
//
//  Created by Selman Aslan on 6.06.2024.
//

import Foundation
import FirebaseFirestore

class AuthService {
    
    static let shared = AuthService()
  private let userDefaults = UserDefaults.standard
    
    private let db = Firestore.firestore()
    
    private init() {}
  
  func registerUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
          // Check if the email already exists
          db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
              if let error = error {
                  completion(.failure(error))
              } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                  // Email already exists
                  let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Email already exists"])
                  completion(.failure(error))
              } else {
                  // Email doesn't exist, add the user
                  let userId = UUID().uuidString
                  let userData: [String: Any] = [
                      "id": userId,
                      "email": email,
                      "password": password // Not secure, just for demonstration purposes
                  ]

                  self.db.collection("users").document(userId).setData(userData) { error in
                      if let error = error {
                          completion(.failure(error))
                      } else {
                          completion(.success(()))
                      }
                  }
              }
          }
      }
    // Login User
  func loginUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
          db.collection("users").whereField("email", isEqualTo: email).whereField("password", isEqualTo: password).getDocuments { (querySnapshot, error) in
              if let error = error {
                  completion(.failure(error))
              } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                  // Save the logged-in user's email to UserDefaults
                  self.userDefaults.set(email, forKey: "loggedInUserEmail")
                  completion(.success(()))
              } else {
                  completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid email or password"])))
              }
          }
      }
      
      // Logout User
      func logoutUser(completion: @escaping (Result<Void, Error>) -> Void) {
          // Clear the logged-in user's email from UserDefaults
          userDefaults.removeObject(forKey: "loggedInUserEmail")
          completion(.success(()))
      }
      
      // Retrieve logged-in user's email
      func getLoggedInUserEmail() -> String? {
          return userDefaults.string(forKey: "loggedInUserEmail")
      }
  }








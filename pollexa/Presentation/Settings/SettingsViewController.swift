//
//  SettingsViewController.swift
//  pollexa
//
//  Created by Selman Aslan on 11.06.2024.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainBackgroundColor")
        title = "Settings"
        setupLogoutButton()
    }
    
    private func setupLogoutButton() {
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(.red, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        
        logoutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func logoutButtonTapped() {
        AuthService.shared.logoutUser { [weak self] result in
            switch result {
            case .success:
                self?.redirectToLogin()
            case .failure(let error):
                print("Failed to log out: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Error", message: "Failed to log out. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
  private func redirectToLogin() {
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
         let sceneDelegate = windowScene.delegate as? SceneDelegate {
          let loginVC = LoginViewController()
          let navController = UINavigationController(rootViewController: loginVC)
          sceneDelegate.window?.rootViewController = navController
          sceneDelegate.window?.makeKeyAndVisible()
      } else {
          print("Could not find windowScene or scene delegate")
      }
  }

}

//
//  LoginViewController.swift
//  pollexa
//
//  Created by Selman Aslan on 6.06.2024.
//

import Foundation
import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    let viewModel = LoginViewModel()
    
    let appLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "E-Mail"
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor.systemCyan
        textField.addSubview(bottomBorder)
        
        bottomBorder.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.backgroundColor = .white
        
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.keyboardType = .default
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor.systemCyan
        textField.addSubview(bottomBorder)
        
        bottomBorder.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.backgroundColor = .white
        
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor(named: "ButtonColor")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let registerLabel: UILabel = {
        let label = UILabel()
        label.text = "You don't have an account? "
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register Now", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(appLogo)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(forgotPasswordButton)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(registerLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        appLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(300)
            make.width.equalTo(300)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField.snp.leading).offset(5)
            make.bottom.equalTo(emailTextField.snp.top).offset(-15)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(appLogo.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.leading.equalTo(passwordTextField.snp.leading).offset(5)
            make.bottom.equalTo(passwordTextField.snp.top).offset(-15)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(80)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.trailing.equalTo(passwordTextField.snp.trailing).offset(-5)
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(40)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        registerLabel.snp.makeConstraints { make in
            make.trailing.equalTo(registerButton.snp.leading)
            make.centerY.equalTo(registerButton.snp.centerY)
        }
    }
    
    @objc func registerButtonTapped() {
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
  @objc func userLoggedIn() {
      let tabBar = TabBarView()
      
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
         let sceneDelegate = windowScene.delegate as? SceneDelegate {
          sceneDelegate.window?.rootViewController = tabBar
          sceneDelegate.window?.makeKeyAndVisible()
      } else {
          print("Could not find windowScene or scene delegate")
      }
  }

    @objc func loginButtonTapped() {
        viewModel.email = emailTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        
        guard viewModel.validateFields() else {
            showAlert(message: viewModel.errorMessage ?? "Unknown error")
            return
        }
        
        viewModel.loginUser { [weak self] result in
            switch result {
            case .success:
                self?.userLoggedIn()
            case .failure(_):
              self?.showAlert(message: self!.viewModel.errorMessage ?? "Login failed")
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

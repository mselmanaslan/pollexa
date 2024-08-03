//
//  RegisterViewController.swift
//  pollexa
//
//  Created by Selman Aslan on 6.06.2024.
//

import Foundation
import UIKit
import SnapKit

class RegisterViewController: UIViewController {
    
    let viewModel = RegisterViewModel()
    
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
    
    let confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm Password"
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
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
    
    let confirmPasswordTextField: UITextField = {
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
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.backgroundColor = UIColor(named: "ButtonColor")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have an account? "
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let welcomeTitle: UILabel = {
        let label = UILabel()
        label.text = "Welcome to the Pollexa app!"
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Sometimes, even the simplest decisions can leave us indecisive."
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let welcomeLabel2: UILabel = {
        let label = UILabel()
        label.text = "Pollexa aims to solve this problem by enabling people to gather opinions from others.\n\nJoin us and become a part of our community!"
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(appLogo)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        view.addSubview(loginButton)
        view.addSubview(loginLabel)
        view.addSubview(welcomeTitle)
        view.addSubview(welcomeLabel)
        view.addSubview(welcomeLabel2)
        view.addSubview(confirmPasswordLabel)
        view.addSubview(confirmPasswordTextField)
        
        self.navigationItem.hidesBackButton = true
        
        setupConstraints()
    }
    
    func setupConstraints() {
        appLogo.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(0)
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
        
        welcomeTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(90)
            make.leading.equalToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeTitle.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(appLogo.snp.leading).offset(30)
        }
        
        welcomeLabel2.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField.snp.leading).offset(5)
            make.bottom.equalTo(emailTextField.snp.top).offset(-15)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(welcomeLabel2.snp.bottom).offset(70)
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
            make.top.equalTo(emailTextField.snp.bottom).offset(60)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        confirmPasswordLabel.snp.makeConstraints { make in
            make.leading.equalTo(confirmPasswordTextField.snp.leading).offset(5)
            make.bottom.equalTo(confirmPasswordTextField.snp.top).offset(-15)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(60)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        registerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(40)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        loginLabel.snp.makeConstraints { make in
            make.trailing.equalTo(loginButton.snp.leading)
            make.centerY.equalTo(loginButton.snp.centerY)
        }
    }
    
    @objc func loginButtonTapped() {
        let registerVC = LoginViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc func registerButtonTapped() {
        viewModel.email = emailTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        viewModel.confirmPassword = confirmPasswordTextField.text ?? ""
        
        guard viewModel.validateFields() else {
            // Kullanıcıya hatayı göster
            showAlert(message: viewModel.errorMessage ?? "Unknown error")
            return
        }
        
        viewModel.registerUser { [weak self] result in
            switch result {
            case .success:
                print("Kullanıcı başarıyla kaydedildi.")
                self?.loginButtonTapped()
            case .failure(let error):
                print("Kullanıcı kaydı başarısız: \(error.localizedDescription)")
              self?.showAlert(message: self!.viewModel.errorMessage ?? "Registration failed")
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

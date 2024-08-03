//
//  AddPollViewController.swift
//  pollexa
//
//  Created by Selman Aslan on 7.06.2024.
//

import Foundation
import UIKit
import SnapKit
import FirebaseFirestore

class AddPollViewController: UIViewController {
    
    private let viewModel = AddPollViewModel()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter poll title"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "MainBackgroundColor")
        textField.textColor = UIColor(named: "TextColor")
        textField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter poll description"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "MainBackgroundColor")
        textField.textColor = UIColor(named: "TextColor")
        textField.addTarget(self, action: #selector(descriptionTextFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    let optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainBackgroundColor")
        title = "Add Poll"
        setupNavigationBarAppearance()
        setupViews()
        setupAddButton()
        setupSaveButton()
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(optionsStackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view).offset(20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.left.equalTo(view).offset(20)
        }
        
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
        
        optionsStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
        }
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "MainBackgroundColor")
        appearance.shadowColor = .clear
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(named: "TextColor")!,
            .font: UIFont.boldSystemFont(ofSize: 24)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor(named: "TextColor")
    }
    
    private func setupAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddOptions))
        addButton.tintColor = UIColor(named: "TextColor")
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupSaveButton() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePoll))
        saveButton.tintColor = UIColor(named: "TextColor")
        navigationItem.rightBarButtonItems?.append(saveButton)
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        viewModel.title = textField.text ?? ""
    }
    
    @objc private func descriptionTextFieldDidChange(_ textField: UITextField) {
        viewModel.description = textField.text ?? ""
    }
    
    @objc private func showAddOptions() {
        let alertController = UIAlertController(title: "Add Option", message: nil, preferredStyle: .actionSheet)
        
        if !viewModel.hasDatePicker {
            let dateAction = UIAlertAction(title: "Date", style: .default) { _ in
                self.addDatePicker()
            }
            alertController.addAction(dateAction)
        }
        
        if !viewModel.hasTimePicker {
            let timeAction = UIAlertAction(title: "Time", style: .default) { _ in
                self.addTimePicker()
            }
            alertController.addAction(timeAction)
        }
        
        if !viewModel.hasTextOptions {
            let textAction = UIAlertAction(title: "Text Options", style: .default) { _ in
                self.askForNumberOfTextOptions()
            }
            alertController.addAction(textAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func addDatePicker() {
        viewModel.addDatePickerOption()
        let containerView = UIView()
        
        let dateLabel: UILabel = {
            let label = UILabel()
            label.text = "Added Date Option"
            label.textColor = UIColor(named: "TextColor")
            label.font = UIFont.systemFont(ofSize: 16)
            return label
        }()
        
        containerView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        addOptionView(containerView)
    }
    
    private func addTimePicker() {
        viewModel.addTimePickerOption()
        let containerView = UIView()
        
        let timeLabel: UILabel = {
            let label = UILabel()
            label.text = "Added Time Option"
            label.textColor = UIColor(named: "TextColor")
            label.font = UIFont.systemFont(ofSize: 16)
            return label
        }()
        
        containerView.addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        addOptionView(containerView)
    }
    
    private func askForNumberOfTextOptions() {
        let alertController = UIAlertController(title: "Number of Options", message: "Enter the number of text options (max 8)", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let text = alertController.textFields?.first?.text, let numberOfOptions = Int(text), numberOfOptions <= 8 {
                self.viewModel.addTextOptions(numberOfOptions: numberOfOptions)
                self.addTextOptions(numberOfOptions: numberOfOptions)
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Please enter a number between 1 and 8.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func addTextOptions(numberOfOptions: Int) {
        let containerView = UIStackView()
        containerView.axis = .vertical
        containerView.spacing = 10
        
        for i in 0..<numberOfOptions {
            let textField = UITextField()
            textField.placeholder = "Option \(i + 1)"
            textField.borderStyle = .roundedRect
            textField.backgroundColor = UIColor(named: "MainBackgroundColor")
            textField.textColor = UIColor(named: "TextColor")
            textField.tag = 100 + i
            textField.addTarget(self, action: #selector(textOptionDidChange(_:)), for: .editingChanged)
            containerView.addArrangedSubview(textField)
        }
        
        addOptionView(containerView)
    }
    
    @objc private func textOptionDidChange(_ textField: UITextField) {
        let index = textField.tag - 100
        viewModel.updateTextOption(at: index, with: textField.text ?? "")
    }
    
    private func addOptionView(_ view: UIView) {
        let optionContainer = UIView()
        optionContainer.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.trailing.equalToSuperview().offset(-60)
        }
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteOptionView(_:)), for: .touchUpInside)
        optionContainer.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        optionsStackView.addArrangedSubview(optionContainer)
    }
    
    @objc private func deleteOptionView(_ sender: UIButton) {
        guard let optionContainer = sender.superview else { return }
        guard let optionView = optionContainer.subviews.first else { return }
        
        if let dateLabel = optionView.subviews.compactMap({ $0 as? UILabel }).first, dateLabel.text == "Added Date Option" {
            viewModel.removeDatePickerOption()
        }
        
        if let timeLabel = optionView.subviews.compactMap({ $0 as? UILabel }).first, timeLabel.text == "Added Time Option" {
            viewModel.removeTimePickerOption()
        }
        
        optionContainer.removeFromSuperview()
    }
    
  @objc private func savePoll() {
      if let errorMessage = viewModel.validateFields() {
          let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          present(alert, animated: true, completion: nil)
          return
      }
      
      viewModel.savePoll { error in
          if let error = error {
              print("Error saving poll: \(error.localizedDescription)")
          } else {
              print("Poll successfully saved.")
              self.navigationController?.popViewController(animated: true)
          }
      }
  }
}

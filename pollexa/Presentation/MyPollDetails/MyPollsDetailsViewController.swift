//
//  MyPollsDetailsView.swift
//  pollexa
//
//  Created by Selman Aslan on 11.06.2024.
//

import UIKit
import SnapKit

class MyPollsDetailsViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var viewModel: MyPollsDetailsViewModel
    
    init(poll: Poll) {
        self.viewModel = MyPollsDetailsViewModel(poll: poll)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainBackgroundColor")
        navigationController?.navigationBar.tintColor = UIColor(named: "TextColor")
        title = viewModel.pollTitle
        setupScrollView()
        setupContent()
        setupDeleteButton()
        
        viewModel.reloadView = { [weak self] in
            self?.updateUIWithVotePercentages(self?.viewModel.votes ?? [])
        }
        
        viewModel.onDeleteSuccess = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        viewModel.onDeleteFailure = { [weak self] errorMessage in
            let alert = UIAlertController(title: "Error", message: "Failed to delete poll. Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        
        viewModel.fetchVotes()
    }
    
    private func setupDeleteButton() {
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deletePoll))
        deleteButton.tintColor = .red
        navigationItem.rightBarButtonItem = deleteButton
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }
    }

    private func setupContent() {
        var previousView: UIView? = nil

        previousView = addDescriptionLabel(to: contentView, below: previousView, description: viewModel.pollDescription)

        if viewModel.pollOptions.contains("Added Date Option") {
            previousView = addDateInfo(to: contentView, below: previousView)
        }

        if viewModel.pollOptions.contains("Added Time Option") {
            previousView = addTimeInfo(to: contentView, below: previousView)
        }

        if !viewModel.pollTextOptions.isEmpty {
            previousView = addTextOptions(to: contentView, below: previousView, options: viewModel.pollTextOptions)
        }

        if let previousView = previousView {
            previousView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-20)
            }
        }
    }

    private func addDescriptionLabel(to parentView: UIView, below previousView: UIView?, description: String) -> UIView {
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 18)
        descriptionLabel.textColor = UIColor(named: "TextColor")
        descriptionLabel.numberOfLines = 0
        parentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(previousView?.snp.bottom ?? parentView.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        return descriptionLabel
    }

    private func addDateInfo(to parentView: UIView, below previousView: UIView?) -> UIView {
        let containerView = UIView()

        let label = UILabel()
        label.text = "Date Options:"
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.boldSystemFont(ofSize: 16)

        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showDateInfo), for: .touchUpInside)

        containerView.addSubview(label)
        containerView.addSubview(infoButton)
        parentView.addSubview(containerView)

        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        infoButton.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }

        containerView.snp.makeConstraints { make in
            make.top.equalTo(previousView?.snp.bottom ?? parentView.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }

        return containerView
    }

    private func addTimeInfo(to parentView: UIView, below previousView: UIView?) -> UIView {
        let containerView = UIView()

        let label = UILabel()
        label.text = "Time Options:"
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.boldSystemFont(ofSize: 16)

        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showTimeInfo), for: .touchUpInside)

        containerView.addSubview(label)
        containerView.addSubview(infoButton)
        parentView.addSubview(containerView)

        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        infoButton.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }

        containerView.snp.makeConstraints { make in
            make.top.equalTo(previousView?.snp.bottom ?? parentView.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }

        return containerView
    }

    private func addTextOptions(to parentView: UIView, below previousView: UIView?, options: [String]) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        parentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(previousView!.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        for option in options {
            let optionView = createOptionView(with: option)
            stackView.addArrangedSubview(optionView)
        }
        return stackView
    }

    private func createOptionView(with text: String) -> UIView {
        let optionView = UIView()
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.systemFont(ofSize: 18)

        let percentageLabel = UILabel()
        percentageLabel.textColor = UIColor(named: "TextColor")
        percentageLabel.font = UIFont.systemFont(ofSize: 14)
        percentageLabel.tag = 100

        optionView.addSubview(label)
        optionView.addSubview(percentageLabel)

        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }

        percentageLabel.snp.makeConstraints { make in
            make.left.equalTo(label.snp.left)
            make.top.equalTo(label.snp.bottom).offset(5)
        }

        optionView.snp.makeConstraints { make in
            make.height.equalTo(44)
        }

        return optionView
    }

    @objc private func showDateInfo() {
        viewModel.fetchOptionVotes(optionType: "dateOptions") { [weak self] optionVotes in
            let infoVC = InfoViewController()
            infoVC.title = "Date Info"
            infoVC.optionVotes = optionVotes ?? []
            self?.present(infoVC, animated: true, completion: nil)
        }
    }

    @objc private func showTimeInfo() {
        viewModel.fetchOptionVotes(optionType: "timeOptions") { [weak self] optionVotes in
            let infoVC = InfoViewController()
            infoVC.title = "Time Info"
            infoVC.optionVotes = optionVotes ?? []
            self?.present(infoVC, animated: true, completion: nil)
        }
    }

    private func updateUIWithVotePercentages(_ votes: [Int]) {
        let totalVotes = votes.reduce(0, +)

        for (index, voteCount) in votes.enumerated() {
            let percentage = totalVotes > 0 ? (Double(voteCount) / Double(totalVotes)) * 100 : 0.0

            for subview in contentView.subviews {
                if let stackView = subview as? UIStackView {
                    let optionView = stackView.arrangedSubviews[index]
                    if let percentageLabel = optionView.viewWithTag(100) as? UILabel {
                        percentageLabel.text = String(format: "%.0f%% (%d votes)", percentage, voteCount)
                    }
                }
            }
        }
    }
  
    @objc private func deletePoll() {
        let alertController = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete this poll?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.viewModel.deletePoll()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

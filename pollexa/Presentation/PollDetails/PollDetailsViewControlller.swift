//
//  PollDetailsViewControlller.swift
//  pollexa
//
//  Created by Selman Aslan on 9.06.2024.
//

import UIKit
import SnapKit

class PollDetailsViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var viewModel: PollDetailsViewModel

    init(poll: Poll) {
        self.viewModel = PollDetailsViewModel(poll: poll)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainBackgroundColor")
        navigationController?.navigationBar.tintColor = UIColor(named: "TextColor")
        title = viewModel.poll?.title
        setupNavigationBar()
        setupScrollView()
        setupContent()
        fetchUserSelections()
    }

    private func setupNavigationBar() {
        let submitButton = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitButtonTapped))
        submitButton.tintColor = UIColor(named: "TextColor")
        navigationItem.rightBarButtonItem = submitButton
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
        guard let poll = viewModel.poll else { return }

        var previousView: UIView? = nil

        previousView = addDescriptionLabel(to: contentView, below: previousView, description: poll.description)

        if poll.options.contains("Added Date Option") {
            previousView = addDatePicker(to: contentView, below: previousView)
        }

        if poll.options.contains("Added Time Option") {
            previousView = addTimePicker(to: contentView, below: previousView)
        }

        if !poll.textOptions.isEmpty {
            previousView = addTextOptions(to: contentView, below: previousView, options: poll.textOptions)
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

    private func addDatePicker(to parentView: UIView, below previousView: UIView?) -> UIView {
        let containerView = UIView()

        let label = UILabel()
        label.text = "Please select a date:"
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.boldSystemFont(ofSize: 16)

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)

        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showDateInfo), for: .touchUpInside)

        containerView.addSubview(label)
        containerView.addSubview(datePicker)
        containerView.addSubview(infoButton)
        parentView.addSubview(containerView)

        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        datePicker.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }

        infoButton.snp.makeConstraints { make in
            make.left.equalTo(datePicker.snp.right).offset(10)
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

    private func addTimePicker(to parentView: UIView, below previousView: UIView?) -> UIView {
        let containerView = UIView()

        let label = UILabel()
        label.text = "Please select a time:"
        label.textColor = UIColor(named: "TextColor")
        label.font = UIFont.boldSystemFont(ofSize: 16)

        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timePickerChanged(_:)), for: .valueChanged)

        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showTimeInfo), for: .touchUpInside)

        containerView.addSubview(label)
        containerView.addSubview(timePicker)
        containerView.addSubview(infoButton)
        parentView.addSubview(containerView)

        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        timePicker.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }

        infoButton.snp.makeConstraints { make in
            make.left.equalTo(timePicker.snp.right).offset(10)
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
        percentageLabel.tag = 100 // Tag to identify the percentage label later

        let dotButton = UIButton(type: .custom)
        let normalImage = UIImage(systemName: "circle")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        let selectedImage = UIImage(systemName: "circle.fill")?.withTintColor(UIColor(named: "TextColor")!, renderingMode: .alwaysOriginal)
        dotButton.setImage(normalImage, for: .normal)
        dotButton.setImage(selectedImage, for: .selected)
        dotButton.addTarget(self, action: #selector(dotButtonTapped(_:)), for: .touchUpInside)

        optionView.addSubview(label)
        optionView.addSubview(percentageLabel)
        optionView.addSubview(dotButton)

        dotButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }

        dotButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)

        label.snp.makeConstraints { make in
            make.left.equalTo(dotButton.snp.right).offset(20)
            make.top.equalTo(dotButton.snp.top)
            make.right.equalToSuperview().offset(-20)
        }

        percentageLabel.snp.makeConstraints { make in
            make.left.equalTo(label.snp.left)
            make.top.equalTo(label.snp.bottom).offset(5)
        }

        optionView.snp.makeConstraints { make in
            make.height.equalTo(44) // Ensuring minimum height for optionView
        }

        return optionView
    }

    @objc private func datePickerChanged(_ sender: UIDatePicker) {
        viewModel.selectedDate = sender.date
    }

    @objc private func timePickerChanged(_ sender: UIDatePicker) {
        viewModel.selectedTime = sender.date
    }

    @objc private func dotButtonTapped(_ sender: UIButton) {
        if viewModel.selectedDot == sender {
            return
        }

        let previousSelectedDot = viewModel.selectedDot

        if let selectedDot = viewModel.selectedDot {
            selectedDot.isSelected = false
        }

        viewModel.selectedDot = sender
        viewModel.selectedDot?.isSelected = true

        updateTemporaryVotePercentages(previousSelectedDot: previousSelectedDot)
    }

    private func updateTemporaryVotePercentages(previousSelectedDot: UIButton?) {
        guard let selectedDot = viewModel.selectedDot,
              let optionLabel = selectedDot.superview?.subviews.first(where: { $0 is UILabel }) as? UILabel else {
            return
        }

        let selectedOption = optionLabel.text ?? "Unknown"
        let selectedOptionIndex = viewModel.poll?.textOptions.firstIndex(of: selectedOption) ?? -1
        if selectedOptionIndex == -1 {
            return
        }

        if viewModel.votes.isEmpty {
            viewModel.votes = Array(repeating: 0, count: viewModel.poll?.textOptions.count ?? 0)
        }

        if let previousSelectedDot = previousSelectedDot,
           let previousOptionLabel = previousSelectedDot.superview?.subviews.first(where: { $0 is UILabel }) as? UILabel,
           let previousOptionIndex = viewModel.poll?.textOptions.firstIndex(of: previousOptionLabel.text ?? "") {
            if previousOptionIndex != selectedOptionIndex {
                viewModel.votes[previousOptionIndex] = max(0, viewModel.votes[previousOptionIndex] - 1)
            }
        }

        viewModel.votes[selectedOptionIndex] += 1

        updateUIWithVotePercentages(viewModel.votes)
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

    @objc private func submitButtonTapped() {
        var errorMessage = ""

        if let textOptions = viewModel.poll?.textOptions, !textOptions.isEmpty, viewModel.selectedDot == nil {
            errorMessage = "Please select an option."
        }

        if let options = viewModel.poll?.options {
            if options.contains("Added Date Option") && viewModel.selectedDate == nil {
                errorMessage = "Please select a date."
            }

            if options.contains("Added Time Option") && viewModel.selectedTime == nil {
                errorMessage = "Please select a time."
            }
        }

        if !errorMessage.isEmpty {
            let alertController = UIAlertController(title: "Incomplete Form", message: errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }

        var selectedOptionIndex: Int? = nil
        if let selectedDot = viewModel.selectedDot,
           let optionLabel = selectedDot.superview?.subviews.first(where: { $0 is UILabel }) as? UILabel,
           let textOptions = viewModel.poll?.textOptions {
            let selectedOption = optionLabel.text ?? "Unknown"
            selectedOptionIndex = textOptions.firstIndex(of: selectedOption)
            if selectedOptionIndex == -1 {
                print("Selected option not found in poll options")
                return
            }
            print("Selected option: \(selectedOption)")
        }

        viewModel.savePollResponse(selectedOptionIndex: selectedOptionIndex) { error in
            if let error = error {
                print("Failed to save poll response: \(error.localizedDescription)")
            } else {
                print("Poll response saved successfully")
              self.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func fetchUserSelections() {
        viewModel.fetchUserSelections { [weak self] (userSelections, error) in
            if let error = error {
                print("Failed to fetch user selections: \(error.localizedDescription)")
                return
            }

            guard let userSelections = userSelections else { return }

            if let selectedDateID = userSelections["dateOptions"] as? String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                if let selectedDate = dateFormatter.date(from: selectedDateID) {
                    self?.viewModel.selectedDate = selectedDate
                }
            }

            if let selectedTimeID = userSelections["timeOptions"] as? String {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                if let selectedTime = timeFormatter.date(from: selectedTimeID) {
                    self?.viewModel.selectedTime = selectedTime
                }
            }

            if let selectedOptionIndex = userSelections["textOptions"] as? String,
               let index = Int(selectedOptionIndex),
               index < (self?.viewModel.poll?.textOptions.count ?? 0) {
                let selectedOption = self?.viewModel.poll?.textOptions[index]
                self?.setSelectedOption(selectedOption)
            }

            self?.fetchTextOptionVotesAndUpdateUI()
            self?.updateUIWithSelections()
        }
    }

    private func fetchTextOptionVotesAndUpdateUI() {
        viewModel.fetchTextOptionVotes { [weak self] (fetchedVotes, error) in
            if let error = error {
                print("Failed to fetch text option votes: \(error.localizedDescription)")
                return
            }

            guard let fetchedVotes = fetchedVotes else { return }
            self?.viewModel.votes = fetchedVotes

            self?.updateUIWithVotePercentages(fetchedVotes)
        }
    }

    private func setSelectedOption(_ option: String?) {
        guard let option = option else { return }
        for subview in contentView.subviews {
            if let stackView = subview as? UIStackView {
                for optionView in stackView.arrangedSubviews {
                    if let label = optionView.subviews.first(where: { $0 is UILabel }) as? UILabel, label.text == option {
                        if let dotButton = optionView.subviews.first(where: { $0 is UIButton }) as? UIButton {
                            dotButtonTapped(dotButton)
                        }
                    }
                }
            }
        }
    }

    private func updateUIWithSelections() {
        for subview in contentView.subviews {
            for innerSubview in subview.subviews {
                if let datePicker = innerSubview as? UIDatePicker, datePicker.datePickerMode == .date {
                    if let selectedDate = viewModel.selectedDate {
                        datePicker.date = selectedDate
                    }
                }
                if let timePicker = innerSubview as? UIDatePicker, timePicker.datePickerMode == .time {
                    if let selectedTime = viewModel.selectedTime {
                        timePicker.date = selectedTime
                    }
                }
            }
        }
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
}

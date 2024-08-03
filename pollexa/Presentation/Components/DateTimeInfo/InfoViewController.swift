//
//  InfoViewController.swift
//  pollexa
//
//  Created by Selman Aslan on 11.06.2024.
//

import UIKit

import SnapKit

class InfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var optionVotes: [(option: String, votes: Int)] = []
    private let tableView = UITableView()
    private let viewModel = InfoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        viewModel.optionVotes = optionVotes
        viewModel.sortOptionVotesByPercentage()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.optionVotes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let optionVote = viewModel.optionVotes[indexPath.row]
        let totalVotes = viewModel.getTotalVotes()
        let percentage = totalVotes > 0 ? (Double(optionVote.votes) / Double(totalVotes)) * 100 : 0
        cell.textLabel?.text = "\(optionVote.option): \(String(format: "%.0f%% (%d votes)", percentage, optionVote.votes))"
        return cell
    }
}

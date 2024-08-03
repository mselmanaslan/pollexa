//
//  AllPollsViewController.swift
//  pollexa
//
//  Created by Selman Aslan on 7.06.2024.
//

import Foundation
import UIKit
import SnapKit

class AllPollsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let viewModel = AllPollsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainBackgroundColor")
        title = "Polls"
        setupNavigationBarAppearance()
        setupFilterButton()
        setupTableView()
        
        viewModel.onPollsFetched = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { error in
            print("Error fetching polls: \(error.localizedDescription)")
        }
        
        viewModel.fetchAllPolls()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchAllPolls()
    }
    
    private func setupFilterButton() {
        let filterButton = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain,
            target: self,
            action: #selector(filterPolls)
        )
        filterButton.tintColor = UIColor(named: "TextColor")
        navigationItem.rightBarButtonItem = filterButton
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PollCell.self, forCellReuseIdentifier: "PollCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "MainBackgroundColor")
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "MainBackgroundColor")
        appearance.shadowColor = .clear
        
        appearance.titleTextAttributes = [
          .foregroundColor: UIColor(named: "TextColor") ?? .darkGray,
            .font: UIFont.boldSystemFont(ofSize: 24)
        ]
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(named: "TextColor") ?? .darkGray,
            .font: UIFont.boldSystemFont(ofSize: 32)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [
          .foregroundColor: UIColor(named: "TextColor") ?? .darkGray,
            .font: UIFont.systemFont(ofSize: 20)
        ]
        appearance.buttonAppearance = buttonAppearance
    }
    
    @objc func filterPolls() {
        print("Filter button tapped")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.polls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PollCell", for: indexPath) as! PollCell
        let poll = viewModel.polls[indexPath.row]
        cell.configure(with: PollCellViewModel(poll: poll))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let poll = viewModel.polls[indexPath.row]
        let pollDetailsVC = PollDetailsViewController(poll: poll)
        navigationController?.pushViewController(pollDetailsVC, animated: true)
    }
}

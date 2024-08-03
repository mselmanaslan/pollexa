//
//  MyPollsViewController.swift
//  pollexa
//
//  Created by Selman Aslan on 7.06.2024.
//

import Foundation
import UIKit
import SnapKit

class MyPollsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let viewModel = MyPollsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainBackgroundColor")
        title = "My Polls"
        setupNavigationBarAppearance()
        setupAddPollButton()
        setupTableView()
        setupBindings()
        
        // İlk fetch işlemi
        viewModel.fetchUserPolls()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Her görünüm belirdiğinde fetch işlemi ve tabloyu yeniden yükleme
        viewModel.fetchUserPolls()
    }
    
    private func setupAddPollButton() {
        let addPollButton = UIBarButtonItem(
            image: UIImage(systemName: "doc.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(addPoll)
        )
        addPollButton.tintColor = UIColor(named: "TextColor")
        navigationItem.rightBarButtonItem = addPollButton
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
    
    private func setupBindings() {
        viewModel.reloadTableView = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc func addPoll() {
        let addPollVC = AddPollViewController()
        self.navigationController?.pushViewController(addPollVC, animated: true)
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
        let detailsVC = MyPollsDetailsViewController(poll: poll)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

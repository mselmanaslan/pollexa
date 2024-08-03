//
//  MyPollsViewModel.swift
//  pollexa
//
//  Created by Selman Aslan on 7.06.2024.
//

import Foundation

class MyPollsViewModel {
    private let pollService = PollService()
    var polls: [Poll] = []
    var reloadTableView: (() -> Void)?
    
    func fetchUserPolls() {
      print("fetchUserPolls")
        pollService.fetchUserPolls { [weak self] (polls, error) in
            if let error = error {
                print("Error fetching polls: \(error.localizedDescription)")
            } else {
                self?.polls = polls ?? []
                self?.reloadTableView?()
            }
        }
    }
}

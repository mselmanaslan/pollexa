//
//  AllPollsViewModel.swift
//  pollexa
//
//  Created by Selman Aslan on 7.06.2024.
//

import Foundation

import Foundation

class AllPollsViewModel {
    private let pollService = PollService()
    var polls: [Poll] = []
    var onPollsFetched: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func fetchAllPolls() {
        pollService.fetchAllPolls { [weak self] (polls, error) in
            if let error = error {
                self?.onError?(error)
            } else if let polls = polls {
                self?.polls = polls
                self?.onPollsFetched?()
            }
        }
    }
}


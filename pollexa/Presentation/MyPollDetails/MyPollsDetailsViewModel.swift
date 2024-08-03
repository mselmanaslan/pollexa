//
//  MyPollsDetailsViewModel.swift
//  pollexa
//
//  Created by Selman Aslan on 11.06.2024.
//

import Foundation

class MyPollsDetailsViewModel {
    private let pollService = PollService()
    private let poll: Poll
    
    var pollTitle: String {
        return poll.title
    }
    
    var pollDescription: String {
        return poll.description
    }
    
    var pollOptions: [String] {
        return poll.options
    }
    
    var pollTextOptions: [String] {
        return poll.textOptions
    }
    
    var reloadView: (() -> Void)?
    var onDeleteSuccess: (() -> Void)?
    var onDeleteFailure: ((String) -> Void)?
    var votes: [Int] = []
    
    init(poll: Poll) {
        self.poll = poll
    }
    
    func fetchVotes() {
        pollService.fetchTextOptionVotes(pollID: poll.id) { [weak self] (fetchedVotes, error) in
            if let error = error {
                print("Failed to fetch text option votes: \(error.localizedDescription)")
                return
            }

            guard let fetchedVotes = fetchedVotes else { return }
            self?.votes = fetchedVotes
            self?.reloadView?()
        }
    }
    
    func deletePoll() {
        pollService.deletePoll(pollID: poll.id) { [weak self] error in
            if let error = error {
                self?.onDeleteFailure?(error.localizedDescription)
            } else {
                self?.onDeleteSuccess?()
            }
        }
    }
    
  func fetchOptionVotes(optionType: String, completion: @escaping ([(option: String, votes: Int)]?) -> Void) {
      pollService.fetchOptionVotes(pollID: poll.id, optionType: optionType) { (optionVotes, error) in
          if let error = error {
              print("Error fetching option votes: \(error.localizedDescription)")
              completion(nil)
          } else {
              completion(optionVotes)
          }
      }
  }
  
}

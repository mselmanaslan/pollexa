//
//  PollDetailsViewModel.swift
//  pollexa
//
//  Created by Selman Aslan on 9.06.2024.
//

import Foundation
import UIKit

class PollDetailsViewModel {
    private let pollService = PollService()
    var poll: Poll?
    var selectedDot: UIButton?
    var selectedDate: Date?
    var selectedTime: Date?
    var votes: [Int] = []

    init(poll: Poll) {
        self.poll = poll
    }

    func fetchUserSelections(completion: @escaping ([String: Any]?, Error?) -> Void) {
        guard let poll = poll else { return }
        pollService.fetchUserSelections(pollID: poll.id, completion: completion)
    }

    func fetchTextOptionVotes(completion: @escaping ([Int]?, Error?) -> Void) {
        guard let poll = poll else { return }
        pollService.fetchTextOptionVotes(pollID: poll.id, completion: completion)
    }

    func savePollResponse(selectedOptionIndex: Int?, completion: @escaping (Error?) -> Void) {
        guard let poll = poll else { return }
        pollService.savePollResponse(pollID: poll.id, selectedOptionIndex: selectedOptionIndex ?? 99, selectedDate: selectedDate, selectedTime: selectedTime, completion: completion)
    }

    func fetchOptionVotes(optionType: String, completion: @escaping ([(option: String, votes: Int)]?) -> Void) {
        guard let poll = poll else { return }
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


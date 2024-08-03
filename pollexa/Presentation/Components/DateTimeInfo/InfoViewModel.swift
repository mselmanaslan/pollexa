//
//  InfoViewModel.swift
//  pollexa
//
//  Created by Selman Aslan on 11.06.2024.
//

import Foundation

class InfoViewModel {
    var optionVotes: [(option: String, votes: Int)] = []

    func sortOptionVotesByPercentage() {
        let totalVotes = optionVotes.map { $0.votes }.reduce(0, +)
        optionVotes.sort {
            let percentage0 = totalVotes > 0 ? (Double($0.votes) / Double(totalVotes)) * 100 : 0
            let percentage1 = totalVotes > 0 ? (Double($1.votes) / Double(totalVotes)) * 100 : 0
            return percentage0 > percentage1
        }
    }

    func getTotalVotes() -> Int {
        return optionVotes.map { $0.votes }.reduce(0, +)
    }
}

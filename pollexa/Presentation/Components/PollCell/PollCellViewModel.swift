//
//  PollCellViewModel.swift
//  pollexa
//
//  Created by Selman Aslan on 9.06.2024.
//

import Foundation

class PollCellViewModel {
    var poll: Poll

    var title: String {
        return poll.title
    }

    var description: String {
        return poll.description
    }

    var addedBy: String {
        return "@" + poll.addedBy
    }

    var totalVotes: String {
        return "\(poll.totalVotes ?? 0)"
    }

    init(poll: Poll) {
        self.poll = poll
    }
}

//
//  Poll.swift
//  pollexa
//
//  Created by Selman Aslan on 8.06.2024.
//

import Foundation
import FirebaseFirestore

struct Poll {
    var id: String
    var title: String
    var description: String
    var options: [String]
    var textOptions: [String]
    var addedBy: String
    var createdAt: Date
    var totalVotes: Int? // Total votes for the poll
    
    init(id: String, title: String, description: String, options: [String], textOptions: [String], addedBy: String, createdAt: Date, totalVotes: Int? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.options = options
        self.textOptions = textOptions
        self.addedBy = addedBy
        self.createdAt = createdAt
        self.totalVotes = totalVotes
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let title = dictionary["title"] as? String,
              let description = dictionary["description"] as? String,
              let optionsArray = dictionary["options"] as? NSArray,
              let textOptionsArray = dictionary["textOptions"] as? NSArray,
              let addedBy = dictionary["addedBy"] as? String,
              let timestamp = dictionary["createdAt"] as? Timestamp else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.description = description
        self.options = optionsArray.compactMap { $0 as? String }
        self.textOptions = textOptionsArray.compactMap { $0 as? String }
        self.addedBy = addedBy
        self.createdAt = timestamp.dateValue()
        self.totalVotes = dictionary["totalVotes"] as? Int
    }
}

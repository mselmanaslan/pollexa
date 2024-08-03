//
//  AddPollViewModel.swift
//  pollexa
//
//  Created by Selman Aslan on 7.06.2024.
//

import Foundation

class AddPollViewModel {
    private let pollService: PollService
    
    var title: String = ""
    var description: String = ""
    var options: [String] = []
    var textOptions: [String] = []
    var hasDatePicker: Bool = false
    var hasTimePicker: Bool = false
    var hasTextOptions: Bool = false
    
    init(pollService: PollService = PollService()) {
        self.pollService = pollService
    }
    
    func validateFields() -> String? {
        if title.isEmpty {
            return "Title is required."
        }
        
        if description.isEmpty {
            return "Description is required."
        }
        
        if options.isEmpty {
            return "Please add at least one option before saving."
        }
        
        if hasTextOptions {
            var uniqueTextOptions = Set<String>()
            for textOption in textOptions {
                if textOption.isEmpty {
                    return "Please fill in all text options."
                }
                if uniqueTextOptions.contains(textOption) {
                    return "Duplicate text options are not allowed."
                }
                uniqueTextOptions.insert(textOption)
            }
        }
        
        return nil
    }
    
    func addDatePickerOption() {
        hasDatePicker = true
        options.append("Added Date Option")
    }
    
    func addTimePickerOption() {
        hasTimePicker = true
        options.append("Added Time Option")
    }
    
    func addTextOptions(numberOfOptions: Int) {
        hasTextOptions = true
        options.append("Added Text Options")
        for _ in 0..<numberOfOptions {
            textOptions.append("")
        }
    }
    
    func updateTextOption(at index: Int, with text: String) {
        if index >= 0 && index < textOptions.count {
            textOptions[index] = text
        }
    }
    
    func removeDatePickerOption() {
        hasDatePicker = false
        options.removeAll { $0 == "Added Date Option" }
    }
    
    func removeTimePickerOption() {
        hasTimePicker = false
        options.removeAll { $0 == "Added Time Option" }
    }
    
    func savePoll(completion: @escaping (Error?) -> Void) {
        let poll = Poll(
            id: UUID().uuidString,
            title: title,
            description: description,
            options: options,
            textOptions: textOptions,
            addedBy: "currentUser",
            createdAt: Date()
        )
        
        pollService.savePoll(poll: poll, completion: completion)
    }
}

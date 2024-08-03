//
//  PollService.swift
//  pollexa
//
//  Created by Selman Aslan on 8.06.2024.
//

import Foundation
import FirebaseFirestore

class PollService {
  private let db = Firestore.firestore()
  private let userDefaults = UserDefaults.standard
  
  func savePoll(poll: Poll, completion: @escaping (Error?) -> Void) {
      guard let addedByEmail = userDefaults.string(forKey: "loggedInUserEmail") else {
          let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
          completion(error)
          return
      }
      
      let data: [String: Any] = [
          "id": poll.id,
          "title": poll.title,
          "description": poll.description,
          "options": poll.options,
          "textOptions": poll.textOptions,
          "addedBy": addedByEmail,
          "createdAt": poll.createdAt
      ]
      
      let pollDocument = db.collection("polls").document(poll.id)
      
      // Add the main poll data
      pollDocument.setData(data) { error in
          if let error = error {
              completion(error)
              return
          }
          
          // Create the textOptions collection and add documents for each text option
          let batch = self.db.batch()
          let textOptionsRef = pollDocument.collection("textOptions")
          
          for (index, _) in poll.textOptions.enumerated() {
              let optionKey = "\(index)"
              let optionRef = textOptionsRef.document(optionKey)
              batch.setData(["votes": []], forDocument: optionRef)
          }
          
          batch.commit(completion: completion)
      }
  }
  
  func fetchUserPolls(completion: @escaping ([Poll]?, Error?) -> Void) {
      guard let userEmail = userDefaults.string(forKey: "loggedInUserEmail") else {
          let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
          completion(nil, error)
          return
      }
      
      db.collection("polls")
          .whereField("addedBy", isEqualTo: userEmail)
          .order(by: "createdAt", descending: true)
          .getDocuments { (snapshot, error) in
              if let error = error {
                  completion(nil, error)
              } else {
                  guard let documents = snapshot?.documents else {
                      completion([], nil)
                      return
                  }
                  var polls: [Poll] = []
                  let dispatchGroup = DispatchGroup()
                  
                  for document in documents {
                      dispatchGroup.enter()
                      var pollData = document.data()
                      
                      self.fetchTotalVotes(for: document.documentID) { totalVotes, error in
                          if let totalVotes = totalVotes {
                              pollData["totalVotes"] = totalVotes
                          }
                          
                          if let poll = Poll(dictionary: pollData) {
                              polls.append(poll)
                          }
                          dispatchGroup.leave()
                      }
                  }
                  
                  dispatchGroup.notify(queue: .main) {
                      completion(polls.sorted { $0.createdAt > $1.createdAt }, nil)
                  }
              }
          }
  }

  func fetchAllPolls(completion: @escaping ([Poll]?, Error?) -> Void) {
      db.collection("polls")
          .order(by: "createdAt", descending: true)
          .getDocuments { (snapshot, error) in
              if let error = error {
                  completion(nil, error)
              } else {
                  guard let documents = snapshot?.documents else {
                      completion([], nil)
                      return
                  }
                  var polls: [Poll] = []
                  let dispatchGroup = DispatchGroup()
                  
                  for document in documents {
                      dispatchGroup.enter()
                      var pollData = document.data()
                      
                      self.fetchTotalVotes(for: document.documentID) { totalVotes, error in
                          if let totalVotes = totalVotes {
                              pollData["totalVotes"] = totalVotes
                          }
                          
                          if let poll = Poll(dictionary: pollData) {
                              polls.append(poll)
                          }
                          dispatchGroup.leave()
                      }
                  }
                  
                  dispatchGroup.notify(queue: .main) {
                      completion(polls.sorted { $0.createdAt > $1.createdAt }, nil)
                  }
              }
          }
  }


  
  func savePollResponse(pollID: String, selectedOptionIndex: Int?, selectedDate: Date?, selectedTime: Date?, completion: @escaping (Error?) -> Void) {
         guard let userEmail = userDefaults.string(forKey: "loggedInUserEmail") else {
             let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
             completion(error)
             return
         }

         let pollDocument = db.collection("polls").document(pollID)

         // Önce mevcut oyları kaldır
         removeExistingVotes(for: pollDocument, userEmail: userEmail) { error in
             if let error = error {
                 completion(error)
                 return
             }

           let batch = self.db.batch()

             if let selectedDate = selectedDate {
                 let dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "dd-MM-yyyy"
                 let formattedDate = dateFormatter.string(from: selectedDate)
                 let dateRef = pollDocument.collection("dateOptions").document(formattedDate)
                 batch.setData(["votes": FieldValue.arrayUnion([userEmail])], forDocument: dateRef, merge: true)
             }

             if let selectedTime = selectedTime {
                 let timeFormatter = DateFormatter()
                 timeFormatter.dateFormat = "HH:mm"
                 let formattedTime = timeFormatter.string(from: selectedTime)
                 let timeRef = pollDocument.collection("timeOptions").document(formattedTime)
                 batch.setData(["votes": FieldValue.arrayUnion([userEmail])], forDocument: timeRef, merge: true)
             }

           if let selectedOptionIndex = selectedOptionIndex, selectedOptionIndex != 99 {
                let textOptionsRef = pollDocument.collection("textOptions")
                let optionsKey = "\(selectedOptionIndex)"
                let optionRef = textOptionsRef.document(optionsKey)
                batch.setData(["votes": FieldValue.arrayUnion([userEmail])], forDocument: optionRef, merge: true)
            }
           
             batch.commit(completion: completion)
         }
     }

     private func removeExistingVotes(for pollDocument: DocumentReference, userEmail: String, completion: @escaping (Error?) -> Void) {
         let collections = ["dateOptions", "timeOptions", "textOptions"]
         let batch = db.batch()
         var errors: [Error] = []

         let dispatchGroup = DispatchGroup()

         for collection in collections {
             dispatchGroup.enter()
             pollDocument.collection(collection).getDocuments { snapshot, error in
                 if let error = error {
                     errors.append(error)
                     dispatchGroup.leave()
                     return
                 }

                 snapshot?.documents.forEach { document in
                     batch.updateData(["votes": FieldValue.arrayRemove([userEmail])], forDocument: document.reference)
                 }

                 dispatchGroup.leave()
             }
         }

         dispatchGroup.notify(queue: .main) {
             if errors.isEmpty {
                 batch.commit { error in
                     completion(error)
                 }
             } else {
                 completion(errors.first)
             }
         }
     }
     
     func fetchUserSelections(pollID: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
         guard let userEmail = userDefaults.string(forKey: "loggedInUserEmail") else {
             let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
             completion(nil, error)
             return
         }
         
         let pollDocument = db.collection("polls").document(pollID)
         var userSelections: [String: Any] = [:]
         let dispatchGroup = DispatchGroup()
         
         let collections = ["dateOptions", "timeOptions", "textOptions"]
         
         for collection in collections {
             dispatchGroup.enter()
             pollDocument.collection(collection).getDocuments { snapshot, error in
                 if let error = error {
                     dispatchGroup.leave()
                     completion(nil, error)
                     return
                 }
                 
                 for document in snapshot!.documents {
                     if let votes = document.data()["votes"] as? [String], votes.contains(userEmail) {
                         userSelections[collection] = document.documentID
                     }
                 }
                 dispatchGroup.leave()
             }
         }
         
         dispatchGroup.notify(queue: .main) {
             completion(userSelections, nil)
         }
     }
  
  func fetchTextOptionVotes(pollID: String, completion: @escaping ([Int]?, Error?) -> Void) {
          let pollDocument = db.collection("polls").document(pollID)
          let textOptionsRef = pollDocument.collection("textOptions")
          
          textOptionsRef.getDocuments { snapshot, error in
              if let error = error {
                  completion(nil, error)
                  return
              }
              
              guard let documents = snapshot?.documents else {
                  completion(nil, nil)
                  return
              }
              
              var votes: [Int] = []
              for document in documents {
                  if let votesArray = document.data()["votes"] as? [String] {
                      votes.append(votesArray.count)
                  } else {
                      votes.append(0)
                  }
              }
              
              completion(votes, nil)
          }
      }
  
  func fetchOptionVotes(pollID: String, optionType: String, completion: @escaping ([(option: String, votes: Int)]?, Error?) -> Void) {
      let pollDocument = db.collection("polls").document(pollID)
      let optionsRef = pollDocument.collection(optionType)
      
      optionsRef.getDocuments { snapshot, error in
          if let error = error {
              completion(nil, error)
              return
          }
          
          guard let documents = snapshot?.documents else {
              completion(nil, nil)
              return
          }
          
          var optionVotes: [(option: String, votes: Int)] = []
          for document in documents {
              if let votesArray = document.data()["votes"] as? [String] {
                  optionVotes.append((option: document.documentID, votes: votesArray.count))
              } else {
                  optionVotes.append((option: document.documentID, votes: 0))
              }
          }
          
          completion(optionVotes, nil)
      }
  }
  
  func fetchTotalVotes(for pollID: String, completion: @escaping (Int?, Error?) -> Void) {
      let pollDocument = db.collection("polls").document(pollID)
      var totalVotes = 0
      
      let dispatchGroup = DispatchGroup()
      var foundVotes = false
      
      // Text options
      dispatchGroup.enter()
      pollDocument.collection("textOptions").getDocuments { snapshot, error in
          if let error = error {
              dispatchGroup.leave()
              completion(nil, error)
              return
          }
          
          if let documents = snapshot?.documents, !documents.isEmpty {
              foundVotes = true
              for document in documents {
                  if let votesArray = document.data()["votes"] as? [String] {
                      totalVotes += votesArray.count
                  }
              }
          }
          dispatchGroup.leave()
      }
      
      dispatchGroup.notify(queue: .main) {
          if foundVotes {
              completion(totalVotes, nil)
          } else {
              // Time options
              dispatchGroup.enter()
              pollDocument.collection("timeOptions").getDocuments { snapshot, error in
                  if let error = error {
                      dispatchGroup.leave()
                      completion(nil, error)
                      return
                  }
                  
                  if let documents = snapshot?.documents, !documents.isEmpty {
                      foundVotes = true
                      for document in documents {
                          if let votesArray = document.data()["votes"] as? [String] {
                              totalVotes += votesArray.count
                          }
                      }
                  }
                  dispatchGroup.leave()
              }
              
              dispatchGroup.notify(queue: .main) {
                  if foundVotes {
                      completion(totalVotes, nil)
                  } else {
                      // Date options
                      dispatchGroup.enter()
                      pollDocument.collection("dateOptions").getDocuments { snapshot, error in
                          if let error = error {
                              dispatchGroup.leave()
                              completion(nil, error)
                              return
                          }
                          
                          if let documents = snapshot?.documents, !documents.isEmpty {
                              foundVotes = true
                              for document in documents {
                                  if let votesArray = document.data()["votes"] as? [String] {
                                      totalVotes += votesArray.count
                                  }
                              }
                          }
                          dispatchGroup.leave()
                      }
                      
                      dispatchGroup.notify(queue: .main) {
                          completion(totalVotes, nil)
                      }
                  }
              }
          }
      }
  }
  
  func deletePoll(pollID: String, completion: @escaping (Error?) -> Void) {
      let pollDocument = db.collection("polls").document(pollID)
      
      pollDocument.delete { error in
          completion(error)
      }
  }


 }

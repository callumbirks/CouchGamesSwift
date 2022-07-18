//
//  HighScores.swift
//  CouchbaseGamesSwift
//
//  Created by Callum Birks on 18/07/2022.
//

import Foundation
import CouchbaseLiteSwift

class Score {
    let email: String
    let name: String
    let score: Int
    
    init(email: String, name: String, score: Int) {
        self.email = email
        self.name = name
        self.score = score
    }
    
    convenience init(doc: Document) {
        guard let email = doc.string(forKey: "email"),
              let name = doc.string(forKey: "name"),
              let score = doc.number(forKey: "score")?.intValue
        else {
            print("Error initializing Score object from document with id \(doc.id)")
            fatalError()
        }
        self.init(email: email, name: name, score: score)
    }
    
    var description: String {
        "\(self.email) \(self.name) \(self.score)"
    }
}

class HighScores {
    var scores: Array<Score>
    
    private static let exampleScores: Array<Score> =
    [  Score(email: "john@example.com", name: "John Adams", score: 42),
       Score(email: "paul@example.com", name: "Paul Stone", score: 58),
       Score(email: "jane@example.com", name: "Jane Smith", score: 100),
       Score(email: "sally@example.com", name: "Sally Brown", score: 121) ]
    
    // Initializes the scores array and populates it with the above example data
    init() {
        let database = DBManager.shared.database
        self.scores = Array(HighScores.exampleScores)
        do {
            try database.inBatch {
                for score in scores {
                    let doc = MutableDocument(id: score.email)
                    doc.setString(score.email, forKey: "email")
                    doc.setString(score.name, forKey: "name")
                    doc.setNumber(score.score as NSNumber, forKey: "score")
                    do {
                        try database.saveDocument(doc)
                    } catch {
                        debugPrint(error)
                    }
                }
            }
        } catch {
            debugPrint(error)
            fatalError()
        }
    }
    
    func outputContents() -> Bool {
        let database = DBManager.shared.database
        for score in scores {
            guard let doc = database.document(withID: score.email)
            else {
                print("Error locating document with id: \(score.email)")
                return false
            }
            let score = Score(doc: doc)
            print("The retrieved document contains: \(score.description)")
        }
        return true
    }
    
    func updateHighScores() -> Bool {
        let database = DBManager.shared.database
        for score in scores {
            guard let mutableDoc = database.document(withID: score.email)?.toMutable()
            else {
                print("Error locating document with id: \(score.email)")
                return false
            }
            
            mutableDoc.setNumber(Int.random(in: 1...1000000) as NSNumber, forKey: "score")
            mutableDoc.setString("2018-10-01", forKey: "date")
            
            do {
                try database.saveDocument(mutableDoc)
            } catch {
                debugPrint(error)
                return false
            }
        }
        return true
    }
}

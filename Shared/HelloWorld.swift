//
//  HelloWorld.swift
//  CouchbaseGamesSwift
//
//  Created by Callum Birks on 18/07/2022.
//

import Foundation
import CouchbaseLiteSwift

class HelloWorld {
    func helloCBL() {
        let database = DBManager.shared.database
        
        let docID = self.createDocument(database: database)
        self.outputContents(database: database, docID: docID)
        self.updateDocument(database: database, docID: docID)
        self.deleteDocument(database: database, docID: docID)
    }
    
    private func createDocument(database: Database) -> String {
        let doc = MutableDocument()
        let docID = doc.id
        doc.setString("John Adams", forKey: "name")
        doc.setString("42", forKey: "score")
        
        do {
            try database.saveDocument(doc)
        } catch {
            debugPrint(error)
        }
        
        return docID
    }
    
    private func outputContents(database: Database, docID: String) {
        guard let doc = database.document(withID: docID)
        else {
            print("Error locating document with ID: \(docID)")
            return
        }
        print("The retrieved document contains: \(doc)")
    }
    
    private func updateDocument(database: Database, docID: String) {
        guard let doc = database.document(withID: docID)?.toMutable()
        else {
            print("Error locating document with ID: \(docID)")
            return
        }
        doc.setString("1337", forKey: "score")
        doc.setString("Space Invaders", forKey: "game")
        
        do {
            try database.saveDocument(doc)
        } catch {
            debugPrint(error)
        }
    }
    
    private func deleteDocument(database: Database, docID: String) {
        guard let doc = database.document(withID: docID)
        else {
            print("Error locating document with ID: \(docID)")
            return
        }
        do {
            try database.deleteDocument(doc)
        } catch {
            debugPrint(error)
        }
    }
}

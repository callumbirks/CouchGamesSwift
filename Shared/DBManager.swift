//
//  DBManager.swift
//  CouchbaseGamesSwift
//
//  Created by Callum Birks on 18/07/2022.
//

import Foundation
import CouchbaseLiteSwift

class DBManager {
    let database: Database
    
    init(_ dbName: String) {
        do {
            self.database = try Database(name: dbName)
        } catch {
            debugPrint(error)
            fatalError()
        }
    }
    static let dbname: String = "couchbasegames"
    static let syncURL: URL = URL(string: "ws://locahost:4984/couchbasegames")!
    // A singleton object to access the database without re-opening it constantly
    static let shared: DBManager = DBManager(dbname)
}

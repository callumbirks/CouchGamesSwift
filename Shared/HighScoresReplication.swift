//
//  HighScoresReplication.swift
//  CouchbaseGamesSwift
//
//  Created by Callum Birks on 18/07/2022.
//

import Foundation
import CouchbaseLiteSwift

class HighScoresReplication {
    
    let replicator: Replicator
    
    // Initializes replicator and starts a push and pull sync
    init() {
        let database = DBManager.shared.database
        let target = URLEndpoint(url: DBManager.syncURL)
        let listener: (ReplicatorChange) -> Void = { change in
            let total: UInt64 = change.status.progress.total
            let completed: UInt64 = change.status.progress.completed
            print("Replication: \(completed)/\(total)")
            print(change.status)
        }
        self.replicator = Replicator(database: database, target: target, type: .pushAndPull, listener: listener)
        
        self.startSync()
    }
    
    func startSync() {
        replicator.start()
    }
}

// Add an initializer that is extremely convenient for our purposes and avoids repeated code
extension Replicator {
    convenience init(database: Database, target: URLEndpoint, type: ReplicatorType, listener: @escaping (ReplicatorChange) -> Void) {
        var config = ReplicatorConfiguration(database: database, target: target)
        config.replicatorType = type
        config.authenticator = BasicAuthenticator(username: "bork",
                                                  password: "password")
        self.init(config: config)
        self.addChangeListener(listener)
    }
}

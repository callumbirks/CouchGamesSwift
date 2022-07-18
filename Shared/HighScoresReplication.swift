//
//  HighScoresReplication.swift
//  CouchbaseGamesSwift
//
//  Created by Callum Birks on 18/07/2022.
//

import Foundation
import CouchbaseLiteSwift

class HighScoresReplication {
    
    let push: Replicator
    let pull: Replicator
    
    // Initializes push and pull replicators and starts a replication on each
    init() {
        let database = DBManager.shared.database
        let target = URLEndpoint(url: DBManager.syncURL)
        // Create a single listener that can be used in both push and pull replicators to avoid repeated code
        let listener: (ReplicatorChange) -> Void = { change in
            let total: UInt64 = change.status.progress.total
            let completed: UInt64 = change.status.progress.completed
            print("\(change.replicator.config.replicatorType) replication: \(completed)/\(total)")
        }
        self.push = Replicator(database: database, target: target, type: .push, listener: listener)
        self.pull = Replicator(database: database, target: target, type: .pull, listener: listener)
        
        startPush()
        startPull()
    }
    
    func startPush() {
        self.push.start()
    }
    
    func startPull() {
        self.pull.start()
    }
}

// Add an initializer that is extremely convenient for our purposes and avoids repeated code
extension Replicator {
    convenience init(database: Database, target: URLEndpoint, type: ReplicatorType, listener: @escaping (ReplicatorChange) -> Void) {
        var config = ReplicatorConfiguration(database: database, target: target)
        config.replicatorType = type
        self.init(config: config)
        self.addChangeListener(listener)
    }
}

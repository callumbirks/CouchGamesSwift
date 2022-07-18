//
//  CouchbaseGamesSwiftApp.swift
//  Shared
//
//  Created by Callum Birks on 18/07/2022.
//

import SwiftUI

@main
struct CouchbaseGamesSwiftApp: App {
    
    init() {
        let helloWorld = HelloWorld()
        helloWorld.helloCBL()
        
        let highScores = HighScores()
        highScores.outputContents()
        
        let highScoresReplication = HighScoresReplication()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

//
//  Game.swift
//  WhoWantToBe
//
//  Created by aprirez on 12/12/20.
//

import Foundation

class Game {
    static let shared = Game()
    private let recordsCaretaker = RecordsCaretaker()
    
    var session: GameSession?
    
    
    private(set) var records: [Record] {
        didSet {
            recordsCaretaker.save(records: self.records)
        }
    }

    private init() {
        self.records = self.recordsCaretaker.retrieveRecords()
        
    }
}


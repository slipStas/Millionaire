//
//  GameCaretaker.swift
//  Millionaire
//
//  Created by Stanislav Slipchenko on 08.05.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import Foundation

class GameCaretaker {
    
    static let shared = GameCaretaker()
    private let fileName = "records.data"
    
    var filePath: URL? {
        guard let filePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        return filePath.appendingPathComponent(fileName, isDirectory: false)
    }
    
    func save(records: [GameSession]) throws {
        let data = try JSONEncoder().encode(records)
        try data.write(to: filePath!)
    }
    
    func load() throws -> [GameSession] {
        let data = try Data(contentsOf: filePath!)
        return try JSONDecoder().decode([GameSession].self, from: data)
    }
}

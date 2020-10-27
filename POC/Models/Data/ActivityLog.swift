//
//  ActivityLog.swift
//  POC
//
//  Created by Mark Randall on 10/27/20.
//

import Foundation

struct ActivityLog: Decodable {
    let created: Date
    let entity: String
    let value: Double
}

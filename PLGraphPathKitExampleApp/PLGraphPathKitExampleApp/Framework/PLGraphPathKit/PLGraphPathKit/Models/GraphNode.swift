//
//  GraphNodeModel.swift
//  PLGraphPathKit
//
//  Created by Turker Alan on 16.01.2025.
//

import Foundation

public struct GraphNode: Codable {
    public let id: String
    let pointType: String
    let edges: [GraphEdge]
}



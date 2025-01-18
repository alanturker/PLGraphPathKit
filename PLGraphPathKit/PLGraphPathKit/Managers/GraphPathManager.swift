//
//  GraphPathManager.swift
//  PLGraphPathKit
//
//  Created by Turker Alan on 16.01.2025.
//

import Foundation

public class GraphPathManager {

    public var nodes: [String: GraphNode] = [:]
    
    public func getNodes(from jsonData: Data) throws {
        let decoder = JSONDecoder()
        let graphData = try decoder.decode([GraphNode].self, from: jsonData)
        
        for data in graphData {
            nodes[data.id] = data
        }
    }
    
    public func getNodesByPointType(_ pointType: String) -> [GraphNode] {
        return nodes.values.filter { $0.pointType == pointType }
    }
    
    private func dijkstra(from startNodeId: String) -> [String: Double]? {
        guard let _ = nodes[startNodeId] else { return nil }
        
        var distances: [String: Double] = [:]
        var priorityQueue: [(nodeId: String, distance: Double)] = [(startNodeId, 0)]
        
        for node in nodes {
            distances[node.key] = node.key == startNodeId ? 0 : Double.greatestFiniteMagnitude
        }
        
        while !priorityQueue.isEmpty {
            // Sort the queue by distance
            priorityQueue.sort { $0.distance < $1.distance }
            let (currentNodeId, currentDistance) = priorityQueue.removeFirst()
            
            guard let currentNode = nodes[currentNodeId] else { continue }
            
            // Explore neighbors
            for edge in currentNode.edges {
                let neighborNode = nodes[edge.id]
                let newDistance = currentDistance + edge.weight
                if let neighborNode = neighborNode, newDistance < (distances[neighborNode.id] ?? Double.greatestFiniteMagnitude) {
                    distances[neighborNode.id] = newDistance
                    priorityQueue.append((neighborNode.id, newDistance))
                }
            }
        }
        return distances
    }
    
    // Function to find the nearest node with a specific pointType
    public func findNearestNode(withPointType pointType: String, from startNodeId: String) -> GraphNode? {
        guard let distances = dijkstra(from: startNodeId) else { return nil }
        
        var nearestNode: GraphNode?
        var nearestDistance: Double = Double.greatestFiniteMagnitude
        
        // Search for the nearest node with the given pointType
        for (nodeId, distance) in distances {
            if let node = nodes[nodeId], node.pointType == pointType, distance < nearestDistance {
                nearestNode = node
                nearestDistance = distance
            }
        }
        return nearestNode
    }
    
}

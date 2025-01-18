//
//  GraphViewModel.swift
//  PLGraphPathKitExampleApp
//
//  Created by Turker Alan on 17.01.2025.
//

import Foundation
import PLGraphPathKit

protocol GraphViewModelDelegate: AnyObject {
    func didUpdateNodes(_ nodes: [String: GraphNode])
    func didUpdatePath(_ path: [String])
    func didReceiveError(_ error: String)
}

class PLGraphViewModel {
    // MARK: - Properties
    private let graphManager = GraphPathManager()
    weak var delegate: GraphViewModelDelegate?
    
    // MARK: - Public Methods
    func loadGraphData() {
        guard let url = Bundle.main.url(forResource: "graph", withExtension: "json") else {
            delegate?.didReceiveError("Could not find graph.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            try graphManager.getNodes(from: data)
            delegate?.didUpdateNodes(graphManager.nodes)
        } catch {
            delegate?.didReceiveError(error.localizedDescription)
        }
    }
    
    func findNearestNode(type: String, from nodeId: String) {
        if let nearest = graphManager.findNearestNode(withPointType: type, from: nodeId) {
            delegate?.didUpdatePath([nodeId, nearest.id])
        } else {
            delegate?.didReceiveError("No \(type) node found")
        }
    }
}

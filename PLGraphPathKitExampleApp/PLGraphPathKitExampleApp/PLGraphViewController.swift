//
//  ViewController.swift
//  PLGraphPathKitExampleApp
//
//  Created by Turker Alan on 17.01.2025.
//

import UIKit
import PLGraphPathKit

class PLGraphViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = PLGraphViewModel()
    private let graphViewController = GraphViewController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViewController()
        setupDelegates()
        viewModel.loadGraphData()
    }
    
    // MARK: - Private Methods
    private func setupChildViewController() {
        addChild(graphViewController)
        view.addSubview(graphViewController.view)
        graphViewController.view.frame = view.bounds
        graphViewController.didMove(toParent: self)
    }
    
    private func setupDelegates() {
        viewModel.delegate = self
        graphViewController.delegate = self
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - GraphViewModelDelegate
extension PLGraphViewController: GraphViewModelDelegate {
    func didUpdateNodes(_ nodes: [String: GraphNode]) {
        graphViewController.updateNodes(nodes)
    }
    
    func didUpdatePath(_ path: [String]) {
        graphViewController.highlightPath(path)
    }
    
    func didReceiveError(_ error: String) {
        showAlert(message: error)
    }
}

// MARK: - GraphUIControllerDelegate
extension PLGraphViewController: GraphViewControllerDelegate {
    func graphViewController(_ controller: GraphViewController, didRequestFindNearest type: String, from nodeId: String) {
        viewModel.findNearestNode(type: type, from: nodeId)
    }
}

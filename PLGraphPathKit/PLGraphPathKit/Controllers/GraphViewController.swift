//
//  GraphViewController.swift
//  PLGraphPathKit
//
//  Created by Turker Alan on 17.01.2025.
//

import UIKit

public protocol GraphViewControllerDelegate: AnyObject {
    func graphViewController(_ controller: GraphViewController, didRequestFindNearest type: String, from nodeId: String)
}

public class GraphViewController: UIViewController {
    
    // MARK: - Public Properties
    public weak var delegate: GraphViewControllerDelegate?
    
    // MARK: - Private Properties
    private let graphView: GraphView = {
        let view = GraphView()
        return view
    }()
    
    private let nodePickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let typeSegmentedControl: UISegmentedControl = {
        let items = ["WC", "Point"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private let findButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Find Nearest Node", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    private var nodes: [String: GraphNode] = [:]
    private var selectedNodeId: String?
    
    // MARK: - Initialization
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupDelegates()
    }
    
    // MARK: - Public Methods
    public func updateNodes(_ nodes: [String: GraphNode]) {
        self.nodes = nodes
        self.selectedNodeId = nodes.values.first?.id
        graphView.configure(with: nodes)
        nodePickerView.reloadAllComponents()
    }
    
    public func highlightPath(_ nodeIds: [String]) {
        graphView.highlightPath(nodeIds)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Graph Path Finder"
        
        [graphView, nodePickerView, typeSegmentedControl, findButton].forEach {
            view.addSubview($0)
        }
        
        findButton.addTarget(self, action: #selector(findButtonTapped), for: .touchUpInside)
        typeSegmentedControl.addTarget(self, action: #selector(typeChanged), for: .valueChanged)
    }
    
    private func setupConstraints() {
        graphView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: nil,
            right: view.rightAnchor,
            padding: .init(top: 10, left: 10, bottom: 0, right: -10),
            size: .init(width: 0, height: view.frame.width - 30)
        )
        
        nodePickerView.anchor(
            top: graphView.bottomAnchor,
            left: view.leftAnchor,
            bottom: nil,
            right: view.rightAnchor,
            padding: .init(top: 20, left: 20, bottom: 0, right: -20),
            size: .init(width: 0, height: 120)
        )
        
        typeSegmentedControl.anchor(
            top: nodePickerView.bottomAnchor,
            left: view.leftAnchor,
            bottom: nil,
            right: view.rightAnchor,
            padding: .init(top: 20, left: 20, bottom: 0, right: -20),
            size: .init(width: 0, height: 40)
        )
        
        findButton.anchor(
            top: typeSegmentedControl.bottomAnchor,
            left: view.leftAnchor,
            bottom: nil,
            right: view.rightAnchor,
            padding: .init(top: 20, left: 20, bottom: 0, right: -20),
            size: .init(width: 0, height: 50)
        )
    }
    
    private func setupDelegates() {
        nodePickerView.delegate = self
        nodePickerView.dataSource = self
        graphView.delegate = self
    }
    
    @objc private func findButtonTapped() {
        guard let nodeId = selectedNodeId else { return }
        let type = typeSegmentedControl.selectedSegmentIndex == 0 ? "wc" : "point"
        delegate?.graphViewController(self, didRequestFindNearest: type, from: nodeId)
    }
    
    @objc private func typeChanged(_ sender: UISegmentedControl) {
        // This will be handled when find button is tapped
    }
}

// MARK: - UIPickerView Delegate & DataSource
extension GraphViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nodes.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(nodes.keys)[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedNodeId = Array(nodes.keys)[row]
    }
}

// MARK: - GraphViewDelegate
extension GraphViewController: GraphViewDelegate {
    public func graphView(_ graphView: GraphView, didSelectNode nodeId: String) {
        selectedNodeId = nodeId
        if let index = Array(nodes.keys).firstIndex(of: nodeId) {
            nodePickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }
}

//
//  GraphView.swift
//  PLGraphPathKit
//
//  Created by Turker Alan on 17.01.2025.
//
import UIKit

public protocol GraphViewDelegate: AnyObject {
    func graphView(_ graphView: GraphView, didSelectNode nodeId: String)
}

public class GraphView: UIView {
    
    // MARK: - Public Properties
    public weak var delegate: GraphViewDelegate?
    
    // MARK: - Private Properties
    private var nodes: [String: GraphNode] = [:]
    private var nodeViews: [String: UIView] = [:]
    private var selectedPath: [String] = []
    private let configuration: Configuration
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        self.configuration = Configuration.default
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        self.configuration = Configuration.default
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    // MARK: - Public Methods
    public func configure(with nodes: [String: GraphNode]) {
        self.nodes = nodes
        setNeedsLayout()
    }
    
    public func highlightPath(_ nodeIds: [String]) {
        selectedPath.forEach { nodeId in
            nodeViews[nodeId]?.layer.borderWidth = 0
        }
        
        UIView.animate(withDuration: configuration.animationDuration) {
            self.selectedPath = nodeIds
            self.selectedPath.forEach { nodeId in
                self.nodeViews[nodeId]?.layer.borderWidth = 2
                self.nodeViews[nodeId]?.layer.borderColor = UIColor.systemYellow.cgColor
            }
        }
    }
    
    private func setupGraph() {
        clearGraph()
        let positions = calculateNodePositions()
        drawEdges(with: positions)
        drawNodes(with: positions)
    }
    
    private func clearGraph() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        nodeViews.values.forEach { $0.removeFromSuperview() }
        nodeViews.removeAll()
    }
    
    private func calculateNodePositions() -> [String: CGPoint] {
        var positions: [String: CGPoint] = [:]
        let nodeCount = CGFloat(nodes.count)
        let radius = min(bounds.width, bounds.height) * 0.45
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        for (index, nodeId) in nodes.keys.enumerated() {
            let angle = 2 * CGFloat.pi * CGFloat(index) / nodeCount
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            positions[nodeId] = CGPoint(x: x, y: y)
        }
        
        return positions
    }
    
    private func drawEdges(with positions: [String: CGPoint]) {
        for (nodeId, node) in nodes {
            guard let startPoint = positions[nodeId] else { continue }
            
            for edge in node.edges {
                guard let endPoint = positions[edge.id] else { continue }
                drawEdge(from: startPoint, to: endPoint, weight: edge.weight)
            }
        }
    }
    
    private func drawEdge(from startPoint: CGPoint, to endPoint: CGPoint, weight: Double) {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.systemGray.cgColor
        shapeLayer.lineWidth = calculateLineWidth(for: weight)
        shapeLayer.fillColor = nil
        layer.addSublayer(shapeLayer)
        
        addWeightLabel(weight: weight, startPoint: startPoint, endPoint: endPoint)
    }
    
    private func calculateLineWidth(for weight: Double) -> CGFloat {
        return configuration.minLineWidth +
            (configuration.maxLineWidth - configuration.minLineWidth) *
            CGFloat(weight / 25.0)
    }
    
    private func addWeightLabel(weight: Double, startPoint: CGPoint, endPoint: CGPoint) {
        let label = UILabel()
        label.text = String(format: "%.1f", weight)
        label.font = UIFont.systemFont(ofSize: 6)
        label.textColor = .systemGray
        label.sizeToFit()
        
        let midPoint = CGPoint(
            x: (startPoint.x + endPoint.x) / 2,
            y: (startPoint.y + endPoint.y) / 2
        )
        
        label.center = midPoint
        addSubview(label)
    }
    
    private func drawNodes(with positions: [String: CGPoint]) {
        for (nodeId, node) in nodes {
            guard let position = positions[nodeId] else { continue }
            
            let nodeView = createNodeView(for: node)
            nodeView.center = position
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nodeTapped(_:)))
            nodeView.addGestureRecognizer(tapGesture)
            nodeView.isUserInteractionEnabled = true
            nodeView.accessibilityIdentifier = nodeId
            
            addSubview(nodeView)
            nodeViews[nodeId] = nodeView
        }
    }
    
    private func createNodeView(for node: GraphNode) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: configuration.nodeSize, height: configuration.nodeSize))
        view.backgroundColor = nodeColor(for: node.pointType)
        view.layer.cornerRadius = configuration.nodeSize / 2
        return view
    }
    
    private func nodeColor(for type: String) -> UIColor {
        switch type {
        case "wc":
            return .systemBlue
        case "point":
            return .systemGreen
        default:
            return .systemGray
        }
    }
    
    @objc private func nodeTapped(_ gesture: UITapGestureRecognizer) {
        guard let nodeView = gesture.view,
              let nodeId = nodeView.accessibilityIdentifier else { return }
        delegate?.graphView(self, didSelectNode: nodeId)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupGraph()
    }
}

// MARK: - Public Configuration
public extension GraphView {
    struct Configuration {
        public let nodeSize: CGFloat
        public let minLineWidth: CGFloat
        public let maxLineWidth: CGFloat
        public let animationDuration: TimeInterval
        
        public static let `default` = Configuration(
            nodeSize: 8, // Changed from 40 to 6
            minLineWidth: 0.5, // Made thinner to match smaller nodes
            maxLineWidth: 2, // Made thinner to match smaller nodes
            animationDuration: 0.4
        )
        
        public init(nodeSize: CGFloat = 8,
                   minLineWidth: CGFloat = 1,
                   maxLineWidth: CGFloat = 3,
                   animationDuration: TimeInterval = 0.4) {
            self.nodeSize = nodeSize
            self.minLineWidth = minLineWidth
            self.maxLineWidth = maxLineWidth
            self.animationDuration = animationDuration
        }
    }
}

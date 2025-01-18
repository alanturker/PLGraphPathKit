# PLGraphPathKit

A lightweight iOS framework for visualizing and finding nearest nodes in weighted graphs.

## How to Build and Run the Project

### Installation

#### CocoaPods

1. Add the following to your Podfile:
```ruby
pod 'PLGraphPathKit'
```

2. Install the pod:
```bash
pod install
```

3. Open your `.xcworkspace` file to work with the framework

### Usage

1. Import the framework in your source files:
```swift
import PLGraphPathKit
```

2. Prepare your graph data in JSON format:
```json
[
  {
    "id": "node1",
    "pointType": "point",
    "edges": [
      {
        "id": "node2",
        "weight": 7.5
      }
    ]
  }
]
```

3. Basic implementation:
```swift
class YourViewController: UIViewController {
    private let viewModel = GraphViewModel()
    private let graphUIController = GraphUIController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGraphUI()
        loadGraphData()
    }
    
    private func setupGraphUI() {
        // Add graph UI controller
        addChild(graphUIController)
        view.addSubview(graphUIController.view)
        graphUIController.view.frame = view.bounds
        graphUIController.didMove(toParent: self)
    }
}
```

## Framework Architecture and Design Choices

### 1. Core Components

#### GraphPathManager
- Handles graph data processing and pathfinding
- Implements Dijkstra's algorithm for efficient nearest node search
- Thread-safe operations using value types

```swift
let manager = GraphPathManager()
try manager.getNodes(from: jsonData)
let nearest = manager.findNearestNode(withPointType: "wc", from: startNodeId)
```

#### GraphView
- Lightweight visualization component
- Optimized rendering for smooth performance
- Supports interactive node selection
- Small node size (6px) for clean visualization

#### GraphUIController
- Encapsulates all UI components
- Provides a complete user interface solution
- Handles user interactions and delegates events

### 2. Design Patterns

#### MVVM Architecture
- Clear separation of concerns
- View Models handle business logic
- Models represent graph structure
- Views handle user interaction and display

#### Delegation Pattern
- Used for communication between components
- Loose coupling for better maintainability
- Type-safe event handling

### 3. Key Design Decisions

1. **Performance First**
   - Optimized graph traversal
   - Efficient rendering
   - Minimal memory footprint

2. **Clean Architecture**
   - Separate modules for different responsibilities
   - Clear public interfaces
   - Easy to test and maintain

3. **iOS Native**
   - Built with UIKit for optimal performance
   - iOS 16.0+ support
   - Swift 5.0 implementation

### 4. Framework Structure
```
PLGraphPathKit/
├── Models/
│   ├── GraphNode.swift     # Graph data structures
│   └── GraphEdge.swift     # Edge representation
├── Managers/
│   └── GraphPathManager.swift   # Core logic
└── Views/
    └── GraphView.swift     # Visualization
```

### 5. Best Practices

1. **Memory Management**
   - Value types for thread safety
   - Proper reference cycle handling
   - Efficient resource cleanup

2. **Error Handling**
   - Clear error propagation
   - Proper JSON validation
   - Graceful failure handling

3. **Code Organization**
   - Modular components
   - Clear responsibilities
   - Well-documented interfaces

### 6. Usage Tips

1. **Graph Data**
   - Keep node IDs unique
   - Use meaningful point types
   - Validate JSON structure

2. **UI Integration**
   - Use provided GraphUIController for full functionality
   - Customize appearance as needed
   - Handle orientation changes

3. **Performance**
   - Load data asynchronously
   - Cache results when appropriate
   - Monitor memory usage

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.0+

## License

PLGraphPathKit is available under the MIT license.
Pod::Spec.new do |spec|

  spec.name         = "PLGraphPathKit"
  spec.version      = "1.0.0"
  spec.summary      = "A lightweight iOS framework for visualizing and finding nearest nodes in weighted graphs."
  spec.description  = "PLGraphPathKit is an efficient iOS framework for graph visualization and pathfinding. It provides a complete solution for parsing graph data, visualizing nodes and edges, and finding nearest nodes of specific types using Dijkstra's algorithm. The framework includes ready-to-use UI components and supports weighted edges and different node types."

  spec.homepage     = "https://github.com/alanturker/PLGraphPathKit"
  spec.license      = "MIT"
  spec.author       = { "alanturker" => "alanturker@gmail.com" }
  spec.platform     = :ios, "16.0"
  spec.source       = { :git => "https://github.com/alanturker/PLGraphPathKit.git", :tag => spec.version.to_s }
  spec.source_files  = "PLGraphPathKit/**/*.{swift}"
  spec.swift_versions = "5.0"
end

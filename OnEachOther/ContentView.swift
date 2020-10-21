//
//  ContentView.swift
//  OnEachOther
//
//  Created by Demetrius Sidyakin on 10/21/20.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        
        // Load the "Box" scene from the "Experience" Reality File
//        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
//        arView.scene.anchors.append(boxAnchor)
        
        arView.enableTapGesture()
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

extension ARView {
// 4. Exrend ARView to implement tapGesture handler
    
// 4a. Create enableTapGesture function to add tapGestureRecognizer to ARView
    
// 4b. Create handleTap function to implement raycasting logic
// 4b-i. If raycast intersects an AR object, place a new object on top of it at the 3D point of intersection
// 4b-ii. else, place an object on a real-world plane (if present)
    func enableTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: self)
        
        guard let rayResult = self.ray(through: tapLocation) else { return }
        
        let results = self.scene.raycast(origin: rayResult.origin, direction: rayResult.direction)
        
        if let firstResult = results.first {
            // Raycast intersected with AR object
            // Place object on top of existing AR object
        } else  {
            // Raycast has not intersected with AR object
            // Place a new object on a real-world surface (if present)
            
            let results = self.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)
            
            if let firstResult = results.first {
                let position = simd_make_float3(firstResult.worldTransform.columns.3) // SIMD3<Float>
                placeCube(at: position)
            }
        }
    }
    
// 5. Create helper method to place cube at 3D position
// NOTE: make sure to generateCollisionShapes for modelEntity
    func placeCube(at position: SIMD3<Float>) {
        let mash = MeshResource.generateBox(size: 0.3)
        let material = SimpleMaterial(color: .white, roughness: 0.3, isMetallic: true)
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

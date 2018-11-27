//
//  MetalRenderer.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 18/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Metal
import MetalKit
import simd

// MARK: Metal renderer
internal class MetalRenderer: NSObject {
    // MARK: Properties
    internal var metalKitView: MTKView?
    
    // MARK: Initialization
    internal init?(metalKitView: MTKView, targetGameScreenSize: Size) {
        }
    }
    

// MARK: Pixlr Renderer conformance
extension MetalRenderer: Renderer {    
    func viewportWillChange(to size: Size) {
        
    }
    
    func performDrawCommands(commands: [Graphics.DrawCommand]) {
        
    }
}

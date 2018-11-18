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
    // MARK: Initialization
    init?(metalKitView: MTKView) {
        
    }
}

// MARK: - MTKViewDelegate functions
extension MetalRenderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        Log.graphics.info("Drawable size changed: \(size)")
    }
    
    func draw(in view: MTKView) {
        Log.graphics.info("Metal drawing here!")
    }
}


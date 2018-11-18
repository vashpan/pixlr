//
//  MetalViewController.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 13/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Cocoa
import MetalKit

// MARK: MetalViewController
internal class MetalViewController: NSViewController {
    // MARK: Properties
    private var metalView: MTKView!
    
    // MARK: Initialization & overrides
    internal init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func loadView() {
        guard let mainWindow = NSApp.mainWindow else {
            return
        }
        
        guard let defaultMetalDevice = MTLCreateSystemDefaultDevice() else {
            Log.graphics.error("Metal is not supported!")
            return
        }
        
        let frame = NSRect(origin: .zero, size: mainWindow.frame.size)
        self.metalView = MTKView(frame: frame, device: defaultMetalDevice)
        
        self.view = self.metalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.metalView.delegate = self
    }
}

// MARK: - MTKViewDelegate implementation
extension MetalViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {

    }
}

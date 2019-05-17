//
//  MacMetalViewController.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 13/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import MetalKit

internal class MacMetalViewController: NSViewController {
    // MARK: Properties
    private var metalView: MTKView!
    private var trackingArea: NSTrackingArea? // for mouse move tracking
    
    private let currentGame: Game
    private var graphics: Graphics!
    private var renderer: MetalRenderer!
    
    private let targetGameScreenSize: Size
    private let screenScaleMode: Config.ScreenScaleMode
    
    // MARK: Initialization & overrides
    internal init(game: Game, targetGameScreenSize: Size, scaleMode: Config.ScreenScaleMode) {
        self.currentGame = game
        self.targetGameScreenSize = targetGameScreenSize
        self.screenScaleMode = scaleMode
        
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
        self.metalView.delegate = self
        self.view = self.metalView
        
        guard let newRenderer = MetalRenderer(metalKitView: self.metalView, targetGameScreenSize: self.targetGameScreenSize) else {
            Log.graphics.error("Cannot create Metal renderer!")
            return
        }
        
        guard let platform = Pixlr.currentPlatform as? MacOSPlatform else {
            return
        }
        
        platform.renderer = newRenderer
        
        self.renderer = newRenderer
        self.graphics = Graphics(renderer: self.renderer)
        
        self.mtkView(self.metalView, drawableSizeWillChange: self.metalView.drawableSize)
        self.updateMouseTrackingArea(for: self.metalView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start game
        self.currentGame.start()
    }
    
    // MARK: Helpers
    private func updateMouseTrackingArea(for view: NSView) {
        if let oldTrackingArea = self.trackingArea {
            view.removeTrackingArea(oldTrackingArea)
        }
        
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .mouseMoved, .activeInKeyWindow]
        let newTrackingArea = NSTrackingArea(rect: self.view.bounds, options: options, owner: self, userInfo: nil)
        
        view.addTrackingArea(newTrackingArea)
        
        self.trackingArea = newTrackingArea
    }
    
    private func nsEventToMouseState(_ event: NSEvent) -> Mouse {
        let realSize = Size(cgSize: self.metalView.bounds.size)
        let gameSize = self.currentGame.screenSize
        let widthFactor = gameSize.width / realSize.width
        let heightFactor = gameSize.height / realSize.height
        
        // scale & transform touch locations to target game resolution
        var uiPosition = event.locationInWindow
        uiPosition.x *= CGFloat(widthFactor)
        uiPosition.y *= CGFloat(heightFactor)

        let position = Point(cgPoint: uiPosition)
        
        let buttonsState: [Mouse.Button: Mouse.ClickState] = [
            Mouse.Button.left: NSEvent.pressedMouseButtons == 1 << 0 ? .down : .up,
            Mouse.Button.right: NSEvent.pressedMouseButtons == 1 << 1 ? .down : .up,
        ]
        
        return Mouse(position: position, state: buttonsState)
    }
    
    // MARK: Handling touch input
    override func mouseMoved(with event: NSEvent) {
        self.currentGame.onMouseMove(mouse: self.nsEventToMouseState(event))
        
        super.mouseMoved(with: event)
    }
    
    override func mouseDown(with event: NSEvent) {
        self.currentGame.onMouseClick(mouse: self.nsEventToMouseState(event))
        
        super.mouseDown(with: event)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.currentGame.onMouseClick(mouse: self.nsEventToMouseState(event))
        
        super.mouseUp(with: event)
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.currentGame.onMouseMove(mouse: self.nsEventToMouseState(event))
        
        super.mouseDragged(with: event)
    }
    
    override func rightMouseDown(with event: NSEvent) {
        self.currentGame.onMouseClick(mouse: self.nsEventToMouseState(event))
        
        super.rightMouseDown(with: event)
    }
    
    override func rightMouseUp(with event: NSEvent) {
        self.currentGame.onMouseClick(mouse: self.nsEventToMouseState(event))
        
        super.rightMouseUp(with: event)
    }
    
    override func rightMouseDragged(with event: NSEvent) {
        self.currentGame.onMouseMove(mouse: self.nsEventToMouseState(event))
        
        super.rightMouseDragged(with: event)
    }
}

// MARK: - MTKViewDelegate functions
extension MacMetalViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        let realSize = Size(cgSize: size)
        var gameSize = self.targetGameScreenSize
        switch self.screenScaleMode {
            case .keepHeight:
                let heightFactor = gameSize.height / realSize.height
                gameSize.width = realSize.width * heightFactor
            case .keepWidth:
                let widthFactor = gameSize.width / realSize.width
                gameSize.height = realSize.height * widthFactor
            
            case .keepWidthAndHeight:
                break // do nothing in this case as game viewport will be constant
        }
        
        self.currentGame.screenSize = gameSize
        
        self.renderer.viewportWillChange(realSize: realSize, gameSize: gameSize)
        
        self.updateMouseTrackingArea(for: view)
    }
    
    func draw(in view: MTKView) {
        self.currentGame.update(dt: 1.0 / 60.0)
        
        self.graphics.beginFrame()
        self.currentGame.draw(on: self.graphics)
        self.graphics.endFrame()
    }
}

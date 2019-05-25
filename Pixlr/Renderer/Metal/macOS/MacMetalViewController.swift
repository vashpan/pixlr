//
//  MacMetalViewController.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 13/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import MetalKit

private protocol PixlrMTKViewInputDelegate: class {
    func pixlrMouseMoved(with event: NSEvent)
    func pixlrMouseDown(with event: NSEvent)
    func pixlrMouseUp(with event: NSEvent)
    func pixlrMouseDragged(with event: NSEvent)
    func pixlrRightMouseDown(with event: NSEvent)
    func pixlrRightMouseUp(with event: NSEvent)
    func pixlrRightMouseDragged(with event: NSEvent)
    
    func pixlrKeyDown(with event: NSEvent)
    func pixlrKeyUp(with event: NSEvent)
}

// MARK: Private Metal View with Input handling
private class PixlrMTKView: MTKView {
    // MARK: Properties
    weak var inputDelegate: PixlrMTKViewInputDelegate?
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    // MARK: Initialization
    init(frame: NSRect, device: MTLDevice) {
        super.init(frame: frame, device: device)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Mouse input
    override func mouseMoved(with event: NSEvent) {
        self.inputDelegate?.pixlrMouseMoved(with: event)
        
        super.mouseMoved(with: event)
    }
    
    override func mouseDown(with event: NSEvent) {
        self.inputDelegate?.pixlrMouseDown(with: event)
        
        super.mouseDown(with: event)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.inputDelegate?.pixlrMouseUp(with: event)
        
        super.mouseUp(with: event)
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.inputDelegate?.pixlrMouseDragged(with: event)
        
        super.mouseDragged(with: event)
    }
    
    override func rightMouseDown(with event: NSEvent) {
        self.inputDelegate?.pixlrRightMouseDown(with: event)
        
        super.rightMouseDown(with: event)
    }
    
    override func rightMouseUp(with event: NSEvent) {
        self.inputDelegate?.pixlrRightMouseUp(with: event)
        
        super.rightMouseUp(with: event)
    }
    
    override func rightMouseDragged(with event: NSEvent) {
        self.inputDelegate?.pixlrRightMouseDragged(with: event)
        
        super.rightMouseDragged(with: event)
    }
    
    // MARK: Keyboard input
    override func keyDown(with event: NSEvent) {
        self.inputDelegate?.pixlrKeyDown(with: event)
        
        super.keyDown(with: event)
    }
    
    override func keyUp(with event: NSEvent) {
        self.inputDelegate?.pixlrKeyUp(with: event)
        
        super.keyUp(with: event)
    }
}

internal class MacMetalViewController: NSViewController {
    // MARK: Properties
    private var metalView: PixlrMTKView!
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
        self.metalView = PixlrMTKView(frame: frame, device: defaultMetalDevice)
        self.metalView.delegate = self
        self.metalView.inputDelegate = self
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.metalView.becomeFirstResponder()
        
        // start game
        self.currentGame.start()
    }
    
    // MARK: Helpers
    private func nsEventToMouseState(_ event: NSEvent) -> Mouse? {
        let realSize = Size(cgSize: self.metalView.bounds.size)
        let gameSize = self.currentGame.screenSize
        let widthFactor = gameSize.width / realSize.width
        let heightFactor = gameSize.height / realSize.height
        
        var uiPosition = event.locationInWindow
        
        // limit mouse tracking to our viewport
        if uiPosition.x < 0.0 || uiPosition.x > self.metalView.bounds.width {
            return nil
        }
        if uiPosition.y < 0.0 || uiPosition.y > self.metalView.bounds.height {
            return nil
        }
        
        // scale & transform touch locations to target game resolution
        uiPosition.x *= CGFloat(widthFactor)
        uiPosition.y *= CGFloat(heightFactor)
        
        let position = Point(cgPoint: uiPosition)
        
        let buttonsState: [Mouse.Button: Mouse.ClickState] = [
            Mouse.Button.left: NSEvent.pressedMouseButtons == 1 << 0 ? .down : .up,
            Mouse.Button.right: NSEvent.pressedMouseButtons == 1 << 1 ? .down : .up,
        ]
        
        return Mouse(position: position, state: buttonsState)
    }
    
    private func nsEventToKeyState(_ event: NSEvent, state: Key.State) -> Key {
        // handle modifiers
        var modifiers = [Key.Code]()

        if event.modifierFlags.contains(.command) {
            modifiers.append(.command)
        }
        if event.modifierFlags.contains(.control) {
            modifiers.append(.control)
        }
        if event.modifierFlags.contains(.shift) {
            modifiers.append(.shift)
        }
        if event.modifierFlags.contains(.option) {
            modifiers.append(.alt)
        }
        if event.modifierFlags.contains(.capsLock) {
            modifiers.append(.capsLock)
        }
        if event.modifierFlags.contains(.function) {
            modifiers.append(.fn)
        }

        // handle main key scan code
        let code = MacKeyMapping.macKeyCodeToPixlrKeyCode(macKeyCode: event.keyCode)
        
        return Key(code: code, character: event.characters?.first, modifiers: modifiers, state: state)
    }
}

// MARK: - PixlrMTKViewInputDelegate functions
extension MacMetalViewController: PixlrMTKViewInputDelegate {
    // MARK: Handling mouse input
    func pixlrMouseMoved(with event: NSEvent) {
        if let mouseState = self.nsEventToMouseState(event) {
            self.currentGame.onMouseMove(mouse: mouseState)
        }
    }
    
    func pixlrMouseDown(with event: NSEvent) {
        if let mouseState = self.nsEventToMouseState(event) {
            self.currentGame.onMouseClick(mouse: mouseState)
        }
    }
    
    func pixlrMouseUp(with event: NSEvent) {
        if let mouseState = self.nsEventToMouseState(event) {
            self.currentGame.onMouseClick(mouse: mouseState)
        }
    }
    
    func pixlrMouseDragged(with event: NSEvent) {
        if let mouseState = self.nsEventToMouseState(event) {
            self.currentGame.onMouseMove(mouse: mouseState)
        }
    }
    
    func pixlrRightMouseDown(with event: NSEvent) {
        if let mouseState = self.nsEventToMouseState(event) {
            self.currentGame.onMouseClick(mouse: mouseState)
        }
    }
    
    func pixlrRightMouseUp(with event: NSEvent) {
        if let mouseState = self.nsEventToMouseState(event) {
            self.currentGame.onMouseClick(mouse: mouseState)
        }
    }
    
    func pixlrRightMouseDragged(with event: NSEvent) {
        if let mouseState = self.nsEventToMouseState(event) {
            self.currentGame.onMouseMove(mouse: mouseState)
        }
    }
    
    // MARK: Handling keyboard input
    func pixlrKeyDown(with event: NSEvent) {
        let key = nsEventToKeyState(event, state: .down)
        self.currentGame.onKey(key: key)
    }
    
    func pixlrKeyUp(with event: NSEvent) {
        let key = nsEventToKeyState(event, state: .up)
        self.currentGame.onKey(key: key)
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
    }
    
    func draw(in view: MTKView) {
        self.currentGame.update(dt: 1.0 / 60.0)
        
        self.graphics.beginFrame()
        self.currentGame.draw(on: self.graphics)
        self.graphics.endFrame()
    }
}

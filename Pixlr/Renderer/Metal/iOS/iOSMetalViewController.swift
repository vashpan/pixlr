//
//  iOSMetalViewController.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 4/5/2019.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import UIKit
import MetalKit

internal class iOSMetalViewController: UIViewController {
    // MARK: Properties
    private var metalView: MTKView!
    
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
        guard let mainWindow = UIApplication.shared.windows.first else {
            fatalError("No UIWindow found!")
        }
        
        guard let defaultMetalDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported!")
        }
        
        let frame = CGRect(origin: .zero, size: mainWindow.frame.size)
        self.metalView = MTKView(frame: frame, device: defaultMetalDevice)
        self.metalView.delegate = self
        self.view = self.metalView
        
        guard let newRenderer = MetalRenderer(metalKitView: self.metalView, targetGameScreenSize: self.targetGameScreenSize) else {
            Log.graphics.error("Cannot create Metal renderer!")
            return
        }
        
        guard let platform = Pixlr.currentPlatform as? iOSPlatform else {
            return
        }
        
        platform.renderer = newRenderer
        
        self.renderer = newRenderer
        self.graphics = Graphics(renderer: self.renderer)
        
        self.mtkView(self.metalView, drawableSizeWillChange: self.metalView.drawableSize)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start game
        self.currentGame.start()
    }
    
    // MARK: Helpers
    private func uiTouchesToPixlrTouches(touches: Set<UITouch>, state: Touch.State) -> [Touch] {
        let realSize = Size(cgSize: self.metalView.bounds.size)
        let gameSize = self.currentGame.screenSize
        let widthFactor = gameSize.width / realSize.width
        let heightFactor = gameSize.height / realSize.height
        
        return touches.map { (uiTouch) in
            // scale & transform touch locations to target game resolution
            var uiPosition = uiTouch.location(in: self.view)
            uiPosition.x *= CGFloat(widthFactor)
            uiPosition.y *= CGFloat(heightFactor)
            uiPosition.y = gameSize.cgSize.height - uiPosition.y
            
            let position = Point(cgPoint: uiPosition)
            
            return Touch(position: position, state: state)
        }
    }
    
    // MARK: Handling touch input
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentGame.onTouch(touches: self.uiTouchesToPixlrTouches(touches: touches, state: .began))
        
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentGame.onTouch(touches: self.uiTouchesToPixlrTouches(touches: touches, state: .moved))
        
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentGame.onTouch(touches: self.uiTouchesToPixlrTouches(touches: touches, state: .ended))
        
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentGame.onTouch(touches: self.uiTouchesToPixlrTouches(touches: touches, state: .ended))
        
        super.touchesCancelled(touches, with: event)
    }
}

// MARK: - MTKViewDelegate functions
extension iOSMetalViewController: MTKViewDelegate {
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

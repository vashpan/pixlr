//
//  MacOSPlatform.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 12/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation
import CoreGraphics
import AppKit

// MARK: - macOS platform
internal class MacOSPlatform: Platform {
    // MARK: Properties
    internal var renderer: Renderer? = nil
    
    internal var appName: String {
        var result: String? = nil
        
        // first bundle display name
        result = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        
        // bundle name
        if result == nil {
            result = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        }
        
        // process name
        if result == nil {
            result = ProcessInfo.processInfo.processName
        }
        
        return result ?? ""
    }
    
    // MARK: App lifecycle
    internal func startApp(with game: Game) {
        let app = PixlrApplication.shared as! PixlrApplication
        let delegate = PixlrAppDelegate()
        
        app.createMainMenu()
        app.createMainWindow(title: self.appName)
        
        app.delegate = delegate
        app.run()
    }
    
    // MARK: Loading resources
    private func imageData(from image: NSImage, textureFormat: Texture.Format = .rgba8) -> Data? {
        let imageWidth = Int(image.size.width)
        let imageHeight = Int(image.size.height)
        
        // create bitmap context
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = textureFormat.bytesPerPixel
        let bytesPerRow = bytesPerPixel * imageWidth
        let bytesInImage = imageHeight * imageWidth * bytesPerPixel
        let rawData = calloc(bytesInImage, MemoryLayout<UInt8>.size)!
        
        guard let context = CGContext(data: rawData,
                                      width: imageWidth,
                                      height: imageHeight,
                                      bitsPerComponent: textureFormat.bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue) else {
            return nil
        }
        
        // get image
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        
        // draw image on context
        context.translateBy(x: 0.0, y: CGFloat(imageHeight)) // move context to the top
        context.scaleBy(x: 0.0, y: -1.0) // rotate
        
        let imageRect = CGRect(x: 0, y: 0, width: CGFloat(imageWidth), height: CGFloat(imageHeight))
        context.draw(cgImage, in: imageRect)
        
        return Data(bytes: rawData, count: bytesInImage)
    }
    
    func loadTexture(name: String) -> Texture? {
        let defaultTextureFormat = Texture.Format.rgba8
        
        guard let pathToTexture = Bundle.main.path(forResource: name, ofType: "png") else    {
            Log.resources.warning("Cannot load texture. File not found: \(name)")
            return nil
        }
        
        guard let image = NSImage(contentsOfFile: pathToTexture) else {
            Log.resources.warning("Cannot load texture. Couldn't load image: \(pathToTexture)")
            return nil
        }
        
        guard let imageData = self.imageData(from: image, textureFormat: defaultTextureFormat) else {
            Log.resources.warning("Cannot load texture. Cannot get image data: \(pathToTexture)")
            return nil
        }
        
        let texture = Texture(data: imageData, size: Size(cgWidth: image.size.width, cgHeight: image.size.height), format: defaultTextureFormat)
        
        // load texture into renderer
        if let metalRenderer = self.renderer as? MetalRenderer {
            if let metalTexture = metalRenderer.loadNativeTexture(from: texture, label: name) {
                texture.nativeTexture = metalTexture
            }
        }
        
        return texture
    }
}

// MARK: - Pixlr extension for macOS platform
internal extension Pixlr {
    internal static var currentPlatform: Platform = MacOSPlatform()
}

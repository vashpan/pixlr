//
//  Platform.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 12/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

internal protocol Platform {
    // MARK: Properties
    var appName: String {get}
    
    // MARK: App lifecycle
    func startApp(with game: Game)
    
    // MARK: Loading resources
    func loadTexture(name: String) -> Texture?
}

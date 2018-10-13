//
//  Platform.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 12/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

internal protocol Platform {
    // MARK: App lifecycle
    func startApp(with game: Game)
    
    // MARK: Informations & configuration
    var appName: String {get}
}

//
//  Pixlr.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 11/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

// MARK: Containers for various logs
public class Log {
    // MARK: Properties
    private static var logLevel: Logger.Level {
        #if DEBUG
        return .info
        #else
        return .error
        #endif
    }
    
    // MARK: Loggers
    public static let global = Logger(level: Log.logLevel)
    
    public static let platform = Logger(subsystem: "*️⃣", level: Log.logLevel)
    
    public static let graphics = Logger(subsystem: "🎨", level: Log.logLevel)
    
    public static let sound = Logger(subsystem: "🔊", level: Log.logLevel)
}

// MARK: - Main Pixlr framework class
public class Pixlr {
    public static func run(game: Game) {
        Pixlr.currentPlatform.startApp(with: game)
    }
}

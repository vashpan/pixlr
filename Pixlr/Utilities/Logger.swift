//
//  Logger.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 18/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

public class Logger {
    // MARK: Types
    public enum Level {
        case info, warning, error
    }
    
    // MARK: Properties
    public let level: Level
    public let subsystem: String?
    
    // MARK: Initialization
    public init(subsystem: String? = nil, level: Level = .error) {
        self.subsystem = subsystem
        self.level = level
    }
    
    // MARK: Helpers
    private func writeLog(text: String) {
        if let subsystemString = self.subsystem {
            NSLog("[%@]: %@", subsystemString, text)
        } else {
            NSLog(text)
        }
    }
    
    // MARK: Log methods
    public func info(_ message: String) {
        switch self.level {
            case .info:
                self.writeLog(text: "❕ \(message)")
            default:
                return
        }
    }
    
    public func warning(_ message: String) {
        switch self.level {
            case .info, .warning:
                self.writeLog(text: "⚠️ \(message)")
            default:
                return
        }
    }
    
    public func error(_ message: String) {
        switch self.level {
            case .info, .warning, .error:
                self.writeLog(text: "❌ \(message)")
        }
    }
}

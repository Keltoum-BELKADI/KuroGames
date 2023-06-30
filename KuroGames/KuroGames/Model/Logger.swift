//
//  Logger.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 30/06/2023.
//

import Foundation
import UIKit

enum LogLevel: String {
    case info = "ℹ️"
    case debug = "🐛"
    case warning = "⚠️"
    case error = "❌"
}

class Logger {
    static func log(_ level: LogLevel, _ message: String) {
        let logText = "\(level.rawValue) [\(Date())] - \(message)"
        print(logText)
        let alert = UIAlertController(title: "Oupss", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
}

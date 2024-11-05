//
//  ConsoleLogger.swift
//  LoggingSDK
//
//  Created by Yigit Dayı on 5.11.2024.
//

import Foundation

public class ConsoleLogger: Logger {
    private let logger: UnifiedLogger

    public init(subsystem: String = Bundle.main.bundleIdentifier ?? "com.yourcompany.app", category: String = "Console") {
        self.logger = UnifiedLogger(subsystem: subsystem, category: category)
    }

    public func log(
        _ level: LogLevel,
        message: String,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        logger.log(level, message: message, metadata: metadata, file: file, function: function, line: line)
    }
}


//
//  LoggerManager.swift
//  LoggingSDK
//
//  Created by Yigit Dayı on 5.11.2024.
//
import Foundation

public class LoggerManager: Logger, @unchecked Sendable {
    public static let shared = LoggerManager()

    private let logger: Logger

    private init() {
        
        let consoleLogger = ConsoleLogger()
        let fileLogger = FileLogger()
        let analyticsLogger = AnalyticsLogger()

        let minLogLevel: LogLevel = .debug
        
        let filteredConsoleLogger = LogLevelFilterLogger(logger: consoleLogger, minLevel: minLogLevel)
        let filteredFileLogger = LogLevelFilterLogger(logger: fileLogger, minLevel: minLogLevel)

        
        self.logger = CompositeLogger(loggers: [filteredConsoleLogger, filteredFileLogger, analyticsLogger])
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


//
//  LogLevelFilterLogger.swift
//  LoggingSDK
//
//  Created by Yigit Dayı on 5.11.2024.
//

public class LogLevelFilterLogger: Logger {
    private let logger: Logger
    private let minLevel: LogLevel

    public init(logger: Logger, minLevel: LogLevel) {
        self.logger = logger
        self.minLevel = minLevel
    }

    public func log(
        _ level: LogLevel,
        message: String,
        metadata: [String: Any]? = nil,
        file: String,
        function: String,
        line: Int
    ) {
        if level >= minLevel {
            logger.log(level, message: message, metadata: metadata, file: file, function: function, line: line)
        }
    }
}


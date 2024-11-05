//
//  CompositeLogger.swift
//  LoggingSDK
//
//  Created by Yigit Dayı on 5.11.2024.
//

public class CompositeLogger: Logger {
    private let loggers: [Logger]

    public init(loggers: [Logger]) {
        self.loggers = loggers
    }

    public func log(
        _ level: LogLevel,
        message: String,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        for logger in loggers {
            logger.log(level, message: message, metadata: metadata, file: file, function: function, line: line)
        }
    }
}


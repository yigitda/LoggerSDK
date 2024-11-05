//
//  UnifiedLogger.swift
//  LoggingSDK
//
//  Created by Yigit Dayı on 5.11.2024.
//

import Foundation
import OSLog

public class UnifiedLogger: Logger {
    private let subsystem: String
    private let category: String

    @available(iOS 14.0, macOS 11.0, *)
    private var logger: os.Logger

    private let osLog: OSLog

    public init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
        self.osLog = OSLog(subsystem: subsystem, category: category)

        if #available(iOS 14.0, macOS 11.0, *) {
            self.logger = os.Logger(subsystem: subsystem, category: category)
        }
    }

    public func log(
        _ level: LogLevel,
        message: String,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let formattedMessage = formatMessage(
            level: level,
            message: message,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )

        if #available(iOS 14.0, macOS 11.0, *) {
            switch level {
            case .trace:
                logger.trace("\(formattedMessage, privacy: .public)")
            case .debug:
                logger.debug("\(formattedMessage, privacy: .public)")
            case .info:
                logger.info("\(formattedMessage, privacy: .public)")
            case .warning:
                logger.warning("\(formattedMessage, privacy: .public)")
            case .error:
                logger.error("\(formattedMessage, privacy: .public)")
            }
        } else {
            let logType: OSLogType
            switch level {
            case .trace, .debug:
                logType = .debug
            case .info:
                logType = .info
            case .warning:
                logType = .default
            case .error:
                logType = .error
            }

            os_log("%{public}@", log: osLog, type: logType, formattedMessage)
        }
    }

    private func formatMessage(
        level: LogLevel,
        message: String,
        metadata: [String: Any]?,
        file: String,
        function: String,
        line: Int
    ) -> String {
        let fileName = (file as NSString).lastPathComponent
        var formattedMessage = "[\(level.description)] \(message) [\(fileName):\(line) \(function)]"

        if let metadata = metadata, !metadata.isEmpty {
            let metadataString = metadata.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
            formattedMessage += " | \(metadataString)"
        }

        return formattedMessage
    }
}


//
//  NetworkLogger.swift
//  LoggingSDK
//
//  Created by Yigit Dayı on 5.11.2024.
//

import Foundation
import Alamofire

public final class NetworkLogger: EventMonitor, Logger, @unchecked Sendable {
    private let logger: UnifiedLogger
    public let queue = DispatchQueue(label: "com.yourcompany.NetworkLogger", attributes: .concurrent)

    public init(subsystem: String = Bundle.main.bundleIdentifier ?? "com.yourcompany.app", category: String = "Network") {
        self.logger = UnifiedLogger(subsystem: subsystem, category: category)
    }

    public func requestDidResume(_ request: Request) {
        request.startTime = Date()
        logger.log(
            .info,
            message: "Request started: \(request.request?.url?.absoluteString ?? "Unknown URL")",
            metadata: nil
        )
    }

    public func requestDidFinish(_ request: Request) {
        guard let startTime = request.startTime else { return }
        let duration = Date().timeIntervalSince(startTime)
        let urlString = request.request?.url?.absoluteString ?? "Unknown URL"
        let statusCode = request.response?.statusCode ?? -1

        ServiceTimer.logServiceDuration(duration: duration, urlString: urlString, statusCode: statusCode)
        ServiceTimer.printTotalTimes()

        logger.log(
            .info,
            message: "Request finished: \(urlString)",
            metadata: [
                "Duration": duration,
                "StatusCode": statusCode
            ]
        )
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



//
//  ServiceTimer.swift
//  LoggingSDK
//
//  Created by Yigit Dayı on 5.11.2024.
//

import Foundation
import os

actor ServiceTimer {
    static let shared = ServiceTimer()

    private var serviceDurations: [String: TimeInterval] = [:]
    private let logger = UnifiedLogger(subsystem: "com.yourcompany.app", category: "ServiceTimer")

    func logServiceDuration(duration: TimeInterval, urlString: String, statusCode: Int) {
        serviceDurations[urlString] = (serviceDurations[urlString] ?? 0) + duration

        logger.log(
            .info,
            message: "Request to \(urlString) completed",
            metadata: [
                "Duration": duration,
                "StatusCode": statusCode
            ]
        )
    }

    func printTotalTimes() {
        for (url, totalDuration) in serviceDurations {
            logger.log(
                .info,
                message: "Total time for \(url): \(totalDuration) seconds",
                metadata: nil
            )
        }
    }
}



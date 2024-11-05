//
//  Logger.swift
//  LoggingSDK
//
//  Created by Yigit Dayı on 5.11.2024.
//

public protocol Logger {
    func log(
        _ level: LogLevel,
        message: String,
        metadata: [String: Any]?,
        file: String,
        function: String,
        line: Int
    )
}


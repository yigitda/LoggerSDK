//
//  FileLogger.swift
//  LoggingSDK
//
//  Created by Yigit Dayı on 5.11.2024.
//

import Foundation

public class FileLogger: Logger, @unchecked Sendable {
    private let fileName: String
    private let maxFileSize: UInt64
    private let fileQueue = DispatchQueue(label: "com.yourcompany.FileLogger", attributes: .concurrent)
    private let logFileHandle: FileHandle?

    public init(
        fileName: String = "app_log.txt",
        maxFileSize: UInt64 = 5 * 1024 * 1024
    ) {
        self.fileName = fileName
        self.maxFileSize = maxFileSize

        let fileManager = FileManager.default
        let filePath = Self.getLogFilePath(fileName: fileName)

        if !fileManager.fileExists(atPath: filePath.path) {
            fileManager.createFile(atPath: filePath.path, contents: nil, attributes: nil)
        }

        self.logFileHandle = try? FileHandle(forWritingTo: filePath)
        self.logFileHandle?.seekToEndOfFile()
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

        fileQueue.async(flags: .barrier) {
            self.rotateLogFileIfNeeded()
            guard let data = (formattedMessage + "\n").data(using: .utf8) else { return }

            self.logFileHandle?.write(data)
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
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let fileName = (file as NSString).lastPathComponent
        var formattedMessage = "\(timestamp) [\(level.description)] \(message) [\(fileName):\(line) \(function)]"

        if let metadata = metadata, !metadata.isEmpty {
            let metadataString = metadata.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
            formattedMessage += " | \(metadataString)"
        }

        return formattedMessage
    }

    private func rotateLogFileIfNeeded() {
        guard let fileHandle = self.logFileHandle else { return }

        let fileSize = fileHandle.offsetInFile
        if fileSize >= maxFileSize {
            fileHandle.closeFile()
            let fileManager = FileManager.default
            let filePath = Self.getLogFilePath(fileName: fileName)
            let backupFilePath = Self.getLogFilePath(fileName: "\(fileName).\(Date().timeIntervalSince1970)")

            try? fileManager.moveItem(at: filePath, to: backupFilePath)
            fileManager.createFile(atPath: filePath.path, contents: nil, attributes: nil)
            self.logFileHandle?.seekToEndOfFile()
        }
    }

    private static func getLogFilePath(fileName: String) -> URL {
        let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(fileName)
    }

    deinit {
        self.logFileHandle?.closeFile()
    }
}

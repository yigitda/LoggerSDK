//
//  Re.swift
//  LoggingSDK
//
//  Created by Yigit Dayı on 5.11.2024.
//

import Foundation
import ObjectiveC
import Alamofire

extension Request {
    private struct AssociatedKeys {
        var startTime = "startTime"
    }

    var startTime: Date? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.startTime) as? Date
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.startTime, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

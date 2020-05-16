//
//  DateManager.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/12/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import Foundation

extension Date {
    func convertToDateWithSeconds(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    func timeAgoAlgorithm(format: String) -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let week = 7 * 24 * 60 * 60
        let month = 4 * week
        if secondsAgo < month && (secondsAgo/week) > 1 {
            return self.convertToDateWithSeconds(format: format)
        } else {
            return self.timeAgoDisplay()
        }
    }

    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
    }
}

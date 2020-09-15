//
//  Date+Extension.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import Foundation
import UIKit

extension Date {

    private var calendar : Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar
    }
    
    var startofDay: Date?{
        let date = calendar.startOfDay(for: self)
        return date
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: calendar.startOfDay(for: self))!
    }
    
    var month:Int?{
        return self.calendar.dateComponents([.month], from: self).month
    }
    
    var year:Int?{
        return self.calendar.dateComponents([.year], from: self).year
    }
    
    var dayInMonth:Int?{
        return self.calendar.dateComponents([.day], from: self).day
    }
    
    var startofMonth: Date?{
        return calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }

    var startofWeek: Date? {
        guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        if self.isWithinWeekOf(date: sunday)
        {
            return calendar.date(byAdding: .day, value: 1, to: sunday)
        }
        else{
            return calendar.date(byAdding: .day, value: -6, to: sunday)
        }
    }

    func isEqual(toDateIgnoringTime date: Date?) -> Bool {
        let components1 = calendar.dateComponents([.year, .month, .day], from: self)
        var components2: DateComponents? = nil
        if let date = date {
            components2 = calendar.dateComponents([.year, .month, .day], from: date)
        }
        if (components1.year == components2?.year) && (components1.month == components2?.month) && (components1.day == components2?.day) {
            return true
        } else {
            return false
        }
    }

    func isWithinWeekOf( date: Date?) -> Bool {
        let previousSunday = date?.previousSundayForWeek()
        let followingSunday = date?.followingSundayForWeek()
        if let previousSunday = previousSunday {
            if (timeIntervalSince(previousSunday) > 0.0) && (followingSunday!.timeIntervalSince(self) > 0.0) {
                return true
            }
        }
        return false
    }

    func followingSundayForWeek() -> Date? {
        var comp = DateComponents()
        comp.weekOfYear = 1
        let date = calendar.date(byAdding: comp, to: self)
        var weekdayComponents: DateComponents? = nil
        if let date = date {
            weekdayComponents = calendar.dateComponents([.weekday], from: date)
        }
        var componentsToSubtract = DateComponents()
        componentsToSubtract.day = 0 - ((weekdayComponents?.weekday ?? 0) - 1)
        var followingSunday: Date? = nil
        if let date = date {
            followingSunday = calendar.date(byAdding: componentsToSubtract, to: date)
        }
        var components: DateComponents? = nil
        if let followingSunday = followingSunday {
            components = calendar.dateComponents([.year, .month, .day], from: followingSunday)
        }
        if let components = components {
            followingSunday = calendar.date(from: components)
        }
        
        return followingSunday
    }

    func followingSaturdayForWeek() -> Date? {
        var comp = DateComponents()
        comp.weekOfYear = 1
        let date = calendar.date(byAdding: comp, to: self)
        var weekdayComponents: DateComponents? = nil
        if let date = date {
            weekdayComponents = calendar.dateComponents([.weekday], from: date)
        }
        var componentsToSubtract = DateComponents()
        componentsToSubtract.day = 0 - ((weekdayComponents?.weekday ?? 0) - 0)
        var day: Date? = nil
        if let date = date {
            day = calendar.date(byAdding: componentsToSubtract, to: date)
        }
        var components: DateComponents? = nil
        if let day = day {
            components = calendar.dateComponents([.year, .month, .day], from: day)
        }
        if let components = components {
            day = calendar.date(from: components)
        }
        return day
    }

    func previousSundayForWeek() -> Date? {

        let weekdayComponents = calendar.dateComponents([.weekday], from: self)
        var componentsToSubtract = DateComponents()
        componentsToSubtract.day = 0 - (weekdayComponents.weekday! - 1)
        var beginningOfWeek = calendar.date(byAdding: componentsToSubtract, to: self)
        var components: DateComponents? = nil
        if let beginningOfWeek = beginningOfWeek {
            components = calendar.dateComponents([.year, .month, .day], from: beginningOfWeek)
        }
        if let components = components {
            beginningOfWeek = calendar.date(from: components)
        }
        
        return beginningOfWeek
    }
    
    func previousMondayForWeek() -> Date? {

        let weekdayComponents = calendar.dateComponents([.weekday], from: self)
        var componentsToSubtract = DateComponents()
        componentsToSubtract.day = 0 - (weekdayComponents.weekday!)
        var beginningOfWeek = calendar.date(byAdding: componentsToSubtract, to: self)
        var components: DateComponents? = nil
        if let beginningOfWeek = beginningOfWeek {
            components = calendar.dateComponents([.year, .month, .day], from: beginningOfWeek)
        }
        if let components = components {
            beginningOfWeek = calendar.date(from: components)
        }
        return beginningOfWeek
    }
    
    func followingMondayForWeek() -> Date? {
        var comp = DateComponents()
        comp.weekOfYear = 1
        let date = calendar.date(byAdding: comp, to: self)
        var weekdayComponents: DateComponents? = nil
        if let date = date {
            weekdayComponents = calendar.dateComponents([.weekday], from: date)
        }
        var componentsToSubtract = DateComponents()
        componentsToSubtract.day = 0 - ((weekdayComponents?.weekday ?? 0))
        var followingSunday: Date? = nil
        if let date = date {
            followingSunday = calendar.date(byAdding: componentsToSubtract, to: date)
        }
        var components: DateComponents? = nil
        if let followingSunday = followingSunday {
            components = calendar.dateComponents([.year, .month, .day], from: followingSunday)
        }
        if let components = components {
            followingSunday = calendar.date(from: components)
        }
        return followingSunday
    }
    

    func startOfMonth() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: 0, to: self)!
    }

    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth()) ?? Date()
    }

    public func nextday() -> Date {
        return date(byAdding: 1)
    }

    public func prevday() -> Date {
        return date(byAdding: -1)
    }

    public func date(byAdding : Int) -> Date {
        var components = DateComponents()
        components.month = byAdding
        return Calendar.current.date(byAdding: components, to: self) ?? Date()
    }

    public func isToday()->Bool{
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
    
    public func isFutureDay() -> Bool {
        return self.timeIntervalSinceNow.sign == .plus
    }
    
    public func isFutureLocalDay() -> Bool {
        return self.compare(Date().toLocalTime()) == .orderedDescending
    }
    
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func toString(format:String)->String{
        let formater = DateFormatter()
        formater.dateFormat = format
        return formater.string(from: self)
    }
}

extension TimeInterval {

    var hourMinutesValue : String {
        guard self < Double.infinity else {
            return "0h 0m"
        }
        let time = NSInteger(self)
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return String(format: "%0.1dh %0.1dm", hours, minutes)
    }
}

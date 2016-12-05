//
//  DateAndTimeCalculable.swift
//  SocialApp
//
//  Created by Kris Rajendren on Nov/5/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation

enum DateConversionDirection: String
{
    case FromDate
    case FromString
}

enum DateAndTimeFormat
{
    enum Standard: String
    {
        case DateDisplay        =   "EEE, dd MMM, YYYY"
        case DateStamp          =   "YYYYMMdd"
        case TimeDisplay        =   "hh:mm a"
        case TimeStamp          =   "HHmmss"
        case TimeToReach        =   "mm:ss"
        case DateAndTimeDisplay =   "EEE, hh:mm a, dd MMM, YYYY"
        case DateAndTimeStamp   =   "YYYYMMddHHmmss"
        
        var string: String
        {
            return self.rawValue
        }
        var formatter: DateFormatter
        {
            let formatter = DateFormatter()
            formatter.dateFormat = self.rawValue
            return formatter
        }
    }
    
    enum Custom: String
    {
        case DateDisplayCustom              =   "customDate"
        case TimeStampNanoseconds           =   "nanosecondsTime"
        case DateAndTimeDisplayCustom       =   "customDateAndTime"
        case DateAndTimeStampNanoseconds    =   "nanosecondsDateAndTime"
        
        var string: String
        {
            return self.rawValue
        }
        var formatter: DateFormatter
        {
            let formatter = DateFormatter()
            formatter.dateFormat = DateAndTimeFormat.Standard.DateAndTimeStamp.string
            return formatter
        }
    }
}

protocol DateAndTimeType
{
    var privateDate: Date! { get set }
    var privateString: String? { get set }
    var privateFormatStandard: DateAndTimeFormat.Standard! { get set }
    var privateFormatCustom: DateAndTimeFormat.Custom! { get set }
    var privateDirection: DateConversionDirection! { get set }
    var privateIsCustom: Bool! { get set }
    var privateNanosecond: String! { get set }
    
    init()
}
extension DateAndTimeType
{
    static func fromArrayOneCustomFormat    (
    ofStrings
        strings: [String]?,
    withCustomFormat
        format: DateAndTimeFormat.Custom = .TimeStampNanoseconds
                                            ) -> [DateAndTime]?
    {
        var arrayOfDateAndTimes = [DateAndTime]()
        guard let strings = strings else { return nil }
        for string in strings
        {
            arrayOfDateAndTimes.append(DateAndTime(dateStringCustom: string, withCustom: format)!)
        }
        return arrayOfDateAndTimes
    }
    
    static func fromArrayOneStandardFormat  (
    ofStrings
        strings: [String]?,
    withStandardFormat
        format: DateAndTimeFormat.Standard = .DateAndTimeStamp
                                            ) -> [DateAndTime]?
    {
        var arrayOfDateAndTimes = [DateAndTime]()
        guard let strings = strings else { return nil }
        for string in strings
        {
            arrayOfDateAndTimes.append(DateAndTime(dateStringStandard: string, withStandard: format)!)
        }
        return arrayOfDateAndTimes
    }
    
    static func fromArrayVariableCustomFormats  (
    ofStrings
        strings: [String]?,
    withCustomFormats
        formats: [DateAndTimeFormat.Custom]?
                                                ) -> [DateAndTime]?
    {
        var arrayOfDateAndTimes = [DateAndTime]()
        guard let strings = strings else { return nil }
        guard let formats = formats else { return nil }
        for i in 1...strings.count
        {
            arrayOfDateAndTimes.append(DateAndTime(dateStringCustom: strings[i - 1], withCustom: formats[i - 1])!)
        }
        return arrayOfDateAndTimes
    }
    
    static func fromArrayVariableStandardFormats    (
    ofStrings
        strings: [String]?,
    withStandardFormats
        formats: [DateAndTimeFormat.Standard]?
                                                    ) -> [DateAndTime]?
    {
        var arrayOfDateAndTimes = [DateAndTime]()
        guard let strings = strings else { return nil }
        guard let formats = formats else { return nil }
        for i in 1...strings.count
        {
            arrayOfDateAndTimes.append(DateAndTime(dateStringStandard: strings[i - 1], withStandard: formats[i - 1])!)
        }
        return arrayOfDateAndTimes
    }
    
    init(date: Date = Date(), format: DateAndTimeFormat.Standard = .DateAndTimeStamp)
    {
        self.init()
        self.privateDate = date
        self.privateFormatStandard = format
        self.privateFormatCustom = DateAndTimeFormat.Custom.DateAndTimeStampNanoseconds
        self.privateString = nil
        if self.privateDirection != DateConversionDirection.FromString
        {
            self.privateDirection = DateConversionDirection.FromDate
        }
    }
    
    init?(dateStringStandard: String?, withStandard format: DateAndTimeFormat.Standard = .DateAndTimeStamp)
    {
        if let dateString = dateStringStandard
        {
            self.init()
            self.privateString = dateString
            self.privateFormatStandard = format
            self.privateFormatCustom = DateAndTimeFormat.Custom.DateAndTimeStampNanoseconds
            self.privateDirection = DateConversionDirection.FromString
            self.privateIsCustom = false
            
            let formatter = format.formatter
            if let date = formatter.date(from: dateString)
            {
                self.privateDate = date
            }
            else
            {
                print("There was an error in converting the given string \(fromString!) using the format \(format.rawValue) to date. Please try again.")
            }
        }
        else
        {
            self.init()
            return nil
        }
    }
    
    init?(dateStringCustom: String?, withCustom format: DateAndTimeFormat.Custom = .DateAndTimeStampNanoseconds)
    {
        if let dateString = dateStringCustom
        {
            self.init()
            let nanosecondIndex = dateString.index(dateString.startIndex, offsetBy: 14)
            self.privateNanosecond = dateString.substring(from: nanosecondIndex)
            self.privateString = dateString.substring(to: nanosecondIndex)
            let formatter = format.formatter
            self.privateDate = formatter.date(from: privateString!)
            self.privateFormatStandard = DateAndTimeFormat.Standard.DateAndTimeStamp
            self.privateFormatCustom = DateAndTimeFormat.Custom.DateAndTimeStampNanoseconds
            self.privateDirection = DateConversionDirection.FromString
            self.privateIsCustom = true
        }
        else
        {
            self.init()
            return nil
        }
    }
    
    var fromDate: Date
    {
        return privateDate
    }
    var fromString: String?
    {
        return privateString
    }
    var direction: DateConversionDirection
    {
        return privateDirection
    }
    var isCustom: Bool
    {
        return privateIsCustom
    }
    var inputNanosecond: String
    {
        return privateNanosecond
    }
    var format: DateAndTimeFormat.Standard
    {
        return privateFormatStandard
    }
    
    var date: Date
    {
        return fromDate
    }
    
    var components: DateComponents
    {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .weekOfYear, .weekOfMonth, .weekday, .day, .hour, .minute, .second, .nanosecond], from: date)
        return dateComponents
    }
    var year: Int
    {
        return components.year!
    }
    var yearString: String
    {
        return year.description
    }
    var month: Int
    {
        return components.month!
    }
    var monthString: String
    {
        return month.toMonthString(form: .Short)
    }
    var weekOfYear: Int
    {
        return components.weekOfYear!
    }
    var weekOfMonth: Int
    {
        return components.weekOfMonth!
    }
    var weekday: Int
    {
        return components.weekday!
    }
    var weekdayString: String
    {
        return weekday.toWeekdayString(form: .Short)
    }
    var day: Int
    {
        return components.day!
    }
    var dayString: String
    {
        return day.toDayString(form: .Long)
    }
    var hour: Int
    {
        return components.hour!
    }
    var minute: Int
    {
        return components.minute!
    }
    var second: Int
    {
        return components.second!
    }
    var nanosecond: Int
    {
        if inputNanosecond == Constants.Literal.Empty
        {
            return components.nanosecond!
        }
        else
        {
            return Int(inputNanosecond)!
        }
    }
    
    var dateDisplay: String
    {
        return "\(weekdayString), \(dayString) \(monthString), \(yearString)"
    }
    var timeDisplay: String
    {
        return convertToString(with: .TimeDisplay)
    }
    var dateAndTimeDisplay: String
    {
        return "\(weekdayString), \(timeDisplay), \(dayString) \(monthString), \(yearString)"
    }
    var stamp: String
    {
        return convertToString(with: .DateAndTimeStamp)
    }
    var stampNanoseconds: String
    {
        return "\(stamp)\(nanosecond)"
    }
    
    func convertToString(with format: DateAndTimeFormat.Standard) -> String
    {
        let formatter = format.formatter
        return formatter.string(from: date)
    }
}

class DateAndTime: DateAndTimeType
{
    var privateDate: Date! = Date()
    var privateString: String? = Constants.Literal.Empty
    var privateFormatStandard: DateAndTimeFormat.Standard! = DateAndTimeFormat.Standard.DateAndTimeStamp
    var privateFormatCustom: DateAndTimeFormat.Custom! = DateAndTimeFormat.Custom.DateAndTimeStampNanoseconds
    var privateDirection: DateConversionDirection! = .FromDate
    var privateIsCustom: Bool! = false
    var privateNanosecond: String! = Constants.Literal.Empty
    
    required init() {}
}

extension Int
{
    enum DateForm
    {
        enum Form
        {
            case Short
            case Long
        }
        
        enum Weekday: String
        {
            case Sun
            case Mon
            case Tue
            case Wed
            case Thu
            case Fri
            case Sat
            
            var longForm: String
            {
                switch self
                {
                case .Sun:
                    return "Sunday"
                case .Mon:
                    return "Monday"
                case .Tue:
                    return "Tuesday"
                case .Wed:
                    return "Wednesday"
                case .Thu:
                    return "Thursday"
                case .Fri:
                    return "Friday"
                case .Sat:
                    return "Saturday"
                }
            }
            
            var shortForm: String
            {
                return self.rawValue
            }
            
            func toString(form: Form) -> String
            {
                switch form
                {
                case .Long:  return self.longForm
                case .Short: return self.shortForm
                }
            }
        }
        
        enum DaySuffix: String
        {
            case First = "st"
            case Second = "nd"
            case Third = "rd"
            case Fourth = "th"
        }
        
        enum Month: String
        {
            case Jan
            case Feb
            case Mar
            case Apr
            case May
            case Jun
            case Jul
            case Aug
            case Sep
            case Oct
            case Nov
            case Dec
            
            var longForm: String
            {
                switch self
                {
                case .Jan:
                    return "January"
                case .Feb:
                    return "February"
                case .Mar:
                    return "March"
                case .Apr:
                    return "April"
                case .May:
                    return "May"
                case .Jun:
                    return "June"
                case .Jul:
                    return "July"
                case .Aug:
                    return "August"
                case .Sep:
                    return "September"
                case .Oct:
                    return "October"
                case .Nov:
                    return "November"
                case .Dec:
                    return "December"
                }
            }
            
            var shortForm: String
            {
                return self.rawValue
            }
            
            func toString(form: Form) -> String
            {
                switch form
                {
                case .Long:  return self.longForm
                case .Short: return self.shortForm
                }
            }
        }
    }
    
    func dayStringSuffix() -> String
    {
        let onesDigit = self % 10
        if self >= 11 && self <= 20
        {
            return DateForm.DaySuffix.Fourth.rawValue
        }
        else
        {
            switch onesDigit
            {
            case 1:
                return DateForm.DaySuffix.First.rawValue
            case 2:
                return DateForm.DaySuffix.Second.rawValue
            case 3:
                return DateForm.DaySuffix.Third.rawValue
            default:
                return DateForm.DaySuffix.Fourth.rawValue
            }
        }
    }
    
    func toDayString(form: DateForm.Form) -> String
    {
        if self <= 31 && self >= 1
        {
            var number: String
            {
                if self < 10
                {
                    return "0\(self)"
                }
                else
                {
                    return "\(self)"
                }
            }
            
            switch form
            {
            case .Long: return ("\(self)\(self.dayStringSuffix())")
            case .Short: return ("\(number)")
            }
        }
        else
        {
            print("The integer value \(self) could not be converted to a day value as it is not between 1 and 31.")
            return Constants.Literal.Empty
        }
    }
    
    func toWeekdayString(form: DateForm.Form) -> String
    {
        switch self
        {
        case 1:
            return DateForm.Weekday.Sun.toString(form: form)
        case 2:
            return DateForm.Weekday.Mon.toString(form: form)
        case 3:
            return DateForm.Weekday.Tue.toString(form: form)
        case 4:
            return DateForm.Weekday.Wed.toString(form: form)
        case 5:
            return DateForm.Weekday.Thu.toString(form: form)
        case 6:
            return DateForm.Weekday.Fri.toString(form: form)
        case 7:
            return DateForm.Weekday.Sat.toString(form: form)
        default:
            print("The integer value \(self) could not be converted to a weekday value as it is not between 1 and 7.")
            return Constants.Literal.Empty
        }
    }
    
    func toMonthString(form: DateForm.Form) -> String
    {
        switch self
        {
        case 1:
            return DateForm.Month.Jan.toString(form: form)
        case 2:
            return DateForm.Month.Feb.toString(form: form)
        case 3:
            return DateForm.Month.Mar.toString(form: form)
        case 4:
            return DateForm.Month.Apr.toString(form: form)
        case 5:
            return DateForm.Month.May.toString(form: form)
        case 6:
            return DateForm.Month.Jun.toString(form: form)
        case 7:
            return DateForm.Month.Jul.toString(form: form)
        case 8:
            return DateForm.Month.Aug.toString(form: form)
        case 9:
            return DateForm.Month.Sep.toString(form: form)
        case 10:
            return DateForm.Month.Oct.toString(form: form)
        case 11:
            return DateForm.Month.Nov.toString(form: form)
        case 12:
            return DateForm.Month.Dec.toString(form: form)
        default:
            print("The integer value \(self) could not be converted to a month value as it is not between 1 and 12.")
            return Constants.Literal.Empty
        }
    }
}

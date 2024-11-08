//
//  DateFormating.swift
//  Notify me
//
//  Created by mayar on 13/07/2024.
//

import Foundation

class DateFormating{
    
  static func formatDateAndTime(from dateComponents: DateComponents) -> String? {
       let calendar = Calendar.current
       guard let date = calendar.date(from: dateComponents) else { return nil }
       let dateFormatter = DateFormatter()
       dateFormatter.dateStyle = .medium
       dateFormatter.timeStyle = .short
       return dateFormatter.string(from: date)
   }

   static func getCurrentDateTime() -> String {
       let currentDate = Date()
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy-MM-dd , HH:mm "
       let dateTimeString = formatter.string(from: currentDate)
       return dateTimeString
   }
   
    static func parseDate(from string: String) -> Date? {
        let trimmedString = string.trimmingCharacters(in: CharacterSet(charactersIn: "Optional()\""))
        let components = trimmedString.components(separatedBy: " ")

        var dateComponents = DateComponents()

        for component in components {
            let parts = component.components(separatedBy: ": ")
            guard parts.count == 2 else { continue }

            let key = parts[0]
            let value = parts[1]

            switch key {
            case "year":
                dateComponents.year = Int(value)
            case "month":
                dateComponents.month = Int(value)
            case "day":
                dateComponents.day = Int(value)
            case "hour":
                dateComponents.hour = Int(value)
            case "minute":
                dateComponents.minute = Int(value)
            default:
                continue
            }
        }

        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }
}

//
//  ASPData.swift
//  NYC-ASP-Status
//
//  Created by Jia Sheng Ma on 8/15/22.
//

import Foundation

func getTodayInString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    
    return dateFormatter.string(from: Date())
}

let nyc311PortalURL = "https://portal.311.nyc.gov/home-cal/?today=\(getTodayInString())"

struct ASPStatus {
    let aspStatus: String
    let aspStatusDescription: String
    let date: String = Date().formatted(date: .complete, time: .omitted)
}

struct ASPData {
    static func fetch() async throws -> ASPStatus {
        let url = URL(string: nyc311PortalURL)!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let aspStatus = decodeNYC311PortalData(fromData: data)
        return aspStatus
    }

    /*
     {
         "totalcount": "3",
         "date" : "8/15/2022 6:44:29 PM",
         "results": [

             {
                   "Calendarid" : "663891c5-4a90-e811-a963-000d3a199795",
                   "CalendarName" : "Alternate Side Parking",
                   "CalendarType" : {  "Id" : "b42ddb6b-4a90-e811-a963-000d3a199795",
                                       "Name" : "Alternate Side Parking"
                                     },
                   "IconUrl" : "https://www1.nyc.gov/portal/apps/311_images/ico-parking.png",
                   "SaturdayContentFormat" : "Alternate side parking and meters are in effect.",
                   "SaturdayRecordName" : "IN EFFECT",
                   "SundayContentFormat" : "Alternate side parking and meters are not in effect on Sundays.",
                   "SundayRecordName" : "NOT IN EFFECT",
                   "WeekDayContentFormat" : "Alternate side parking and meters are in effect.",
                   "WeekDayRecordName" : "IN EFFECT",
                   "CalendarTypeRecordName" : "Alternate Side Parking",
                   "CalendarDetailName" : "Feast of the Assumption 2022",
                   "CalendarDetailMessage" : "Alternate side parking is suspended for Feast of the Assumption. Meters are in effect.",
                   "CalendarDetailStatus" : "SUSPENDED"
             },

             {
                   "Calendarid" : "e0122d57-4b90-e811-a963-000d3a199795",
                   "CalendarName" : "Collections",
                   "CalendarType" : {  "Id" : "3c1385e5-4a90-e811-a963-000d3a199795",
                                       "Name" : "Collections"
                                     },
                   "IconUrl" : "https://www1.nyc.gov/portal/apps/311_images/ico-trash.png",
                   "SaturdayContentFormat" : "Trash and recycling collections are on schedule. Compost collections in participating neighborhoods are also on schedule.",
                   "SaturdayRecordName" : "ON SCHEDULE",
                   "SundayContentFormat" : "Trash, recycling, and compost collections are not in effect on Sundays.",
                   "SundayRecordName" : "NOT IN EFFECT",
                   "WeekDayContentFormat" : "Trash and recycling collections are on schedule. Compost collections in participating neighborhoods are also on schedule.",
                   "WeekDayRecordName" : "ON SCHEDULE",
                   "CalendarTypeRecordName" : "Collections",
                   "CalendarDetailName" : "",
                   "CalendarDetailMessage" : "",
                   "CalendarDetailStatus" : ""
             },

             {
                   "Calendarid" : "09fdd6c5-4b90-e811-a963-000d3a199795",
                   "CalendarName" : "Schools",
                   "CalendarType" : {  "Id" : "aaace56f-4b90-e811-a963-000d3a199795",
                                       "Name" : "Schools"
                                     },
                   "IconUrl" : "https://www1.nyc.gov/portal/apps/311_images/ico-school.png",
                   "SaturdayContentFormat" : "Public schools are not in session.",
                   "SaturdayRecordName" : "NOT IN SESSION",
                   "SundayContentFormat" : "Public schools are not in session.",
                   "SundayRecordName" : "NOT IN SESSION",
                   "WeekDayContentFormat" : "Public schools are open.",
                   "WeekDayRecordName" : "OPEN",
                   "CalendarTypeRecordName" : "Schools",
                   "CalendarDetailName" : "Summer 2022",
                   "CalendarDetailMessage" : "Public schools are not in session.",
                   "CalendarDetailStatus" : "NOT IN SESSION"
             }
             ]
       }
     */
    static func decodeNYC311PortalData(fromData data: Foundation.Data) -> ASPStatus {
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let portalDataResults = json["results"] as! [[String: Any]]
        let aspResults = portalDataResults[0]
        let aspStatus = aspResults["CalendarDetailStatus"] as! String
        let aspStatusDescription = aspResults["CalendarDetailName"] as! String

        return ASPStatus(
            aspStatus: aspStatus,
            aspStatusDescription:aspStatusDescription
        )
    }
}

func getASPStatus() async -> ASPStatus {
    var aspStatus = ASPStatus(aspStatus: "N/A", aspStatusDescription: "N/A")
    do {
        aspStatus = try await ASPData.fetch()
    } catch {
        print(error)
    }

    return aspStatus
}

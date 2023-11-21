//
//  WeeklyWeatherResult+CoreDataProperties.swift
//
//
//  Created by Eyüphan Akkaya on 21.11.2023.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


@objc(WeeklyWeatherResult)
class WeeklyWeatherResult: NSManagedObject {
    
}
extension WeeklyWeatherResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeeklyWeatherResult> {
        return NSFetchRequest<WeeklyWeatherResult>(entityName: "WeeklyWeatherResult")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var data: [WeatherData]?

}

extension WeeklyWeatherResult : Identifiable {

}

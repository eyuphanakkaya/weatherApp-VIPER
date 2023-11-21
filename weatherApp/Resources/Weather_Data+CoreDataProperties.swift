//
//  Weather_Data+CoreDataProperties.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 21.11.2023.
//
//

import Foundation
import CoreData


extension Weather_Data {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather_Data> {
        return NSFetchRequest<Weather_Data>(entityName: "Weather_Data")
    }

    @NSManaged public var app_max_temp: Double
    @NSManaged public var weather: String?
    @NSManaged public var myWeatherResult: Weather_Result?
    @NSManaged public var weatherLast: NSSet?

}

// MARK: Generated accessors for weatherLast
extension Weather_Data {

    @objc(addWeatherLastObject:)
    @NSManaged public func addToWeatherLast(_ value: WeatherLast)

    @objc(removeWeatherLastObject:)
    @NSManaged public func removeFromWeatherLast(_ value: WeatherLast)

    @objc(addWeatherLast:)
    @NSManaged public func addToWeatherLast(_ values: NSSet)

    @objc(removeWeatherLast:)
    @NSManaged public func removeFromWeatherLast(_ values: NSSet)

}

extension Weather_Data : Identifiable {

}

//
//  Weather_Result+CoreDataProperties.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 21.11.2023.
//
//

import Foundation
import CoreData


extension Weather_Result {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather_Result> {
        return NSFetchRequest<Weather_Result>(entityName: "Weather_Result")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var data: String?
    @NSManaged public var myWeatherData: NSSet?

}

// MARK: Generated accessors for myWeatherData
extension Weather_Result {

    @objc(addMyWeatherDataObject:)
    @NSManaged public func addToMyWeatherData(_ value: Weather_Data)

    @objc(removeMyWeatherDataObject:)
    @NSManaged public func removeFromMyWeatherData(_ value: Weather_Data)

    @objc(addMyWeatherData:)
    @NSManaged public func addToMyWeatherData(_ values: NSSet)

    @objc(removeMyWeatherData:)
    @NSManaged public func removeFromMyWeatherData(_ values: NSSet)

}

extension Weather_Result : Identifiable {

}

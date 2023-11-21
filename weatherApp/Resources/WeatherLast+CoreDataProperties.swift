//
//  WeatherLast+CoreDataProperties.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 21.11.2023.
//
//

import Foundation
import CoreData


extension WeatherLast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherLast> {
        return NSFetchRequest<WeatherLast>(entityName: "WeatherLast")
    }

    @NSManaged public var descriptions: String?
    @NSManaged public var weatherData: [Weather_Data]?

}

extension WeatherLast : Identifiable {

}

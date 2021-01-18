//
//  AnalyticsManager.swift
//  Disaster Management
//
//  Created by Arnold Rebello on 7/8/20.
//  Copyright © 2020 Arnold Rebello. All rights reserved.
//

import Foundation

struct AnalyticsManager {
    var fire = 0
    let pickerData = [
Fire(region: "Canada", fileURL: "https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/kml/J1_VIIRS_C2_Canada_24h.kml", mapQuery: "Canada"),
Fire(region: "Alaska", fileURL: "https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/kml/J1_VIIRS_C2_Alaska_24h.kml", mapQuery: "Alaska"),
Fire(region: "USA", fileURL: "https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/kml/J1_VIIRS_C2_USA_contiguous_and_Hawaii_24h.kml", mapQuery: "USA"),
Fire(region: "Central America", fileURL: "https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/kml/J1_VIIRS_C2_Central_America_24h.kml", mapQuery: "Central America"),
Fire(region: "South America", fileURL: "https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/kml/J1_VIIRS_C2_South_America_24h.kml", mapQuery: "South America"),
Fire(region: "Europe", fileURL: "https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/kml/J1_VIIRS_C2_Europe_24h.kml", mapQuery: "Europe"),
Fire(region: "Central Africa", fileURL: "https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/kml/J1_VIIRS_C2_Northern_and_Central_Africa_24h.kml",mapQuery: "Africa"),
Fire(region: "South Africa", fileURL: "https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/kml/J1_VIIRS_C2_Southern_Africa_24h.kml", mapQuery: "South Africa"),
Fire(region: "Central Asia", fileURL: "https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/kml/J1_VIIRS_C2_Russia_Asia_24h.kml", mapQuery: "Asia"),
Fire(region: "South Asia", fileURL: "https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/kml/J1_VIIRS_C2_South_Asia_24h.kml", mapQuery: "India"),
Fire(region: "South East Asia", fileURL: "https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/kml/J1_VIIRS_C2_SouthEast_Asia_24h.kml", mapQuery: "Vietnam"),
Fire(region: "Australia and New Zealand", fileURL: "https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/kml/J1_VIIRS_C2_Australia_NewZealand_24h.kml", mapQuery: "Australia"),

    ]

}


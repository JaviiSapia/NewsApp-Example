//
//  Article.swift
//  NewsApp
//
//  Modelo desarrollado para representar articulos
//

import Foundation
import UIKit
import SwiftyJSON

struct Article {
    
    var headline: String?
    var trailtext: String?
    var content: String?
    var section: String?
    var date: String?
    var image: String?
    
    init(json: JSON) {
        self.headline = json["fields"]["headline"].string
        self.trailtext = json["fields"]["trailText"].string
        self.content = json["apiUrl"].string
        self.section = json["sectionName"].string?.uppercased()
        self.date = getDateFormated(date: json["fields"]["firstPublicationDate"].string!)
        self.image = json["fields"]["thumbnail"].string
    }
    
    private func getDateFormated(date: String) -> String? {
        let dateString = date
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: dateString)
        let dateFormatter2 = ISO8601DateFormatter()
        dateFormatter2.formatOptions = .withFullDate
        return dateFormatter2.string(from: date!)
    }
    
}

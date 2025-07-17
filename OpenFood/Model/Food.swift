//
//  Food.swift
//  OpenFood
//
//  Created by Jonathan Ngabo on 2025-07-16.
//

import Foundation

struct Food: Codable, Identifiable {
    let id: Int?
    let name: String?
    var isLiked: Bool?
    let photoURL: String?
    let foodDetails: String?
    let countryOfOrigin: String?
    let lastUpdatedDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isLiked
        case photoURL
        case foodDetails = "description"
        case countryOfOrigin
        case lastUpdatedDate
    }
    
    var countryName: String {
        if let countryOfOrigin = countryOfOrigin {
            let locale: Locale = .current
            return locale.localizedString(forRegionCode: countryOfOrigin) ?? countryOfOrigin
        }else {
            return ""
        }
        
    }

    var foodName: String {
        if let name = name {
            return name
        }else {
            return ""
        }
    }
    
    var foodDescription: String {
        if let foodDetails = foodDetails {
            return foodDetails
        }else {
            return ""
        }
    }
    
    var url: URL? {
        if let imageURL = self.photoURL , let url = URL(string: imageURL) {
            return url
        }
        
        return nil
    }
    
    var lastUpdated: String {
        if let splitComponent = lastUpdatedDate?.split(separator: "T"), let date = splitComponent.first {
            return date.description
        }
        
        return "N/A"
    }
}


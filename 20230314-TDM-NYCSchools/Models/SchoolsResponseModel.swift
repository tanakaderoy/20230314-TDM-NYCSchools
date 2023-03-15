//
//  SchoolsResponseModel.swift
//  20230314-TDM-NYCSchools
//
//  Created by Tanaka Mazivanhanga on 3/15/23.
//

import Foundation

struct SchoolsResponseModel: Codable {
    let dbn:String
    let schoolName: String
    let overViewParagraph: String
    let primaryAddressLine1: String
    let city: String
    let zip: String
    let state: String
    
    enum CodingKeys: String, CodingKey {
        case primaryAddressLine1 = "primary_address_line_1"
        case schoolName = "school_name"
        case state = "state_code"
        case overViewParagraph = "overview_paragraph"
        case zip
        case city
        case dbn
    }
    
    
}

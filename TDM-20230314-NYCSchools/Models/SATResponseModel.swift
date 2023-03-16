//
//  SATResponseModel.swift
//  20230314-TDM-NYCSchools
//
//  Created by Tanaka Mazivanhanga on 3/16/23.
//

import Foundation

struct SATResponseModel: Codable {
    let dbn: String
    let name: String
    let numberOfTakers:String
    let readingScore,mathScore,writingScore: String
    
    
    enum CodingKeys: String, CodingKey {
        case dbn = "dbn"
        case name = "school_name"
        case numberOfTakers = "num_of_sat_test_takers"
        case readingScore = "sat_critical_reading_avg_score"
        case mathScore = "sat_math_avg_score"
        case writingScore = "sat_writing_avg_score"
    }
}

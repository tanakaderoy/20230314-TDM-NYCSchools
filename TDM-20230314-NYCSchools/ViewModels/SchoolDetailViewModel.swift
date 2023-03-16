//
//  SchoolDetailViewModel.swift
//  20230314-TDM-NYCSchools
//
//  Created by Tanaka Mazivanhanga on 3/15/23.
//

import UIKit

protocol SchoolDetailViewModelDelegate: AnyObject {
    func didGetSATInfo(_ satTakersText:String,_ readingScoreText:String,_ writingScoreText:String,_ mathScoreText:String)
}

final class SchoolDetailViewModel {
    private let school: SchoolsResponseModel
    
    public weak var delegate: SchoolDetailViewModelDelegate?
    private let apiService: APIServiceProtocol
    
    init(school:SchoolsResponseModel,apiService: APIServiceProtocol = APIService.shared) {
        self.school = school
        self.apiService = apiService
    }
    
    public var name: String {
        return school.schoolName
    }
    
    var overview: String {
        return school.overViewParagraph
    }
    
    var address: String {
        return school.primaryAddressLine1
    }
    
    var city: String {
        return school.city
    }
    
    var state: String {
        return school.state
    }
    
    var zip: String {
        return school.zip
    }
    
    var fullAddress: String {
        return "\(address), \(city) \(state) \(zip)"
    }
    
    private var satTakers: String = "N/A" {
        didSet {
            satTakersText = "Num of SAT Takers: \(satTakers)"
        }
    }
    var satTakersText = ""
    var mathScoreText = ""
    var writingScoreText = ""
    var readingScoreText = ""
    private var readingScore: String = ""{
        didSet {
            readingScoreText = "Reading: \(readingScore)"
        }
    }
    private var mathScore: String = ""{
        didSet {
            mathScoreText = "Math: \(mathScore)"
        }
    }
    private var writingScore: String = ""{
        didSet {
            writingScoreText = "Writing: \(writingScore)"
        }
    }
    
    
    func getSATInfo() async {
        let res = await apiService.getSATInfo(dbn: school.dbn)
        
        switch res {
        case .success(let testInfo):
            satTakers = testInfo.numberOfTakers
            readingScore = testInfo.readingScore
            writingScore = testInfo.writingScore
            mathScore = testInfo.mathScore
        case .failure(_):
            satTakers = "N/A"
            readingScore = "N/A"
            mathScore = "N/A"
            writingScore = "N/A"
        }
        await MainActor.run {
            delegate?.didGetSATInfo(satTakersText,readingScoreText,writingScoreText,mathScoreText)
        }
    }
    
}

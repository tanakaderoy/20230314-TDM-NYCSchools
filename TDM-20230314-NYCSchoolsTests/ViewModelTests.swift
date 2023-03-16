//
//  SchoolsListViewViewModelTests.swift
//  TDM-20230314-NYCSchoolsTests
//
//  Created by Tanaka Mazivanhanga on 3/16/23.
//

import XCTest
@testable import TDM_20230314_NYCSchools

final class SchoolsListViewViewModelTests: XCTestCase {
    
    var schoolsListViewViewModel: SchoolsListViewViewModel!
    var schoolDetailViewModel: SchoolDetailViewModel!
    var mockAPIService: MockApiService!
    var mockSchool: SchoolsResponseModel!
    var mockSchoolDetailViewModelDelegate: MockSchoolDetailViewModelDelegate!

    override func setUp()  {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockAPIService = MockApiService()
        mockSchool = SchoolsResponseModel(dbn: "dbn", schoolName: "School", overViewParagraph: "Hello", primaryAddressLine1: "Address", location: "Location", city: "City", zip: "ZIP", state: "NY")
        schoolDetailViewModel = .init(school: mockSchool, apiService: mockAPIService)
        schoolsListViewViewModel = .init(apiService: mockAPIService)
        mockSchoolDetailViewModelDelegate = MockSchoolDetailViewModelDelegate()
        schoolDetailViewModel.delegate = mockSchoolDetailViewModelDelegate
        
   
    }
    
    func testGetAllSchools() async {
        await schoolsListViewViewModel.getSchools()
        
        XCTAssertEqual(schoolsListViewViewModel.schools.count, 1)
        
        XCTAssertEqual(schoolsListViewViewModel.schools[0].schoolName, mockSchool.schoolName)
        

    }
    
    func testGetSATInfo() async {
        await schoolDetailViewModel.getSATInfo()
        
        XCTAssertEqual(mockSchoolDetailViewModelDelegate.satInfoArray.count, 1)
        
        XCTAssertEqual(mockSchoolDetailViewModelDelegate.satInfoArray[0].satTakersText, "Num of SAT Takers: 100")
    }



}


final class MockApiService: APIServiceProtocol {
    func getAllSchools() async -> Result<[TDM_20230314_NYCSchools.SchoolsResponseModel], Error> {
        let mockSchool = SchoolsResponseModel(dbn: "dbn", schoolName: "School", overViewParagraph: "Hello", primaryAddressLine1: "Address", location: "Location", city: "City", zip: "ZIP", state: "NY")
        return .success([mockSchool])
    }
    
    func getSATInfo(dbn: String) async -> Result<TDM_20230314_NYCSchools.SATResponseModel, Error> {
        let mockSAT = SATResponseModel(dbn: "dbn", name: "School", numberOfTakers: "100", readingScore: "400", mathScore: "400", writingScore: "400")
        return .success(mockSAT)
    }
    
    
}


final class MockSchoolDetailViewModelDelegate: SchoolDetailViewModelDelegate {
    var satInfoArray: [(satTakersText: String, readingScoreText: String, writingScoreText: String, mathScoreText: String)] = []
    func didGetSATInfo(_ satTakersText: String, _ readingScoreText: String, _ writingScoreText: String, _ mathScoreText: String) {
        
        satInfoArray.append((satTakersText,readingScoreText,writingScoreText,mathScoreText))
        
    }
    
    
}

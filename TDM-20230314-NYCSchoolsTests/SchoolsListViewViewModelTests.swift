//
//  SchoolsListViewViewModelTests.swift
//  TDM-20230314-NYCSchoolsTests
//
//  Created by Tanaka Mazivanhanga on 3/16/23.
//

import XCTest
@testable import TDM_20230314_NYCSchools

final class SchoolsListViewViewModelTests: XCTestCase {
    
    var viewModel: SchoolsListViewViewModel!
    var mockAPIService: MockApiService!

    override func setUp()  {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockAPIService = MockApiService()
        viewModel = .init(apiService:mockAPIService)
    }
    
    func test1() async {
        await viewModel.getSchools()
        
        XCTAssertEqual(viewModel.schools.count, 0)
        

    }



}


final class MockApiService: APIServiceProtocol {
    func getAllSchools() async -> Result<[TDM_20230314_NYCSchools.SchoolsResponseModel], Error> {
        return .success([])
    }
    
    func getSATInfo(dbn: String) async -> Result<TDM_20230314_NYCSchools.SATResponseModel, Error> {
        return .failure(NSError(domain: "Hello", code: 0))
    }
    
    
}

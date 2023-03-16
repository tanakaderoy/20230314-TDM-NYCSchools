//
//  APIService.swift
//  20230314-TDM-NYCSchools
//
//  Created by Tanaka Mazivanhanga on 3/14/23.
//

import Foundation

protocol APIServiceProtocol {
    func getAllSchools() async -> Result<[SchoolsResponseModel], Error>
    func getSATInfo(dbn: String) async -> Result<SATResponseModel, Error>
}

final class APIService: APIServiceProtocol {
    static let shared = APIService()
    
    private init() {}
    
    enum APIError: Error {
        case urlError
        case emptyArray
    }
    
    public func fetch<T: Codable> (_ urlString: String, expecting: T.Type) async -> Result<T,Error> {
        do {
            guard let url = URL(string: urlString) else { return .failure(APIError.urlError)}
            let (data,_) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        }catch (let error){
            return .failure(error)
        }
    }
}


extension APIService {
     func getAllSchools() async -> Result<[SchoolsResponseModel], Error> {
        let result = await fetch(Constants.SCHOOLS_ENDPOINT, expecting: [SchoolsResponseModel].self.self)
        switch result {
        case .success(let response):
            return .success(response)
        case .failure(let error):
            return .failure(error)
        }
    }
    
     func getSATInfo(dbn: String) async -> Result<SATResponseModel, Error> {
        // could do url components and stuff here
        let result = await fetch("\(Constants.SAT_ENDPOINT)?dbn=\(dbn)", expecting: [SATResponseModel].self)
        switch result {
        case .success(let response):
            guard let testinfo = response.first else {return .failure(APIError.emptyArray)}
            print(testinfo)
            return .success(testinfo)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    
}

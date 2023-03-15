//
//  APIService.swift
//  20230314-TDM-NYCSchools
//
//  Created by Tanaka Mazivanhanga on 3/14/23.
//

import Foundation

final class APIService {
    static let shared = APIService()
    
    private init() {}
    
    enum APIError: Error {
        case urlError
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
    static func getAllSchools() async -> Result<[SchoolsResponseModel], Error> {
        let result = await APIService.shared.fetch(Constants.SCHOOLS_ENDPOINT, expecting: [SchoolsResponseModel].self.self)
        switch result {
        case .success(let response):
            return .success(response)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    
}

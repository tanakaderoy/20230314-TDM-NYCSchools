//
//  SchoolsListViewViewModel.swift
//  20230314-TDM-NYCSchools
//
//  Created by Tanaka Mazivanhanga on 3/14/23.
//

import UIKit

protocol SchoolsListViewViewModelDelegate: AnyObject {
    func didLoadSchools()
    func didSelectSchool(_ school: SchoolsResponseModel)
    func reloadData()
}

final class SchoolsListViewViewModel: NSObject {
    public weak var delegate: SchoolsListViewViewModelDelegate?
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    private(set) var schools:[SchoolsResponseModel] = [] {
        didSet {
            cellViewModels = schools.map({SchoolsListCellViewModel(schoolName: $0.schoolName)})
        }
    }
    
    var filteredSchools: [SchoolsResponseModel] = []{
        didSet {
            filteredCellViewModels = filteredSchools.map({SchoolsListCellViewModel(schoolName: $0.schoolName)})
        }
    }
    var isFiltered = false
    
    private var cellViewModels: [SchoolsListCellViewModel] = []
    private var filteredCellViewModels: [SchoolsListCellViewModel] = []
    
    public func getSchools() async {
        let res = await apiService.getAllSchools()
        switch res {
        case .success(let schools):
            self.schools = schools
            await MainActor.run{
                delegate?.didLoadSchools()
            }
        case .failure(let error):
            //TODO: Handle Error Better
            print(error)
        }
    }
}


extension SchoolsListViewViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let school = schools[indexPath.row]
        delegate?.didSelectSchool(school)
    }
    
}


extension SchoolsListViewViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltered ? filteredCellViewModels.count : cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SchoolsListTableViewCell.identifier) as? SchoolsListTableViewCell else {fatalError("Unsupportedd Cell")}
        if isFiltered {
            cell.configure(with: filteredCellViewModels[indexPath.row])
        }else {
            cell.configure(with: cellViewModels[indexPath.row])
        }
        return cell
    }
    
    
}

extension SchoolsListViewViewModel: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            filteredSchools = schools.filter({$0.schoolName.lowercased().contains(searchText.lowercased())})
            isFiltered = true
        }
        else{
            isFiltered = false
        }
        delegate?.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltered = false
        searchBar.text = ""
        searchBar.searchTextField.resignFirstResponder()
        delegate?.reloadData()
    }
    
}


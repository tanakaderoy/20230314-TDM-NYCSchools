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
}

final class SchoolsListViewViewModel: NSObject {
    public weak var delegate: SchoolsListViewViewModelDelegate?
    
    private var schools:[SchoolsResponseModel] = [] {
        didSet {
            cellViewModels = schools.map({SchoolsListCellViewModel(schoolName: $0.schoolName)})
        }
    }
    
    private var cellViewModels: [SchoolsListCellViewModel] = []
    
    public func getSchools() async {
        let res = await APIService.getAllSchools()
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
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SchoolsListTableViewCell.identifier) as? SchoolsListTableViewCell else {fatalError("Unsupportedd Cell")}
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    
}

//
//  SchoolsListView.swift
//  20230314-TDM-NYCSchools
//
//  Created by Tanaka Mazivanhanga on 3/14/23.
//

import UIKit

protocol SchoolsListViewDelegate: AnyObject {
    func schoolsListView(_ schoolsListView: SchoolsListView, didSelectSchool school: SchoolsResponseModel)
}



final class SchoolsListView: UIView {
    private var viewModel: SchoolsListViewViewModel
    
    var delegate: SchoolsListViewDelegate?
    
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.activateTamic()
        return spinner
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.activateTamic()
        tableView.register(SchoolsListTableViewCell.self, forCellReuseIdentifier: SchoolsListTableViewCell.identifier)
        tableView.alpha = 0
        return tableView
    }()
    
    required init(viewModel: SchoolsListViewViewModel = SchoolsListViewViewModel()){
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.activateTamic()
        addSubviews(tableView, spinner)
        
        spinner.startAnimating()
        addConstraints()
        setupTableView()
        viewModel.delegate = self
        
        Task {
            await viewModel.getSchools()
        }

    }
    
    
    private func setupTableView(){
        // delegate & datasource
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
    }
    
    
    private func addConstraints() {
        tableView.fillInParent()
        spinner.centerInParent()
    }
    

    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


extension SchoolsListView: SchoolsListViewViewModelDelegate {
    func didLoadSchools() {
        tableView.reloadData()
        spinner.stopAnimating()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.tableView.alpha = 1
        }
    }
    
    
    func didSelectSchool(_ school: SchoolsResponseModel) {
        delegate?.schoolsListView(self, didSelectSchool: school)
    }
}

//
//  SchoolsListViewController.swift
//  20230314-TDM-NYCSchools
//
//  Created by Tanaka Mazivanhanga on 3/14/23.
//

import UIKit



class SchoolsListViewController: UIViewController {
    
    private var schoolsListView: SchoolsListView!
        
    init(schoolsListView: SchoolsListView = SchoolsListView()) {
        self.schoolsListView = schoolsListView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Schools"
        
        view.addSubview(schoolsListView)
        schoolsListView.fitInParentLayoutGuide()
        schoolsListView.delegate = self

    }
    
}


extension SchoolsListViewController: SchoolsListViewDelegate {
    func schoolsListView(_ schoolsListView: SchoolsListView, didSelectSchool school: SchoolsResponseModel) {
        //Navigate to School Detail View
        print(school)
    }
    
    
}






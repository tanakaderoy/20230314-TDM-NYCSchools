//
//  SchoolsListTableViewCell.swift
//  20230314-TDM-NYCSchools
//
//  Created by Tanaka Mazivanhanga on 3/15/23.
//

import UIKit

class SchoolsListTableViewCell: UITableViewCell {
    static let identifier = String(describing:SchoolsListTableViewCell.self)
    
    var nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.activateTamic()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        addSubview(nameLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
     func addConstraints() {
        let constraints:[NSLayoutConstraint] = [
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    func configure(with viewModel: SchoolsListCellViewModel){
        nameLabel.text = viewModel.schoolName
        
    }

}

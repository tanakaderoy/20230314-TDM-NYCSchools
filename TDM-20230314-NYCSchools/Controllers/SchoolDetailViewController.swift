//
//  SchoolDetailViewController.swift
//  20230314-TDM-NYCSchools
//
//  Created by Tanaka Mazivanhanga on 3/15/23.
//

import UIKit
import MapKit

class SchoolDetailViewController: UIViewController {
    
    private let viewModel: SchoolDetailViewModel
    
    private let mapView: MKMapView = {
        let mv = MKMapView()
        mv.activateTamic()
        mv.mapType = .standard
        mv.isZoomEnabled = true
        mv.isScrollEnabled = true
        return mv
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.activateTamic()
        label.numberOfLines = 0
        label.lineBreakMode  = .byWordWrapping
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    private var satTakersLabel: UILabel = {
        let label = UILabel()
        label.activateTamic()
        return label
    }()
    private var satReadingLabel: UILabel = {
        let label = UILabel()
        label.activateTamic()
        return label
    }()
    private var satWritingLabel: UILabel = {
        let label = UILabel()
        label.activateTamic()
        return label
    }()
    private var satMathLabel: UILabel = {
        let label = UILabel()
        label.activateTamic()
        return label
    }()
    
    private var overviewParagraphLabel: UILabel = {
        let label = UILabel()
        label.activateTamic()
        label.numberOfLines = 0
        label.lineBreakMode  = .byWordWrapping
        return label
    }()
    
    private let geocoder = CLGeocoder()
    
    
    init(viewModel: SchoolDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        scrollView.contentSize = .init(width: view.bounds.width, height: view.bounds.height * 2)

        view.addSubview(scrollView)
        let contentView = UIView()
        contentView.activateTamic()
        contentView.addSubviews(mapView, nameLabel, satTakersLabel,overviewParagraphLabel)
        scrollView.addSubview(contentView)
        contentView.fillInParent()
        scrollView.fitInParentLayoutGuide()
    
        
        
        nameLabel.text = viewModel.name
        overviewParagraphLabel.text = viewModel.overview
  
        
        
        
        let satStackView = UIStackView(arrangedSubviews: [satWritingLabel,satMathLabel,satReadingLabel])
        satStackView.axis = .vertical
        satStackView.activateTamic()
        
        scrollView.addSubview(satStackView)
        
        NSLayoutConstraint.activate([
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: view.bounds.height + 10 ),
            
            mapView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            mapView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            mapView.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            mapView.heightAnchor.constraint(equalToConstant: 300),
            
            
            nameLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 30),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            satTakersLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            satTakersLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            
            satStackView.topAnchor.constraint(equalTo: satTakersLabel.bottomAnchor, constant: 10),
            satStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            satStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            overviewParagraphLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -10),
            overviewParagraphLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 10),
            overviewParagraphLabel.topAnchor.constraint(equalTo: satStackView.bottomAnchor,constant: 10),
            
            
            
            
        ])
        
        
        setupMapView()
        
        
        
    }
    
    
    func fetchSATData(dbn: String) async -> () {
        
    }
    
    
    func setupMapView() {
        geocoder.geocodeAddressString(viewModel.fullAddress) { [weak self](placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let `self` = self else {return}
            
            if let placemarks = placemarks, let placemark = placemarks.first {
                let annotation = MKPointAnnotation()
                annotation.title = self.viewModel.fullAddress
                annotation.subtitle = self.viewModel.name
                
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.name
        viewModel.delegate = self
        
        Task {
           await viewModel.getSATInfo()
        }
        // Do any additional setup after loading the view.
    }
    
    
}


extension SchoolDetailViewController: SchoolDetailViewModelDelegate {
    func didGetSATInfo() {
        satTakersLabel.text = viewModel.satTakersText
        satMathLabel.text = viewModel.mathScoreText
        satReadingLabel.text = viewModel.readingScoreText
        satWritingLabel.text = viewModel.writingScoreText
    }
    
    
}

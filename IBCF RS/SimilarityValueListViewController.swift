//
//  SimilarityValueListViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 25/04/23.
//

import UIKit

final class SimilarityValueListViewController: UIViewController {
    var similarityValues = [CourseSimilarity]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
}

extension SimilarityValueListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.similarityValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let similarity = similarityValues[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "similarityCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = "Item \(similarity.firstCourseId) and Item \(similarity.secondCourseId)"
        config.secondaryText = "\(similarity.value)"
        config.prefersSideBySideTextAndSecondaryText = true
        config.secondaryTextProperties.color = .secondaryLabel
        cell.contentConfiguration = config
        
        return cell
    }
}

private extension SimilarityValueListViewController {
    func makeUI() {
        view.addSubviews(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "similarityCell")
        getSimilarityValues()
    }
    
    func getSimilarityValues() {
        FBUtilities.shared.getRatings { [weak self] ratings, error in
            guard let self = self, let ratings = ratings else { return }
            let recommenderSystem = IBCFRecommenderSystem(ratings: ratings)
            recommenderSystem.getSimilarityValues { similarityValues in
                self.similarityValues = similarityValues
                self.tableView.reloadData()
            }
        }
    }
}

//
//  HomeViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 21/02/23.
//

import UIKit

final class HomeViewController: UITableViewController {
    
    private let strings = [
        [
            "Pilih sebuah action untuk melanjutkan."
        ],
        [
            "Mulai",
            "Kontribusi Data",
            "Under development"
        ]
    ]
    
    private let descriptionStrings = [
        "Berikan rating Anda untuk mata kuliah yang pernah Anda ambil dan dapatkan rekomendasi mata kuliah pilihan untuk diambil pada semester selanjutnya.",
        "Sistem rekomendasi ini butuh bantuan Anda untuk memberikan saran yang akurat bagi mahasiswa. Kontribusi Anda dalam memberikan rating pada seluruh mata kuliah yang Anda ambil selama studi akan digunakan dalam proses perhitungan rekomendasi.",
        "testing purposes only"
    ]
    
    private let images = [
        UIImage(named: "get_recommendation"),
        UIImage(named: "contribute"),
        UIImage(systemName: "lock.laptopcomputer")
    ]
    
    private let viewControllers = [
        CheckIDViewController(),
        CheckIDViewController(),
        RecommendationResultViewController()
//        SubmissionCompleteViewController()
//        SimilarityValueListViewController()
    ]
    
    override func viewDidLoad() {
        makeUI()
        FBUtilities.shared.getRatings { ratings, error in
            if let ratings = ratings {
                print("number of ratings are \(ratings.count)")
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return strings.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strings[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)
            var config = cell.defaultContentConfiguration()
            
            config.text = strings[section][row]
            cell.selectionStyle = .none
            cell.contentConfiguration = config
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(HomeOptionCell.self)", for: indexPath) as? HomeOptionCell else { return UITableViewCell() }
            let image = images[row]
            let title = strings[section][row]
            let description = descriptionStrings[row]
            cell.setContent(image: image, title: title, description: description)
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 1:
            navigationController?.pushViewController(viewControllers[row], animated: true)
            switch row {
            case 0: DefaultUtilities.shared.setCurrentSubmissionType(.getPrediction)
            case 1: DefaultUtilities.shared.setCurrentSubmissionType(.contribute)
                
            default: break
            }
            
        default:
            return
        }
    }
    
    
}

private extension HomeViewController {
    func makeUI() {
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "homeCell")
        tableView.register(HomeOptionCell.self, forCellReuseIdentifier: "\(HomeOptionCell.self)")
        tableView.separatorStyle = .none
    }
}

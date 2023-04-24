//
//  InterestSubmissionViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 19/03/23.
//

import UIKit

final class InterestSubmissionViewController: UITableViewController {
    private lazy var interestLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Pilih bidang minat Anda sebelum melanjutkan. Mohon diperhatikan bahwa opsi mata kuliah yang ditampilkan untuk diberi rating akan bergantung pada bidang minat yang Anda pilih."
        label.textAlignment = .justified
        label.setLineSpacing(to: 5)
        
        return label
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        button.isEnabled = false
        button.setTitle("Lanjutkan", for: .normal)
        
        return button
    }()
    
    private var chosenAreaOfInterest: FBCourse.AreaOfInterest?
    
    var accumulatedRatings: [FBRating]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
}

extension InterestSubmissionViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "interestCell", for: indexPath)
        cell.selectionStyle = .none
        
        let section = indexPath.section
        let row = indexPath.row
        var config = cell.defaultContentConfiguration()
        
        switch section {
        case 0:
            config.text = interestLabel.text
            
        case 1:
            switch row {
            case 0:  config.text = "Matematika Murni"
            case 1:  config.text = "Matematika Terapan"
            default: return UITableViewCell()
            }
            
        default: return UITableViewCell()
        }

        cell.contentConfiguration = config
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0:
            continueButton.isEnabled = false
            return
            
        case 1:
            cell.accessoryType = .checkmark
            continueButton.isEnabled = true
            switch row {
            case 0: chosenAreaOfInterest = .natural
            case 1: chosenAreaOfInterest = .applied
            default: return
        }
            
        default: return
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .none
    }
}

private extension InterestSubmissionViewController {
    func makeUI() {
        navigationItem.title = "Peminatan"
        navigationItem.largeTitleDisplayMode = .always
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "interestCell")
        
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(self.view.layoutMarginsGuide)
            make.height.equalTo(48)
        }
    }
    
    func prepareRecommender(ratings: [FBRating]?) {
        FBUtilities.shared.getRatings { [weak self] ratings, error in
            guard let self = self,
                  let ratings = ratings,
                  let accumulatedRatings = self.accumulatedRatings
            else {
                return
            }
            let user = DefaultUtilities.shared.getCurrentUser()
            let recommenderSystem = IBCFRecommenderSystem(ratings: ratings + accumulatedRatings)
            if let user = user {
                let coursesIds = FBCourse.allCourses().filter( {
                    ($0.areaOfInterest == nil || $0.areaOfInterest == self.chosenAreaOfInterest || $0.areaOfInterest == .both)
                    &&
                    ($0.newCurriculumSemesterAvailability ?? 0) > 4
                })
                    .map({ $0.id })
            }
        }
    }
    
    @objc func didTapContinueButton() {
        let viewController = RatingSubmissionViewController(currentSemester: 5)
        viewController.accumulatedRatings = accumulatedRatings
        viewController.areaOfInterest = chosenAreaOfInterest
        navigationController?.pushViewController(viewController, animated: true)
    }
}

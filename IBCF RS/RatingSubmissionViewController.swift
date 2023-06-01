//
//  RatingSubmissionViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 23/02/23.
//

import UIKit

final class RatingSubmissionViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInset.bottom = 72
        
        return tableView
    }()
    
    private lazy var continueBottomView: UIView = {
        let effect = UIBlurEffect(style: .prominent)
        let view = UIVisualEffectView()
        view.effect = effect
        
        view.contentView.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.width.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
        }
        
        return view
    }()
    
    private lazy var continueButton: DefaultButton = {
        let button = DefaultButton(title: "Selanjutnya", type: .filled, size: .regular)
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var randomRatingBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), primaryAction: randomAction())
        button.action = #selector(didTapRandomRatingButton)
        
        return button
    }()
    
    private var courses = [FBCourse]()
    private var ratingsGiven = [Int]()
    
    var currentSemester: Int?
    var areaOfInterest: FBCourse.AreaOfInterest?
    var accumulatedRatings: [FBRating]?
    
    init(currentSemester: Int) {
        super.init(nibName: nil, bundle: nil)
        self.currentSemester = currentSemester
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        continueBottomView.layer.shadowColor = UIColor.label.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        print("ratings: \(accumulatedRatings ?? [])")
    }
}

extension RatingSubmissionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return courses.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let row = indexPath.row
        
        switch row {
        default:
            let course = courses[row]
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(RatingSubmissionCell.self)",
                for: indexPath
            ) as? RatingSubmissionCell else { return UITableViewCell() }
            cell.setContent(course: course, ratingGiven: ratingsGiven[row] + 1)
            cell.indexPath = indexPath
            cell.delegate = self
            if currentSemester ?? 0 > 4 {
                let isPredictionShown = DefaultUtilities.shared.getIsPredictionValueShown()
                cell.toggleShowRatingPrediction(to: isPredictionShown)
            }
            
            return cell
        }
    }
}

extension RatingSubmissionViewController: RatingSubmissionCellDelegate {
    func didGiveRating(
        _ rating: Int,
        indexPath: IndexPath
    ) {
        let row = indexPath.row
        self.ratingsGiven[row] = rating
        
        if ratingsGiven.contains(-1) {
            continueButton.isEnabled = false
        } else {
            continueButton.isEnabled = true
        }
    }
}

private extension RatingSubmissionViewController {
    func makeUI() {
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.title = "Semester \(currentSemester ?? 0)"
        navigationItem.rightBarButtonItem = randomRatingBarButton
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(RatingSubmissionCell.self, forCellReuseIdentifier: "\(RatingSubmissionCell.self)")
        if let semester = currentSemester, semester < 8 {
            if let areaOfInterest = areaOfInterest {
                courses = FBCourse.allCourses().filter({
                    $0.newCurriculumSemesterAvailability == semester &&
                    ($0.areaOfInterest == areaOfInterest || $0.areaOfInterest == nil || $0.areaOfInterest == .both)
                })
            } else {
                courses = FBCourse.allCourses().filter({ $0.newCurriculumSemesterAvailability == semester })
            }
        }
        tableView.reloadData()
        
        for _ in 1...courses.count { ratingsGiven.append(-1) }
        
        view.addSubviews(tableView, continueBottomView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        continueBottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-64)
        }
        continueBottomView.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
    
    @objc func didTapContinueButton() {
        if let semester = currentSemester, semester != 4 {
            if semester == 7 {
                goToSubmissionCompletePage()
            } else {
                goToNextSemester()
            }
        } else if let semester = currentSemester,
                  semester == 4,
                  let submissionType = DefaultUtilities.shared.getCurrentSubmissionType()
        {
            switch submissionType {
            case DefaultUtilities.SubmissionType.getPrediction.rawValue: goToResultPage()
            case DefaultUtilities.SubmissionType.contribute.rawValue: goToInterestPage()
            default: return
            }
        }
    }
    
    func goToNextSemester() {
        if let semester = currentSemester {
            let nextSemester = semester + 1
            let viewController = RatingSubmissionViewController(currentSemester: nextSemester)
            if let areaOfInterest = areaOfInterest {
                viewController.areaOfInterest = areaOfInterest
            }
            let currentSemesterRatings = getCurrentSemesterRatings()
            if accumulatedRatings != nil {
                accumulatedRatings?.append(contentsOf: currentSemesterRatings)
            } else {
                accumulatedRatings = currentSemesterRatings
            }
            viewController.accumulatedRatings = accumulatedRatings
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func goToInterestPage() {
        let viewController = InterestSubmissionViewController(style: .insetGrouped)
        let currentSemesterRatings = getCurrentSemesterRatings()
        if accumulatedRatings != nil {
            accumulatedRatings?.append(contentsOf: currentSemesterRatings)
        } else {
            accumulatedRatings = currentSemesterRatings
        }
        viewController.accumulatedRatings = accumulatedRatings
        
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overCurrentContext
        navigationController?.present(loadingViewController, animated: false)
        FBUtilities.shared.getRatings { ratings, error in
            guard
                let ratings = ratings,
                let accumulatedRatings = self.accumulatedRatings,
                let user = DefaultUtilities.shared.getCurrentUser()
            else {
                self.navigationController?.dismiss(animated: false)
                return
            }
            
            let recommenderSystem = IBCFRecommenderSystem(ratings: ratings + accumulatedRatings)
            let courseIds = FBCourse.allCourses()
                .filter({ $0.newCurriculumSemesterAvailability ?? 0 > 4 && $0.areaOfInterest != nil })
                .map({ $0.id ?? "" })
            recommenderSystem.getRecommendations(userId: user.id ?? "", itemIds: courseIds) { recommendations in
                
            }
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goToResultPage() {
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overCurrentContext
        navigationController?.present(loadingViewController, animated: false)
        FBUtilities.shared.getRatings { ratings, error in
            guard
                let ratings = ratings,
                let accumulatedRatings = self.accumulatedRatings,
                let currentUser = DefaultUtilities.shared.getCurrentUser()
            else {
                self.navigationController?.dismiss(animated: false)
                return
            }
            
            print("accumulated ratings: \(accumulatedRatings)")
            let recommenderSystem = IBCFRecommenderSystem(ratings: ratings + accumulatedRatings)
            let courseIds = FBCourse.allCourses()
                .filter({ $0.newCurriculumSemesterAvailability ?? 0 > 4 && $0.areaOfInterest != nil })
                .map({ $0.id ?? "" })
            recommenderSystem.getRecommendations(userId: currentUser.id ?? "", itemIds: courseIds, numberOfK: 28) { recommendations in
                self.navigationController?.dismiss(animated: false, completion: {
                    let resultViewController = RecommendationResultViewController()
                    resultViewController.recommendedCourses = recommendations
                    resultViewController.shownRecommendedCourses = recommendations
                    self.navigationController?.pushViewController(resultViewController, animated: true)
                })
            }
        }
    }
    
    func goToSubmissionCompletePage() {
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overCurrentContext
        navigationController?.present(loadingViewController, animated: false)
        guard
            let user = DefaultUtilities.shared.getCurrentUser(),
            let accumulatedRatings = accumulatedRatings
        else { return }
        let newUser = FBUser(id: user.id, name: user.name, email: user.email, phoneNumber: user.phoneNumber, ratings: accumulatedRatings)
        FBUtilities.shared.createUser(user: newUser) { [weak self] error in
            guard let self = self, error == nil else {
                return
            }
            self.navigationController?.dismiss(animated: false, completion: {
                let submissionCompleteViewController = SubmissionCompleteViewController()
                self.navigationController?.pushViewController(submissionCompleteViewController, animated: true)
            })
        }
    }
    
    func randomAction() -> UIAction {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            for row in 0...self.ratingsGiven.count - 1 {
                let randomInt = Int.random(in: 1...6)
                self.ratingsGiven[row] = randomInt - 1
                self.continueButton.isEnabled = true
            }
        }
        
        return action
    }
    
    func getCurrentSemesterRatings() -> [FBRating] {
        var currentSemesterRatings = [FBRating]()
        let currentUser = DefaultUtilities.shared.getCurrentUser()
        for (index, rating) in ratingsGiven.enumerated() {
            if let currentUser = currentUser {
                let _rating = FBRating(
                    userId: currentUser.id,
                    itemId: "\(courses[index].id ?? "")",
                    value: Double(rating),
                    createdAt: Date()
                )
                currentSemesterRatings.append(_rating)
            }
        }
        return currentSemesterRatings
    }
    
    @objc func didTapRandomRatingButton(indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RatingSubmissionCell else { return }
        let row = indexPath.row
        cell.ratingChoicePickerView.selectRow(row, inComponent: 0, animated: true)
    }
}

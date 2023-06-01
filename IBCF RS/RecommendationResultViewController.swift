//
//  RecommendationResultViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 01/04/23.
//

import UIKit

final class RecommendationResultViewController: UIViewController {
    private lazy var filterBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"))
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.bottom = 64
        
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return tableView
    }()
    
    private lazy var dismissBottomView: UIView = {
        let effect = UIBlurEffect(style: .prominent)
        let view = UIVisualEffectView()
        view.effect = effect
        
        view.contentView.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.width.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
        }
        
        return view
    }()
    
    private lazy var dismissButton: DefaultButton = {
        let button = DefaultButton(title: "Kembali ke Home", type: .filled, size: .regular)
        button.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
        
        return button
    }()
    
    var recommendedCourses: [CourseRecommendation]?
    var shownRecommendedCourses: [CourseRecommendation]?
    private var naturalCoursesId = [String?]()
    private var appliedCoursesId = [String?]()
    private var filterOptions = ["Tampilkan Semua", "Tampilkan Hanya Mata Kuliah Peminatan Murni", "Tampilkan Hanya Mata Kuliah Peminatan Terapan"]
    private var filterChosen = "Tampilkan Semua"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        makeFilterButtonOptions()
    }
}

extension RecommendationResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownRecommendedCourses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(RecommendationResultHeaderCell.self)", for: indexPath) as? RecommendationResultHeaderCell else { return UITableViewCell() }
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(RecommendationResultCell.self)",
            for: indexPath
        ) as? RecommendationResultCell,
              let shownRecommendedCourses = shownRecommendedCourses
        else { return UITableViewCell() }
        let course = shownRecommendedCourses[row]
        cell.setContent(rank: row, courseId: "\(course.courseId)", predictionValue: course.predictionValue)
        
        return cell
    }
}

private extension RecommendationResultViewController {
    func makeUI() {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = filterBarButton
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Rekomendasi Mata Kuliah Pilihan"
        
        tableView.separatorStyle = .none
        tableView.register(RecommendationResultCell.self, forCellReuseIdentifier: "\(RecommendationResultCell.self)")
        tableView.register(RecommendationResultHeaderCell.self, forCellReuseIdentifier: "\(RecommendationResultHeaderCell.self)")
        
        view.addSubviews(tableView, dismissBottomView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dismissBottomView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(view.layoutMarginsGuide.snp.bottom).offset(-64)
        }
        recommendedCourses?.sort(by: { $0.predictionValue > $1.predictionValue })
        shownRecommendedCourses?.sort(by: { $0.predictionValue > $1.predictionValue })
    }
    
    func setupCourses() {
        naturalCoursesId = FBCourse.allCourses().filter({ $0.areaOfInterest == .natural || $0.areaOfInterest == .both }).map({ $0.id })
        appliedCoursesId = FBCourse.allCourses().filter({ $0.areaOfInterest == .applied || $0.areaOfInterest == .both }).map({ $0.id })
    }
    
    @objc func didTapDismissButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func makeFilterButtonOptions() {
        var children = [UIAction]()
        
        for option in filterOptions {
            let choiceMenu = UIAction(
                title: option,
                image: option == filterChosen ? UIImage(systemName: "checkmark") : nil
            ) { [weak self] _ in
                guard let self = self else { return }
                self.filterChosen = option
                switch option {
                case "Tampilkan Semua":
                    self.shownRecommendedCourses = self.recommendedCourses?.sorted(by: { $0.predictionValue > $1.predictionValue })
                    
                case "Tampilkan Hanya Mata Kuliah Peminatan Murni":
                    self.shownRecommendedCourses = self.recommendedCourses?.filter({ self.naturalCoursesId.contains($0.courseId) }).sorted(by: { $0.predictionValue > $1.predictionValue })
                    
                case "Tampilkan Hanya Mata Kuliah Peminatan Terapan":
                    self.shownRecommendedCourses = self.recommendedCourses?.filter({ self.appliedCoursesId.contains($0.courseId) }).sorted(by: { $0.predictionValue > $1.predictionValue })
                    
                default: break
                }
                self.tableView.reloadData()
//                self.main
            }
            choiceMenu.image = option == filterChosen ? UIImage(systemName: "checkmark") : nil
            children.append(choiceMenu)
        }
        let menu = UIMenu(options: .displayInline, children: children)
        filterBarButton.menu = menu
    }
}

//
//  RecommendationResultViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 01/04/23.
//

import UIKit

final class RecommendationResultViewController: UIViewController {
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
    var values: [Double] = [1, 0.5, 0.3, 0.2, 0.01]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
}

extension RecommendationResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedCourses?.count ?? 0
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
              let recommendedCourses = recommendedCourses
        else { return UITableViewCell() }
        let course = recommendedCourses[row]
        cell.setContent(rank: row, courseId: "\(course.courseId)", predictionValue: course.predictionValue)
        
        return cell
    }
}

private extension RecommendationResultViewController {
    func makeUI() {
        navigationItem.hidesBackButton = true
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
    }
    
    @objc func didTapDismissButton() {
        navigationController?.popToRootViewController(animated: true)
    }
}

//
//  RecommendationResultCell.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 01/04/23.
//

import UIKit

final class RecommendationResultCell: UITableViewCell {
    private lazy var mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 32
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.75
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 7
        
        view.addSubviews(rankCircleView, rankLabel, mainStackView)
        rankCircleView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.height.equalTo(64)
        }
        
        rankLabel.snp.makeConstraints { make in
            make.center.equalTo(rankCircleView)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.leading.equalTo(rankCircleView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        return view
    }()
    
    private lazy var rankCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        view.clipsToBounds = true
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 32
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.75
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 7
        
        return view
    }()
    
    private lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.addArrangedSubviews(courseLabel, predictionValueLabel)
        
        return stackView
    }()
    
    private lazy var courseLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var predictionValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    private var rank: Int?
    private var rankString: String?
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if let rankString = rankString, let rank = Int(rankString), rank > 3 {
            mainContainerView.layer.shadowColor = UIColor.label.cgColor
            rankCircleView.layer.shadowColor = UIColor.label.cgColor
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    override func prepareForReuse() {
        setColorAndShadow()
    }
}

private extension RecommendationResultCell {
    func makeUI() {
        selectionStyle = .none
        contentView.addSubview(mainContainerView)
        mainContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView.layoutMarginsGuide)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func setColorAndShadow() {
        switch rank ?? 0 {
        case 1:
            mainContainerView.layer.shadowColor = UIColor.systemIndigo.cgColor
            rankCircleView.layer.shadowColor = UIColor.systemIndigo.cgColor
            rankCircleView.backgroundColor = .systemIndigo
            
        case 2:
            mainContainerView.layer.shadowColor = UIColor.systemPurple.cgColor
            rankCircleView.layer.shadowColor = UIColor.systemPurple.cgColor
            rankCircleView.backgroundColor = .systemPurple
            
        case 3:
            mainContainerView.layer.shadowColor = UIColor.systemTeal.cgColor
            rankCircleView.layer.shadowColor = UIColor.systemTeal.cgColor
            rankCircleView.backgroundColor = .systemTeal
            
        default:
            mainContainerView.layer.shadowColor = UIColor.label.cgColor
            rankCircleView.layer.shadowColor = UIColor.label.cgColor
            rankLabel.textColor = .systemBackground
        }
        
        if rank ?? 0 > 3 {
            mainContainerView.layer.shadowOpacity = 0.25
            rankCircleView.layer.shadowOpacity = 0.25
        } else {
            mainContainerView.layer.shadowOpacity = 0.75
            rankCircleView.layer.shadowOpacity = 0.75
        }
    }
}

extension RecommendationResultCell {
    func setContent(
        rank: Int,
        courseId: String,
        predictionValue: Double
    ) {
        if let course = FBCourse.allCourses().first(where: { $0.id == courseId }) {
            self.rank = rank
            rankString = "\(rank)"
            rankLabel.text = rankString
            courseLabel.text = course.name
            predictionValueLabel.text = "\(predictionValue)"
            
            setColorAndShadow()
        }
    }
}

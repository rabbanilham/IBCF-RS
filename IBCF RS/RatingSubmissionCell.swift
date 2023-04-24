//
//  RatingSubmissionCell.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 23/02/23.
//

import UIKit

protocol RatingSubmissionCellDelegate: AnyObject {
    func didGiveRating(_ rating: Int, indexPath: IndexPath)
}

final class RatingSubmissionCell: UITableViewCell {
    private lazy var frameView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.masksToBounds = false
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 7
        
        view.addSubviews(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(24)
            make.trailing.bottom.equalToSuperview().offset(-24)
        }
        
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        
        stackView.addArrangedSubviews(courseLabel, questionLabel, ratingPredictionLabel, ratingChoicePickerView)
        
        ratingChoicePickerView.snp.makeConstraints { make in
            make.height.equalTo(128)
        }
        
        return stackView
    }()
    
    private lazy var courseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Berapa rating yang Anda berikan untuk mata kuliah "
        
        return label
    }()
    
    private lazy var ratingPredictionLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Nilai prediksi rating: "
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    lazy var ratingChoicePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.addSubview(pickerBackgroundView)
        pickerView.sendSubviewToBack(pickerBackgroundView)
        pickerBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().inset(12)
        }
        
        return pickerView
    }()
    
    private lazy var pickerBackgroundView: UIView = {
        let view = UIView()
        view.alpha = 0.25
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    private let choices = RatingChoice.allChoices()

    var indexPath: IndexPath?
    weak var delegate: RatingSubmissionCellDelegate?
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        frameView.layer.shadowColor = UIColor.label.cgColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RatingSubmissionCell {
    func makeUI() {
        selectionStyle = .none
        ratingChoicePickerView.delegate = self
        ratingChoicePickerView.dataSource = self
        
        contentView.addSubview(frameView)
        frameView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.layoutMarginsGuide.snp.edges)
        }
    }
}

extension RatingSubmissionCell {
    func setContent(course: Course, ratingGiven: Int) {
        let courseName = course.name
        courseLabel.text = courseName
        if let text = questionLabel.text, !text.hasSuffix("?") {
            questionLabel.text = text + courseName + "?"
        }
        ratingChoicePickerView.selectRow(ratingGiven, inComponent: 0, animated: false)
    }
    
    func setContent(course: FBCourse, ratingGiven: Int) {
        let courseName = course.name
        courseLabel.text = courseName
        if let text = questionLabel.text,
           !text.hasSuffix("?"),
           let courseName = courseName
        {
            questionLabel.text = text + courseName + "?"
        }
        ratingChoicePickerView.selectRow(ratingGiven, inComponent: 0, animated: false)
    }
    
    func setPredictionValue(_ value: String) {
        if ratingPredictionLabel.text != nil {
            ratingPredictionLabel.text?.append(value)
        }
    }
    
    func toggleShowRatingPrediction(to isShown: Bool) {
        ratingPredictionLabel.isHidden = !isShown
        layoutSubviews()
    }
}

extension RatingSubmissionCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let indexPath = self.indexPath else { return }
        if let rating = Int(choices[row].value) {
            print(rating)
            delegate?.didGiveRating(rating, indexPath: indexPath)
        } else {
            delegate?.didGiveRating(-1, indexPath: indexPath)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let choice = choices[row]
        let view = UIView()
        view.backgroundColor = choices[row].color
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        
        let label = UILabel()
        label.text = choice.emoji + " " + choice.value
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return view
    }
}


struct RatingChoice {
    let emoji: String
    let value: String
    let color: UIColor
    
    static func allChoices() -> [RatingChoice] {
        let choices = [
            RatingChoice(emoji: "", value: "Slide untuk memilih nilai", color: .secondarySystemBackground),
            RatingChoice(emoji: "🙏🏼", value: "0", color: .clear),
            RatingChoice(emoji: "😞", value: "1", color: .systemRed),
            RatingChoice(emoji: "🙁", value: "2", color: .systemOrange),
            RatingChoice(emoji: "😐", value: "3", color: .systemYellow),
            RatingChoice(emoji: "🙂", value: "4", color: .systemGreen),
            RatingChoice(emoji: "🥰", value: "5", color: .systemBlue)
        ]
        
        return choices
    }
}

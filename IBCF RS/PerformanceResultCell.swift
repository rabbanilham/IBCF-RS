//
//  PerformanceResultCell.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 28/04/23.
//

import UIKit

final class PerformanceResultCell: UITableViewCell {
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.masksToBounds = false
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 7
        
        view.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.trailing.bottom.equalToSuperview().offset(-16)
        }
        
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8

        stackView.addArrangedSubviews(errorLabel, descriptionLabel, mainTableView)

        mainTableView.snp.makeConstraints { make in
            make.height.equalTo(116.666)
        }

        return stackView
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .light)
        label.numberOfLines = 1
        label.text = "0"
        label.textAlignment = .left

        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left

        return label
    }()

    private lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(ErrorDetailCell.self, forCellReuseIdentifier: "\(ErrorDetailCell.self)")

        return tableView
    }()

    var courseName: String?
    var performanceResult: CoursePredictionError?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
}

extension PerformanceResultCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(ErrorDetailCell.self)",
            for: indexPath
        ) as? ErrorDetailCell
        else { return UITableViewCell() }
        let row = indexPath.row
        switch row {
        case 0:
            cell.setContent(description: "Prediksi rating oleh sistem", value: "\(performanceResult?.predictionValue ?? 0)")

        case 1:
            cell.setContent(description: "Rating sebenarnya dari mahasiswa", value: "\(performanceResult?.actualValue ?? 0)")

        default: break
        }

        return cell
    }
}

extension PerformanceResultCell {
    func setErrorData(
        _ error: CoursePredictionError,
        courseName: String?
    ) {
        performanceResult = error
        errorLabel.text = "\(error.error)"
        descriptionLabel.text = "Sistem merekomendasikan mata kuliah \(courseName ?? "") kepada mahasiswa \(error.userId)"
        mainTableView.reloadData()
    }
}

private extension PerformanceResultCell {
    func makeUI() {
        selectionStyle = .none
        contentView.addSubview(wrapperView)
        wrapperView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView.layoutMarginsGuide)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }

        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
}

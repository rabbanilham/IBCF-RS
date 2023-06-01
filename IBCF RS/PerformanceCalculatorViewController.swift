//
//  PerformanceCalculatorViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 27/04/23.
//

import UIKit

final class PerformanceCalculatorViewController: UIViewController {
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        
        scrollView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return scrollView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        stackView.addArrangedSubviews(
            calculatorModeButton,
            numberOfInputPickerView,
            userIdInputTableView,
            performanceResultWrapperView,
            calculateButton
        )
        
        userIdInputTableView.snp.makeConstraints { make in
            make.height.equalTo(134.3)
            make.width.equalToSuperview()
        }
        
        return stackView
    }()
    
    private lazy var calculatorModeButton: DefaultButton = {
        let button = DefaultButton(
            title: "Pilih opsi rating",
            type: .bordered,
            size: .regular
        )
        button.showsMenuAsPrimaryAction = true
        
        return button
    }()
    
    private lazy var numberOfInputPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.alpha = 0
        pickerView.isHidden = true
        
        return pickerView
    }()
    
    private lazy var userIdInputTableView: UITableView = {
        let tableView = UITableView()
        tableView.alpha = 0
        tableView.isHidden = true
        tableView.isScrollEnabled = false
        tableView.register(UserIdInputCell.self, forCellReuseIdentifier: "\(UserIdInputCell.self)")
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private lazy var performanceResultWrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.masksToBounds = false
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 7
        
        view.isHidden = true
        view.alpha = 0
        
        view.addSubview(performanceResultStackView)
        performanceResultStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.trailing.bottom.equalToSuperview().offset(-16)
        }
        
        return view
    }()
    
    private lazy var performanceResultStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        
        stackView.alpha = 0
        stackView.isHidden = true
        
        let maeView = createPerformanceResultValueView(
            valueName: "Mean Absolute Error",
            valueNameBackgroundColor: .systemIndigo,
            valueLabel: maeValueLabel
        )
        
        let rmseView = createPerformanceResultValueView(
            valueName: "Root Mean Square Error",
            valueNameBackgroundColor: .systemPurple,
            valueLabel: rmseValueLabel
        )
        
        let stdDevView = createPerformanceResultValueView(
            valueName: "Standard Deviation",
            valueNameBackgroundColor: .systemMint,
            valueLabel: stdDevValueLabel
        )
        
        stackView.addArrangedSubviews(maeView, rmseView, stdDevView, performanceDetailButton)
        
        return stackView
    }()
    
    private lazy var maeValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.text = "0"
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var rmseValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.text = "0"
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var stdDevValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.text = "0"
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var performanceDetailButton: DefaultButton = {
        let button = DefaultButton(
            title: "Lihat Detail",
            type: .ghost,
            size: .regular
        )
        
        return button
    }()
    
    private lazy var calculateButton: DefaultButton = {
        let button = DefaultButton(
            title: "Hitung",
            type: .filled,
            size: .regular
        )
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var kChoiceBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Pilih K"
        button.target = self
        
        return button
    }()
    
    private let recommenderSystem = IBCFRecommenderSystem(ratings: [])
    private var allUserIds = [String?]()
    private var allCourse = FBCourse.allCourses()
    private var numberOfInput = 0
    private var testingUserIds = [String]()
    private var performanceResult = FBPerformance(meanAbsoluteError: 0, rootMeanSquareError: 0, errors: [], trainingDataRatings: [], testingDataRatings: [], testingDataUserIds: [], standardDeviation: 0)
    private let ratingInputChoices = [
        "Dengan data random",
        "Dengan data pilihan"
    ]
    private var numberOfK = 0
    private let kInputChoices = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 100]
    private var isUsingRandomUserId = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        getAllUserFromDatabase()
    }
}

private extension PerformanceCalculatorViewController {
    func makeUI() {
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Performance Calculator"
        navigationItem.rightBarButtonItem = kChoiceBarButton
        
        numberOfInputPickerView.delegate = self
        numberOfInputPickerView.dataSource = self
        userIdInputTableView.delegate = self
        userIdInputTableView.dataSource = self
        
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        numberOfInputPickerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(96)
        }
        
        performanceResultWrapperView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        
        calculateButton.addTarget(self, action: #selector(didTapCalculateButton), for: .touchUpInside)
        performanceDetailButton.addTarget(self, action: #selector(didTapSeeDetailButton), for: .touchUpInside)
        makeChoiceButtonOptions()
        makeKChoiceButtonOptions()
    }
    
    func makeChoiceButtonOptions() {
        var children = [UIAction]()
        
        for choice in ratingInputChoices {
            let choiceMenu = UIAction(title: choice) { [weak self] _ in
                guard let self = self else { return }
                self.calculatorModeButton.setTitle(choice, for: .normal)
                self.numberOfInputPickerView.selectRow(0, inComponent: 0, animated: true)
                self.numberOfInputPickerView.isHidden = false
                self.numberOfInputPickerView.fadeIn()
                self.userIdInputTableView.fadeOut()
                self.performanceResultWrapperView.fadeOut()
                self.userIdInputTableView.isHidden = true
                self.performanceResultWrapperView.isHidden = true
                
                switch choice {
                case "Dengan data random": self.isUsingRandomUserId = true
                    
                case "Dengan data pilihan": self.isUsingRandomUserId = false
                    
                default: break
                }
            }
            children.append(choiceMenu)
        }
        
        let menu = UIMenu(options: .displayInline, children: children)
        calculatorModeButton.menu = menu
    }
    
    func makeKChoiceButtonOptions() {
        var children = [UIAction]()
        
        for choice in kInputChoices {
            let choiceMenu = UIAction(title: choice == 0 ? "Pilih Nilai K" : "K = \(choice)") { [weak self] _ in
                guard let self = self else { return }
                self.numberOfK = choice
                self.kChoiceBarButton.title = choice == 0 ? "Pilih Nilai K" : "K = \(choice)"
            }
            children.append(choiceMenu)
        }
        
        let menu = UIMenu(options: .displayInline, children: children)
        kChoiceBarButton.menu = menu
    }
    
    func createPerformanceResultValueView(
        valueName: String,
        valueNameBackgroundColor: UIColor,
        valueLabel: UILabel
    ) -> UIView {
        let valueNameLabel = UILabel()
        valueNameLabel.font = .systemFont(ofSize: 12, weight: .bold)
        valueNameLabel.text = valueName.uppercased()
        valueNameLabel.textColor = .systemBackground
        valueNameLabel.numberOfLines = 0
        
        let valueLabelBackgroundView = UIView()
        valueLabelBackgroundView.backgroundColor = valueNameBackgroundColor
        valueLabelBackgroundView.clipsToBounds = true
        valueLabelBackgroundView.layer.cornerRadius = 8
        valueLabelBackgroundView.layer.cornerCurve = .continuous
        
        valueLabelBackgroundView.addSubview(valueNameLabel)
        valueNameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
            make.trailing.bottom.equalToSuperview().offset(-8)
        }
        
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubviews(valueLabelBackgroundView, valueLabel)
        valueLabelBackgroundView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        return view
    }
    
    func getAllUserFromDatabase() {
        FBUtilities.shared.getUsers { [weak self] users, error in
            guard let self = self, let users = users else { return }
            self.allUserIds = users.map({ $0.id })
        }
    }
}

extension PerformanceCalculatorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfInput
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(UserIdInputCell.self)",
            for: indexPath
        ) as? UserIdInputCell
        else { return UITableViewCell() }
        cell.delegate = self
        cell.row = row
        cell.allUserIds = allUserIds
        
        return cell
    }
}

extension PerformanceCalculatorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 11
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let label = UILabel()
        view.addSubview(label)
        if row == 0 {
            label.text = "Pilih banyaknya mahasiswa"
        } else {
            label.text = "\(row)"
        }
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row > 0 else {
            userIdInputTableView.fadeOut { [weak self] isComplete in
                guard let self = self else { return }
                if isComplete { self.userIdInputTableView.isHidden = true }
            }
            return
        }
        
        if !isUsingRandomUserId {
            userIdInputTableView.isHidden = false
            userIdInputTableView.fadeIn()
            userIdInputTableView.snp.removeConstraints()
            userIdInputTableView.snp.makeConstraints { make in
                make.height.equalTo(134.3 * Double(row))
                make.width.equalToSuperview()
            }
        } else {
            calculateButton.isEnabled = true
        }
        
        numberOfInput = row
        testingUserIds = []
        for _ in 1...row {
            self.testingUserIds.append("empty")
        }
        userIdInputTableView.reloadData()
        view.updateConstraints()
    }
}

extension PerformanceCalculatorViewController: UserIdInputCellDelegate {
    func didFinishBuildUserId(_ id: String, row: Int) {
        self.testingUserIds[row] = id
        calculateButton.isEnabled = !self.testingUserIds.contains("empty")
        print(testingUserIds)
    }
}

private extension PerformanceCalculatorViewController {
    func setupPerformanceResultView(_ result: FBPerformance) {
        performanceResult = result
        let roundedMae = round(result.meanAbsoluteError * 1000) / 1000.0
        let roundedRmse = round(result.rootMeanSquareError * 1000) / 1000.0
        let roundedStdDev = round(result.standardDeviation * 1000) / 1000.0
        maeValueLabel.text = "\(roundedMae)"
        rmseValueLabel.text = "\(roundedRmse)"
        stdDevValueLabel.text = "\(roundedStdDev)"
        performanceResultWrapperView.isHidden = false
        performanceResultWrapperView.fadeIn { [weak self] isComplete in
            guard let self = self else { return }
            if isComplete {
                self.performanceResultWrapperView.updateConstraints()
                self.performanceResultStackView.isHidden = false
                self.performanceResultStackView.fadeIn()
                self.view.updateConstraints()
            }
        }
    }
    
    func presentKNotChosen() {
        let action = UIAlertAction(title: "Oke", style: .default)
        let alert = UIAlertController(title: "Belum Memilih Nilai K", message: "Pilih nilai K sebelum melanjutkan.", preferredStyle: .alert)
        alert.addAction(action)
        navigationController?.present(alert, animated: true)
    }
    
    @objc func didTapCalculateButton() {
        guard let choice = calculatorModeButton.titleLabel?.text else { return }
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overCurrentContext
        navigationController?.present(loadingViewController, animated: false)
        
        FBUtilities.shared.getRatings { [weak self] ratings, error in
            guard let self = self, let ratings = ratings else { return }
            self.recommenderSystem.ratings = ratings
            
            switch choice {
            case "Dengan data random":
                if self.numberOfK == 0 {
                    self.presentKNotChosen()
                } else if self.numberOfK != 100 {
                    self.recommenderSystem.calculateRecommenderPerformance(
                        numberOfTestingData: self.numberOfInput,
                        numberOfK: self.numberOfK
                    ) { result in
                        self.setupPerformanceResultView(result)
                        self.navigationController?.dismiss(animated: false)
                    }
                } else {
//                    self.recommenderSystem.kfcvCalculateRecommenderPerformance(numberOfK: 27) { result in
//                        self.setupPerformanceResultView(result)
//                        self.navigationController?.dismiss(animated: false)
//                    }
                    
                    let kValues = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
                    let group = DispatchGroup()
                    let queue = DispatchQueue.global()

                    // Task 1
                    for (index, kValue) in kValues.enumerated() {
                        group.enter()
                        queue.async {
                            // Task 1 implementation
                            print("Task \(index + 1) started")
                            self.recommenderSystem.kfcvCalculateRecommenderPerformance(numberOfK: kValue) { result in
    //                            self.setupPerformanceResultView(result)
                                print("result for k = \(kValue) is \(result)")
                            }
                            print("Task \(index + 1) completed")
                            group.leave()
                        }
                    }
                    group.wait() // Wait for all tasks to complete
                    print("All tasks completed")
                }
                
            case "Dengan data pilihan":
                if self.numberOfK == 0 {
                    self.presentKNotChosen()
                    self.recommenderSystem.calculateRecommenderPerformance(
                        testingDataUserIds: self.testingUserIds
                    ) { result in
                        self.setupPerformanceResultView(result)
                        self.navigationController?.dismiss(animated: false)
                    }
                } else {
//                    self.recommenderSystem.calculateRecommenderPerformance(
//                        testingDataUserIds: self.testingUserIds,
//                        numberOfK: self.numberOfK
//                    ) { result in
//                        self.setupPerformanceResultView(result)
//                        self.navigationController?.dismiss(animated: false)
//                    }
                    
                    self.recommenderSystem.kfcvCalculateRecommenderPerformance(
                        testingDataUserIds: self.testingUserIds,
                        numberOfK: self.numberOfK
                    ) { result in
                        self.setupPerformanceResultView(result)
                        self.navigationController?.dismiss(animated: false)
                    }
                }
                
            default: break
            }
        }
    }
    
    @objc func didTapSeeDetailButton() {
        let viewController = PerformanceDetailViewController()
        viewController.performance = performanceResult
        navigationController?.pushViewController(viewController, animated: true)
    }
}

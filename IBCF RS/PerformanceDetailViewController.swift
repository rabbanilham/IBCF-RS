//
//  PerformanceDetailViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 28/04/23.
//

import UIKit

final class PerformanceDetailViewController: UITableViewController {
    private lazy var sortBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"))
        
        return button
    }()
    private let sortDataChoices = [
        "Error terkecil",
        "Error terbesar",
        "Absolute Error terkecil",
        "Absolute Error terbesar",
        "NPM terkecil",
        "NPM terbesar",
        "ID mata kuliah terkecil",
        "ID mata kuliah terbesar"
    ]
    
    let allCourses = FBCourse.allCourses()
    var performance: FBPerformance?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        makeSortButtonOptions()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (performance?.errors.count ?? 0) + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "performanceHeaderCell", for: indexPath)
            var config = cell.defaultContentConfiguration()
            let string = NSMutableAttributedString(
                string: "MEAN ABSOLUTE ERROR: \(performance?.meanAbsoluteError ?? 0) \nROOT MEAN SQUARE ERROR: \(performance?.rootMeanSquareError ?? 0) \nDATA COUNT: \(performance?.errors.count ?? 0)",
                attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.secondaryLabel]
            )
            config.attributedText = string
            cell.contentConfiguration = config
            
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(PerformanceResultCell.self)",
                for: indexPath
            ) as? PerformanceResultCell
            else { return UITableViewCell() }
            let row = indexPath.row
            if let error = performance?.errors[row],
               let courseName = allCourses.first(where: { $0.id == error.courseId })?.name {
                cell.setErrorData(error, courseName: courseName)
            }
            
            return cell
        }
    }
}

extension PerformanceDetailViewController {
    func makeUI() {
        tableView.separatorStyle = .none
        navigationItem.title = "Performance Detail"
        navigationItem.rightBarButtonItem = sortBarButton
        
        tableView.register(PerformanceResultCell.self, forCellReuseIdentifier: "\(PerformanceResultCell.self)")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "performanceHeaderCell")
    }
    
    func makeSortButtonOptions() {
        var children = [UIAction]()
        
        for choice in sortDataChoices {
            let choiceMenu = UIAction(title: choice) { [weak self] _ in
                guard let self = self else { return }
                switch choice {
                case  "Error terkecil": self.performance?.errors.sort(by: { $0.error < $1.error })
                case "Error terbesar": self.performance?.errors.sort(by: { $0.error > $1.error })
                case "Absolute Error terkecil": self.performance?.errors.sort(by: { abs($0.error) < abs($1.error) })
                case "Absolute Error terbesar": self.performance?.errors.sort(by: { abs($0.error) > abs($1.error) })
                case "NPM terkecil": self.performance?.errors.sort(by: { $0.userId < $1.userId })
                case "NPM terbesar": self.performance?.errors.sort(by: { $0.userId > $1.userId })
                case "ID mata kuliah terkecil": self.performance?.errors.sort(by: { $0.courseId < $1.courseId })
                case "ID mata kuliah terbesar": self.performance?.errors.sort(by: { $0.courseId > $1.courseId })
                default: break
                }
                self.tableView.reloadData()
            }
            children.append(choiceMenu)
        }
        
        let menu = UIMenu(title: "Urutkan data berdasarkan", options: .displayInline, children: children)
        sortBarButton.menu = menu
    }
}

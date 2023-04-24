//
//  ViewController.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 05/02/23.
//

import UIKit

final class TestingViewController: UITableViewController {
    
    var csvEntries = [[String]]()
    let ratings = [
        Rating(userId: 1, itemId: 3, value: 4.0, createdAt: nil),
        Rating(userId: 1, itemId: 4, value: 5.0, createdAt: nil),
        Rating(userId: 1, itemId: 5, value: 5.0, createdAt: nil),
        Rating(userId: 2, itemId: 1, value: 4.0, createdAt: nil),
        Rating(userId: 2, itemId: 2, value: 5.0, createdAt: nil),
        Rating(userId: 2, itemId: 5, value: 3.0, createdAt: nil),
        Rating(userId: 3, itemId: 1, value: 5.0, createdAt: nil),
        Rating(userId: 3, itemId: 3, value: 4.0, createdAt: nil),
        Rating(userId: 3, itemId: 4, value: 1.0, createdAt: nil),
        Rating(userId: 4, itemId: 1, value: 5.0, createdAt: nil),
        Rating(userId: 4, itemId: 2, value: 4.0, createdAt: nil),
        Rating(userId: 4, itemId: 4, value: 1.0, createdAt: nil),
        Rating(userId: 5, itemId: 2, value: 4.0, createdAt: nil),
        Rating(userId: 5, itemId: 6, value: 5.0, createdAt: nil)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Import CSV"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        csvEntries = importCsv()
        
        let recommenderSystem = ExampleRecommenderSystem(ratings: self.ratings)
        let recommendation = recommenderSystem.recommend(userId: 3)
        print("Recommendations for user 3: \(recommendation)")
        print(recommenderSystem.ratingAverage(by: .user))
        print(recommenderSystem.ratingAverage(by: .item))
        
        for item in 1...6 {
            recommenderSystem.weightedSum(userId: 1, itemId: item, isAdjusted: false)
            recommenderSystem.weightedSum(userId: 2, itemId: item, isAdjusted: false)
            recommenderSystem.weightedSum(userId: 3, itemId: item, isAdjusted: false)
            recommenderSystem.weightedSum(userId: 4, itemId: item, isAdjusted: false)
            recommenderSystem.weightedSum(userId: 5, itemId: item, isAdjusted: false)
        }
        
        for item in 1...6 {
            recommenderSystem.weightedSum(userId: 1, itemId: item, isAdjusted: true)
            recommenderSystem.weightedSum(userId: 2, itemId: item, isAdjusted: true)
            recommenderSystem.weightedSum(userId: 3, itemId: item, isAdjusted: true)
            recommenderSystem.weightedSum(userId: 4, itemId: item, isAdjusted: true)
            recommenderSystem.weightedSum(userId: 5, itemId: item, isAdjusted: true)
        }
        
        print("Overall sparsity measure value is: \(recommenderSystem.overallSparsityMeasure(ratings: ratings))")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return csvEntries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = "\((csvEntries[row])[0]) \((csvEntries[row])[1])"
        config.secondaryText = "\((csvEntries[row])[2]), \((csvEntries[row])[3]), \((csvEntries[row])[4])"
        cell.contentConfiguration = config
        
        return cell
    }


}

private extension TestingViewController {
    func importCsv() -> [[String]] {
        let filePath = Bundle.main.path(forResource: "addresses", ofType: "csv")!
        guard let fileContent = try? String(contentsOfFile: filePath, encoding: .utf8) else { return [] }
        let rows = fileContent.components(separatedBy: "\n")
        
        var items: [[String]] = []
        
        for row in rows {
            let columns = row.components(separatedBy: ",")
            if columns.count == 6 {
                items.append(columns)
            }
        }
        tableView.reloadData()
        return items
    }
}

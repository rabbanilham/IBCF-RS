//
//  IBCFRecommenderSystem.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 14/02/23.
//

import Foundation

final class IBCFRecommenderSystem {
    var ratings: [FBRating]
    enum AverageRatingType {
        case user
        case item
    }
    
    init(ratings: [FBRating]) {
        self.ratings = ratings
    }
}

extension IBCFRecommenderSystem {
    func cosineSimilarity(
        item1: String?,
        item2: String?,
        isAdjusted: Bool
    ) -> Double {
        let adjustedPrefix = isAdjusted ? "Adjusted " : ""
        let ratingAverage = ratingAverage(by: .user)
        let item1Ratings = self.ratings.filter({ $0.itemId ?? "0" == item1 })
        let item2Ratings = self.ratings.filter({ $0.itemId ?? "0" == item2 })
        var numerator = 0.0 // pembilang
        var item1Denominator = 0.0 // penyebut (kiri)
        var item2Denominator = 0.0 // penyebut (kanan)
        
        for rating1 in item1Ratings {
            for rating2 in item2Ratings {
                if rating1.userId == rating2.userId {
                    let averageRatingUser1 = isAdjusted ? ratingAverage[rating1.userId ?? "0"] ?? 0.0 : 0.0
                    let averageRatingUser2 = isAdjusted ? ratingAverage[rating2.userId ?? "0"] ?? 0.0 : 0.0
                    let ratingValue1 = (rating1.value ?? 0) - averageRatingUser1
                    let ratingValue2 = (rating2.value ?? 0) - averageRatingUser2
                    numerator += ratingValue1 * ratingValue2
                    item1Denominator += pow(ratingValue1, 2)
                    item2Denominator += pow(ratingValue2, 2)
                }
            }
        }
        
        if item1Denominator == 0.0 || item2Denominator == 0.0 {
            print("the \(adjustedPrefix)Cosine similarity value between item \(String(describing: item1)) and item \(String(describing: item2)) is 0.0")
            return 0.0
        }
        let similarityValue = numerator / (sqrt(item1Denominator) * sqrt(item2Denominator))
        
        print("the \(adjustedPrefix)Cosine similarity value between item \(String(describing: item1)) and item \(String(describing: item2)) is \(similarityValue)")
        return similarityValue
    }
    
    func weightedSum(
        userId: String?,
        itemId: String?,
        isAdjusted: Bool
    ) -> Double {
        let adjustedPrefix = isAdjusted ? "Adjusted " : ""
        let ratingAverage = ratingAverage(by: .item)
        var sum = 0.0
        var similaritySum = 0.0
        var averageUnratedItem = 0.0

        for rating in ratings {
            if rating.userId == userId && rating.itemId != itemId {
                let averageRatingItem = isAdjusted ? (ratingAverage[rating.itemId ?? ""] ?? 0.0) : 0.0
                averageUnratedItem = isAdjusted ? (ratingAverage[itemId ?? ""] ?? 0.0) : 0.0
                let ratingValue = (rating.value ?? 0) - averageRatingItem
                let similarity = cosineSimilarity(item1: itemId, item2: rating.itemId, isAdjusted: isAdjusted)
                sum += similarity * ratingValue
                similaritySum += abs(similarity)
            } else if rating.userId == userId && rating.itemId == itemId {
                print("c1 \(adjustedPrefix)Weighted sum for user \(String(describing: userId)) and item \(String(describing: itemId)) is \(rating.value ?? 0.0)")
                
                return rating.value ?? 0
            }
        }
        
        if similaritySum == 0.0 {
            print("c2 \(adjustedPrefix)Weighted sum for user \(String(describing: userId)) and item \(String(describing: itemId)) is 0.0")
            
            return 0.0
        }
        
        var weightedSum = averageUnratedItem + (sum / similaritySum)
        if weightedSum > 5.0 {
            weightedSum = 5.0
        }
        print("c3 \(adjustedPrefix)Weighted sum for user \(String(describing: userId)) and item \(String(describing: itemId)) is \(weightedSum)")
        
        return weightedSum
    }
    
    func getRecommendations(
        userId: String,
        itemIds: [String],
        _ completion: ([CourseRecommendation]) -> Void
    ) {
        var recommendedCourses = [CourseRecommendation]()
        for itemId in itemIds {
            let recommendedCourseValue = weightedSum(userId: userId, itemId: itemId, isAdjusted: true)
            let recommendedCourse = CourseRecommendation(courseId: itemId, predictionValue: recommendedCourseValue)
            recommendedCourses.append(recommendedCourse)
        }
        
        completion(recommendedCourses)
    }
    
    func ratingAverage(by ratingType: AverageRatingType) -> [String : Double] {
        var averageArray = [String : Double]()
        
        var currentAverage = 0.0
        var currentCount = 0.0
        var currentParameterId = "0"
        
        let sortedRatings: [FBRating] = {
            switch ratingType {
            case .item:
                let ratings = ratings.sorted(by: { $0.itemId ?? "0" < $1.itemId ?? "0" })
                return ratings
                
            case .user:
                let ratings = ratings.sorted(by: { $0.userId ?? "0" < $1.userId ?? "0" })
                return ratings
            }
        }()
        
        let firstArrayElementParameter: String? = {
            switch ratingType {
            case .item:
                return sortedRatings.first?.itemId
                
            case .user:
                return sortedRatings.first?.userId
            }
        }()
        
        guard let firstParameterId = firstArrayElementParameter else { return [:] }
        currentParameterId = firstParameterId
        
        for rating in sortedRatings {
            let parameterId: String = {
                switch ratingType {
                case .item:
                    return rating.itemId ?? "0"
                    
                case .user:
                    return rating.userId ?? "0"
                }
            }()
            
            if parameterId == currentParameterId {
                currentCount += 1.0
                currentAverage += rating.value ?? 0
            } else {
                currentAverage /= currentCount
                averageArray[currentParameterId] = currentAverage
                
                currentParameterId = parameterId
                currentAverage = 0.0
                currentCount = 1.0
                currentAverage += rating.value ?? 0
            }
            
            if let last = sortedRatings.last,
               rating.userId == last.userId,
               rating.itemId == last.itemId,
               rating.value == last.value
            {
                currentAverage /= currentCount
                averageArray[currentParameterId] = currentAverage
            }
        }
        
        return averageArray
    }
    
    func overallSparsityMeasure(ratings: [Rating]) -> Double {
        let ratingCount = Double(ratings.count)
        var userCountSet = Set<Int>()
        var itemCountSet = Set<Int>()
        for rating in ratings {
            userCountSet.insert(rating.userId)
            itemCountSet.insert(rating.itemId)
        }
        let denominator = Double(userCountSet.count * itemCountSet.count)
        let sparsityValue = 1.0 - (ratingCount / denominator)
        
        return sparsityValue
    }
}


final class ExampleRecommenderSystem {
    var ratings: [Rating]
    enum AverageRatingType {
        case user
        case item
    }
    
    init(ratings: [Rating]) {
        self.ratings = ratings
    }
}

extension ExampleRecommenderSystem {
    func cosineSimilarity(
        item1: Int,
        item2: Int,
        isAdjusted: Bool
    ) -> Double {
        let sortedByItemIdRatings = self.ratings.sorted(by: { $0.itemId < $1.itemId })
        let ratingAverage = ratingAverage(by: .user)
        let item1Ratings = sortedByItemIdRatings.filter { $0.itemId == item1 }
        let item2Ratings = sortedByItemIdRatings.filter { $0.itemId == item2 }
        var numerator = 0.0 // pembilang
        var item1Denominator = 0.0 // penyebut (kiri)
        var item2Denominator = 0.0 // penyebut (kanan)
        for rating1 in item1Ratings {
            for rating2 in item2Ratings {
                if rating1.userId == rating2.userId {
                    let averageRatingUser1 = isAdjusted ? ratingAverage[rating1.userId - 1] : 0.0
                    let averageRatingUser2 = isAdjusted ? ratingAverage[rating2.userId - 1] : 0.0
                    let ratingValue1 = rating1.value - averageRatingUser1
                    let ratingValue2 = rating2.value - averageRatingUser2
                    numerator += ratingValue1 * ratingValue2
                    item1Denominator += pow(ratingValue1, 2)
                    item2Denominator += pow(ratingValue2, 2)
                }
            }
        }
        if item1Denominator == 0.0 || item2Denominator == 0.0 {
            return 0.0
        }
        let similarityValue = numerator / (sqrt(item1Denominator) * sqrt(item2Denominator))
        let adjustedPrefix = isAdjusted ? "Adjusted " : ""
        print("\(adjustedPrefix)Cosine similarity value between item \(item1) and item \(item2) is \(similarityValue)")
        return similarityValue
    }
    
    func weightedSum(
        userId: Int,
        itemId: Int,
        isAdjusted: Bool
    ) -> Double {
        let adjustedPrefix = isAdjusted ? "Adjusted " : ""
        let ratingAverage = ratingAverage(by: .item)
        var sum = 0.0
        var similaritySum = 0.0
        var averageUnratedItem = 0.0
        for rating in ratings {
            if rating.userId == userId && rating.itemId != itemId {
                let averageRatingItem = isAdjusted ? ratingAverage[rating.itemId - 1] : 0.0
                averageUnratedItem = isAdjusted ? ratingAverage[itemId - 1] : 0.0
                let ratingValue = rating.value - averageRatingItem
                let similarity = cosineSimilarity(item1: itemId, item2: rating.itemId, isAdjusted: isAdjusted)
                sum += similarity * ratingValue
                similaritySum += abs(similarity)
            } else if rating.userId == userId && rating.itemId == itemId {
                print("\(adjustedPrefix)Weighted sum for user \(userId) and item \(itemId) is 0.0")
                return rating.value
            }
        }
        
        if similaritySum == 0.0 {
            print("\(adjustedPrefix)Weighted sum for user \(userId) and item \(itemId) is 0.0")
            return 0.0
        }
        
        var weightedSum = averageUnratedItem + (sum / similaritySum)
        if weightedSum > 5.0 {
            weightedSum = 5.0
        }
        
        print("\(adjustedPrefix)Weighted sum for user \(userId) and item \(itemId) is \(weightedSum)")
        
        return weightedSum
    }
    
    func recommend(userId: Int) -> [(Int, Double)] {
        var similarities = [Int: [Int: Double]]()
        for rating1 in ratings {
            for rating2 in ratings {
                if rating1.itemId != rating2.itemId {
                    let similarity = cosineSimilarity(item1: rating1.itemId, item2: rating2.itemId, isAdjusted: false)
                    let adjSim = cosineSimilarity(item1: rating1.itemId, item2: rating2.itemId, isAdjusted: true)
                    if similarities[rating1.itemId] == nil {
                        similarities[rating1.itemId] = [rating2.itemId: similarity]
                    } else {
                        similarities[rating1.itemId]![rating2.itemId] = similarity
                    }
                }
            }
        }
        
        var recommendations = [(Int, Double)]()
        let unratedItems = Set(ratings.map { $0.itemId }).symmetricDifference(Set(ratings.filter { $0.userId == userId }.map { $0.itemId }))
        for item in unratedItems {
            var prediction = 0.0
            var similaritySum = 0.0
            for ratedItem in ratings.filter({ $0.userId == userId }) {
                if let sim = similarities[item]?[ratedItem.itemId] {
                    prediction += sim * ratedItem.value
                    similaritySum += sim
                }
            }
            if similaritySum > 0 {
                recommendations.append((item, prediction / similaritySum))
            }
        }
        
        // Sort the recommendations in order of predicted rating
        return recommendations.sorted { $0.1 > $1.1 }
    }
    
    func ratingAverage(by ratingType: AverageRatingType) -> [Double] {
        var averageArray = [Double]()
        
        var currentAverage = 0.0
        var currentCount = 0.0
        var currentParameterId = 0
        
        let sortedRatings: [Rating] = {
            switch ratingType {
            case .item:
                let ratings = ratings.sorted(by: { $0.itemId < $1.itemId })
                return ratings
                
            case .user:
                let ratings = ratings.sorted(by: { $0.userId < $1.userId })
                return ratings
            }
        }()
        
        let firstArrayElementParameter: Int? = {
            switch ratingType {
            case .item:
                return sortedRatings.first?.itemId
                
            case .user:
                return sortedRatings.first?.userId
            }
        }()
        
        guard let firstParameterId = firstArrayElementParameter else { return [] }
        currentParameterId = firstParameterId
        
        for rating in sortedRatings {
            let parameterId: Int = {
                switch ratingType {
                case .item: return rating.itemId
                case .user: return rating.userId
                }
            }()
            
            if parameterId == currentParameterId {
                currentCount += 1.0
                currentAverage += rating.value
            } else {
                currentAverage /= currentCount
                averageArray.append(currentAverage)
                
                currentParameterId = parameterId
                currentAverage = 0.0
                currentCount = 1.0
                currentAverage += rating.value
            }
            
            if let last = sortedRatings.last,
               rating.userId == last.userId,
               rating.itemId == last.itemId,
               rating.value == last.value
            {
                currentAverage /= currentCount
                averageArray.append(currentAverage)
            }
        }
        
        return averageArray
    }
    
    func overallSparsityMeasure(ratings: [Rating]) -> Double {
        let ratingCount = Double(ratings.count)
        var userCountSet = Set<Int>()
        var itemCountSet = Set<Int>()
        for rating in ratings {
            userCountSet.insert(rating.userId)
            itemCountSet.insert(rating.itemId)
        }
        let denominator = Double(userCountSet.count * itemCountSet.count)
        let sparsityValue = 1.0 - (ratingCount / denominator)
        
        return sparsityValue
    }
}

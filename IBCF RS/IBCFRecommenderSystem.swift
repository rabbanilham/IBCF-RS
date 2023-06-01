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
                if let firstRatingValue = rating1.value,
                   let secondRatingValue = rating2.value,
                   rating1.userId == rating2.userId {
                    let averageRatingUser1 = isAdjusted ? ratingAverage[rating1.userId ?? "0"] ?? 0.0 : 0.0
                    let averageRatingUser2 = isAdjusted ? ratingAverage[rating2.userId ?? "0"] ?? 0.0 : 0.0
                    let ratingValue1 = firstRatingValue - averageRatingUser1
                    let ratingValue2 = secondRatingValue - averageRatingUser2
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
    
    func cosineSimilarity(
        ratings: [FBRating],
        item1: String?,
        item2: String?,
        isAdjusted: Bool
    ) -> Double {
        let adjustedPrefix = isAdjusted ? "Adjusted " : ""
        let ratingAverage = ratingAverage(by: .user)
        let item1Ratings = ratings.filter({ $0.itemId ?? "0" == item1 })
        let item2Ratings = ratings.filter({ $0.itemId ?? "0" == item2 })
        var numerator = 0.0 // pembilang
        var item1Denominator = 0.0 // penyebut (kiri)
        var item2Denominator = 0.0 // penyebut (kanan)
        
        for rating1 in item1Ratings {
            for rating2 in item2Ratings {
                if let firstRatingValue = rating1.value,
                   let secondRatingValue = rating2.value,
                   rating1.userId == rating2.userId {
                    let averageRatingUser1 = isAdjusted ? ratingAverage[rating1.userId ?? "0"] ?? 0.0 : 0.0
                    let averageRatingUser2 = isAdjusted ? ratingAverage[rating2.userId ?? "0"] ?? 0.0 : 0.0
                    let ratingValue1 = firstRatingValue - averageRatingUser1
                    let ratingValue2 = secondRatingValue - averageRatingUser2
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
    
    func getNearestNeighbors(
        for itemId: String,
        numberOfNearestNeighbors: Int,
        ratings: [FBRating],
        isAdjusted: Bool = true,
        _ completion: ([SimilarityValue]) -> Void
    ) {
        let allCourses = FBCourse.allCourses()
        var allSimilarityValue = [SimilarityValue]()
        for course1 in allCourses.filter({ $0.id == itemId }) {
            for course2 in allCourses.filter({ $0.id != itemId }) {
                let similarity = cosineSimilarity(ratings: ratings, item1: course1.id, item2: course2.id, isAdjusted: true)
                let similarityValue = SimilarityValue(course: course1, similarToCourse: course2, similarityValue: similarity)
                allSimilarityValue.append(similarityValue)
            }
        }
        allSimilarityValue.sort(by: { $0.similarityValue > $1.similarityValue })
        allSimilarityValue.removeLast(allSimilarityValue.count - numberOfNearestNeighbors)
        print("All similarity values are \(allSimilarityValue)")
        completion(allSimilarityValue)
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
        var nearestNeighbors = 0

        for rating in ratings {
            if rating.userId == userId &&
                rating.itemId != itemId {
                let averageRatingItem = isAdjusted ? (ratingAverage[rating.itemId ?? ""] ?? 0.0) : 0.0
                averageUnratedItem = isAdjusted ? (ratingAverage[itemId ?? ""] ?? 0.0) : 0.0
                let ratingValue = (rating.value ?? 0) - averageRatingItem
                let similarity = cosineSimilarity(item1: itemId, item2: rating.itemId, isAdjusted: isAdjusted)
                sum += similarity * ratingValue
                similaritySum += abs(similarity)
                nearestNeighbors += 1
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
    
    func weightedSum(
        ratings: [FBRating],
        userId: String?,
        itemId: String?,
        isAdjusted: Bool
    ) -> Double {
        let adjustedPrefix = isAdjusted ? "Adjusted " : ""
        let ratingAverage = ratingAverage(by: .item)
        var sum = 0.0
        var similaritySum = 0.0
        var averageUnratedItem = 0.0
        var nearestNeighbors = 0

        for rating in ratings {
            if rating.userId == userId && rating.itemId != itemId {
                let averageRatingItem = isAdjusted ? (ratingAverage[rating.itemId ?? ""] ?? 0.0) : 0.0
                averageUnratedItem = isAdjusted ? (ratingAverage[itemId ?? ""] ?? 0.0) : 0.0
                let ratingValue = (rating.value ?? 0) - averageRatingItem
                let similarity = cosineSimilarity(ratings: ratings, item1: itemId, item2: rating.itemId, isAdjusted: isAdjusted)
                sum += similarity * ratingValue
                similaritySum += abs(similarity)
                nearestNeighbors += 1
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
    
    func weightedSum(
        userId: String?,
        itemId: String?,
        isAdjusted: Bool,
        k: Int,
        similarityValues: [SimilarityValue]? = nil,
        _ completion: ([SimilarityValue]) -> Void
    ) -> Double {
        let allCourse = FBCourse.allCourses()
        let adjustedPrefix = isAdjusted ? "Adjusted " : ""
        let ratingAverage = ratingAverage(by: .item)
        var sum = 0.0
        var similaritySum = 0.0
        var averageUnratedItem = 0.0
        var newSimilarityValues = similarityValues == nil ? [SimilarityValue]() : similarityValues!

        var neighborRatings: [(rating: FBRating, similarity: Double)] = []

        for rating in ratings {
            if rating.userId == userId && rating.itemId != itemId {
                let averageRatingItem = isAdjusted ? (ratingAverage[rating.itemId ?? ""] ?? 0.0) : 0.0
                averageUnratedItem = isAdjusted ? (ratingAverage[itemId ?? ""] ?? 0.0) : 0.0
                let ratingValue = (rating.value ?? 0) - averageRatingItem
                let similarity = similarityValues?.first(where: { ($0.course.id == itemId && $0.similarToCourse.id == rating.itemId) || ($0.course.id == rating.itemId && $0.similarToCourse.id == itemId) })?.similarityValue ?? cosineSimilarity(item1: itemId, item2: rating.itemId, isAdjusted: isAdjusted)
                if !(newSimilarityValues.contains(where: { $0.course.id == itemId && $0.similarToCourse.id == rating.itemId }) ) {
                    newSimilarityValues.append(SimilarityValue(
                        course: allCourse.first(where: { $0.id == itemId })!,
                        similarToCourse: allCourse.first(where: { $0.id == itemId })!,
                        similarityValue: similarity
                    ))
                }
                neighborRatings.append((rating: rating, similarity: similarity))
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

        // Sort the neighbor ratings by similarity in descending order
        neighborRatings.sort { $0.similarity > $1.similarity }

        // Consider only the top k nearest neighbors
        let kNeighborRatings = Array(neighborRatings.prefix(k))

        var weightedSum = averageUnratedItem
        var sum2 = 0.0
        var similaritySum2 = 0.0
        for neighborRating in kNeighborRatings {
            sum2 += (neighborRating.rating.value ?? 0) * neighborRating.similarity
            similaritySum2 += abs(neighborRating.similarity)
        }

        weightedSum += (sum2 / similaritySum2)

        if weightedSum > 5.0 {
            weightedSum = 5.0
        }
        print("c3 \(adjustedPrefix)Weighted sum for user \(String(describing: userId)) and item \(String(describing: itemId)) is \(weightedSum)")
        completion(newSimilarityValues)

        return weightedSum
    }
    
    func weightedSum(
        ratings: [FBRating],
        userId: String?,
        itemId: String?,
        isAdjusted: Bool,
        k: Int,
        similarityValues: [SimilarityValue]? = nil,
        _ completion: @escaping ([SimilarityValue]) -> Void
    ) -> Double {
        let allCourse = FBCourse.allCourses()
        let adjustedPrefix = isAdjusted ? "Adjusted " : ""
        let ratingAverage = ratingAverage(by: .item)
        var sum = 0.0
        var similaritySum = 0.0
        var averageUnratedItem = 0.0
        var neighborRatings: [(rating: FBRating, similarity: Double)] = []
        var newSimilarityValues = similarityValues == nil ? [SimilarityValue]() : similarityValues!
        
        for rating in ratings {
            if rating.userId == userId && rating.itemId != itemId {
                let averageRatingItem = isAdjusted ? (ratingAverage[rating.itemId ?? ""] ?? 0.0) : 0.0
                averageUnratedItem = isAdjusted ? (ratingAverage[itemId ?? ""] ?? 0.0) : 0.0
                let ratingValue = (rating.value ?? 0) - averageRatingItem
                let similarity = newSimilarityValues.first(where: { ($0.course.id == itemId && $0.similarToCourse.id == rating.itemId) || ($0.course.id == rating.itemId && $0.similarToCourse.id == itemId) })?.similarityValue ?? cosineSimilarity(ratings: ratings, item1: itemId, item2: rating.itemId, isAdjusted: isAdjusted)
                neighborRatings.append((rating: rating, similarity: similarity))
                if !newSimilarityValues.contains(where: { $0.course.id == itemId && $0.similarToCourse.id == rating.itemId }) {
                    newSimilarityValues.append(SimilarityValue(
                        course: allCourse.first(where: { $0.id == itemId })!,
                        similarToCourse: allCourse.first(where: { $0.id == rating.itemId })!,
                        similarityValue: similarity
                    ))
                }
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
        
        // Sort the neighbor ratings by similarity in descending order
        neighborRatings.sort { $0.similarity > $1.similarity }
        print("neighbor ratings are \(neighborRatings.count)")
        
        // Consider only the top k nearest neighbors
        let kNeighborRatings = Array(neighborRatings.prefix(k))
        
        var weightedSum = averageUnratedItem
        var sum2 = 0.0
        var similaritySum2 = 0.0
        for neighborRating in kNeighborRatings {
            sum2 += (neighborRating.rating.value ?? 0) * neighborRating.similarity
            similaritySum2 += abs(neighborRating.similarity)
        }

        weightedSum += (sum2 / similaritySum2)
        
        if weightedSum > 5.0 {
            weightedSum = 5.0
        }
        print("c3 \(adjustedPrefix)Weighted sum for user \(String(describing: userId)) and item \(String(describing: itemId)) is \(weightedSum)")
        completion(newSimilarityValues)
        
        return weightedSum
    }

    
    func getSimilarityValues(
        completion: ([CourseSimilarity]) -> Void
    ) {
        var similarityValues = [CourseSimilarity]()
        var firstId = 1
        
        while firstId < 67 {
            for secondId in 1...66 {
                let value = cosineSimilarity(item1: "\(firstId)", item2: "\(secondId)", isAdjusted: true)
                let similarity = CourseSimilarity(firstCourseId: "\(firstId)", secondCourseId: "\(secondId)", value: value)
                similarityValues.append(similarity)
                print("finished \(firstId)")
            }
            firstId += 1
        }
        
        similarityValues.sort(by: { $0.firstCourseId < $1.firstCourseId })
        
        completion(similarityValues)
    }
    
    func getRecommendations(
        userId: String,
        itemIds: [String],
        numberOfK: Int = 0,
        _ completion: ([CourseRecommendation]) -> Void
    ) {
        var recommendedCourses = [CourseRecommendation]()
        for itemId in itemIds {
            let recommendedCourseValue = numberOfK == 0 ? weightedSum(userId: userId, itemId: itemId, isAdjusted: true) : weightedSum(userId: userId, itemId: itemId, isAdjusted: true, k: numberOfK) { _ in
                
            }
            let recommendedCourse = CourseRecommendation(courseId: itemId, predictionValue: recommendedCourseValue)
            recommendedCourses.append(recommendedCourse)
        }
        
        completion(recommendedCourses)
    }
    
    func getRecommendations(
        ratings: [FBRating],
        userId: String,
        itemIds: [String],
        numberOfK: Int = 0,
        similarityValues: [SimilarityValue] = [],
        _ completion: ([CourseRecommendation], [SimilarityValue]) -> Void
    ) {
        guard !itemIds.isEmpty else {
            completion([], similarityValues)
            return
        }
        var recommendedCourses = [CourseRecommendation]()
        var _similarityValues = similarityValues
        for itemId in itemIds {
            let recommendedCourseValue = numberOfK == 0 ? weightedSum(ratings: ratings, userId: userId, itemId: itemId, isAdjusted: true) : weightedSum(ratings: ratings, userId: userId, itemId: itemId, isAdjusted: true, k: numberOfK, similarityValues: _similarityValues) { simVals in
                for simVal in simVals {
                    if !_similarityValues.contains(where: { $0.course.id == simVal.course.id && $0.similarToCourse.id == simVal.similarToCourse.id }) {
                        _similarityValues.append(simVal)
                    }
                }
            }
            let recommendedCourse = CourseRecommendation(courseId: itemId, predictionValue: recommendedCourseValue)
            recommendedCourses.append(recommendedCourse)
        }
        
        completion(recommendedCourses, _similarityValues)
    }
    
    func calculateRecommenderPerformance(
        numberOfTestingData: Int,
        numberOfK: Int = 0,
        _ completion: (FBPerformance) -> Void
    ) {
        var userIds = Array(Set(ratings.map { $0.userId })).shuffled()
        var testDataUserIds = [String?]()
        for _ in 1...numberOfTestingData {
            testDataUserIds.append(userIds.removeFirst()) // randomly select testing data user IDs
        }
        
        let allCourses = FBCourse.allCourses()
        // declare all courses which its rating prediction will be counted
        let testingCourses = allCourses.filter({ $0.areaOfInterest != nil && $0.oldCurriculumSemesterAvailability ?? 0 > 4 })
        let testingCoursesIds = testingCourses.map({ $0.id! })
        
        // declare training data ratings
        let trainingDataRatings = self.ratings.filter({ userIds.contains($0.userId) == true })
        
        var testingDataRatings = self.ratings.filter({ testDataUserIds.contains($0.userId) == true })
        let testingDataActualRatings = testingDataRatings
        testingDataRatings.removeAll(where: { testingCoursesIds.contains($0.itemId!) == true })
        
        print("testing courses is \(testingCourses)")
        print("testing courses ids is \(testingCoursesIds)")
        print("training data ratings is \(trainingDataRatings)")
        print("testing data ratings is \(testingDataRatings)")
        print("test data user ids is \(testDataUserIds)")
        
        var errors = [CoursePredictionError]()
        for userId in testDataUserIds {
            if numberOfK == 0 {
                getRecommendations(
                    ratings: trainingDataRatings + testingDataRatings,
                    userId: userId ?? "",
                    itemIds: testingCoursesIds
                ) { [weak self] recommendations, _ in
                    guard let _ = self else { return }
                    for recommendation in recommendations {
                        let error = CoursePredictionError(
                            userId: userId ?? "",
                            courseId: recommendation.courseId,
                            predictionValue: recommendation.predictionValue,
                            actualValue: testingDataActualRatings.first(where: {
                                $0.itemId == recommendation.courseId &&
                                $0.userId == userId
                            })?.value ?? 0
                        )
                        if error.actualValue != 0 {
                            errors.append(error)
                        }
                    }
                }
            } else {
                getRecommendations(
                    ratings: trainingDataRatings + testingDataRatings,
                    userId: userId ?? "",
                    itemIds: testingCoursesIds,
                    numberOfK: numberOfK
                ) { [weak self] recommendations, _ in
                    guard let _ = self else { return }
                    for recommendation in recommendations {
                        let error = CoursePredictionError(
                            userId: userId ?? "",
                            courseId: recommendation.courseId,
                            predictionValue: recommendation.predictionValue,
                            actualValue: testingDataActualRatings.first(where: {
                                $0.itemId == recommendation.courseId &&
                                $0.userId == userId
                            })?.value ?? 0
                        )
                        if error.actualValue != 0 {
                            errors.append(error)
                        }
                    }
                }
            }
            
        }
        print("all errors are \(errors)")
        
        // calculate MAE
        var maeSum = 0.0
        for error in errors {
            maeSum += abs(error.error)
        }
        let errorCount = Double(errors.count)
        let meanAbsoluteError = maeSum / errorCount
        print("MAE is \(meanAbsoluteError)")
        
        // calculate RMSE
        var rmseSum = 0.0
        for error in errors {
            rmseSum += pow(error.error, 2)
        }
        let rootMeanSquareError = sqrt(rmseSum / errorCount)
        print("RMSE is \(rootMeanSquareError)")
        
        // calculate std dev
        var meanSum = 0.0
        for error in errors {
            meanSum += error.error
        }
        let mean = meanSum / Double(errors.count)
        var errorSum = 0.0
        for error in errors {
            errorSum += pow(error.error - mean, 2)
        }
        let stdDev = sqrt(errorSum / Double(errors.count))
        
        print("Standard Deviation is \(stdDev)")
        
        let performanceResult = FBPerformance(
            meanAbsoluteError: meanAbsoluteError,
            rootMeanSquareError: rootMeanSquareError,
            errors: errors,
            trainingDataRatings: trainingDataRatings,
            testingDataRatings: testingDataRatings,
            testingDataUserIds: testDataUserIds,
            standardDeviation: stdDev
        )
        
        completion(performanceResult)
    }
    
    func calculateRecommenderPerformance(
        testingDataUserIds: [String],
        numberOfK: Int = 0,
        _ completion: (FBPerformance) -> Void
    ) {
        let allUserIds = Array(Set(ratings.map { $0.userId }))
        let allCourses = FBCourse.allCourses()
        // declare all courses which its rating prediction will be counted
        let testingCourses = allCourses.filter({ $0.areaOfInterest != nil && $0.oldCurriculumSemesterAvailability ?? 0 > 4 })
        let testingCoursesIds = testingCourses.map({ $0.id! })
        
        // declare training data ratings
        var trainingDataRatings = self.ratings.filter({ allUserIds.contains($0.userId) == true })
        for testingDataUserId in testingDataUserIds {
            trainingDataRatings.removeAll(where: { $0.userId == testingDataUserId })
        }
        
        var testingDataRatings = self.ratings.filter({ testingDataUserIds.contains($0.userId ?? "") == true })
        let testingDataActualRatings = testingDataRatings
        testingDataRatings.removeAll(where: { testingCoursesIds.contains($0.itemId!) == true })
        
        print("testing courses is \(testingCourses)")
        print("testing courses ids is \(testingCoursesIds)")
        print("training data ratings is \(trainingDataRatings)")
        print("testing data ratings is \(testingDataRatings)")
        print("test data user ids is \(testingDataUserIds)")
        
        var errors = [CoursePredictionError]()
        for userId in testingDataUserIds {
            if numberOfK == 0 {
                getRecommendations(
                    ratings: trainingDataRatings + testingDataRatings,
                    userId: userId,
                    itemIds: testingCoursesIds
                ) { [weak self] recommendations, _ in
                    guard let _ = self else { return }
                    for recommendation in recommendations {
                        let error = CoursePredictionError(
                            userId: userId,
                            courseId: recommendation.courseId,
                            predictionValue: recommendation.predictionValue,
                            actualValue: testingDataActualRatings.first(where: {
                                $0.itemId == recommendation.courseId &&
                                $0.userId == userId
                            })?.value ?? 0
                        )
                        if error.actualValue != 0 {
                            errors.append(error)
                        }
                    }
                }
            } else {
                getRecommendations(
                    ratings: trainingDataRatings + testingDataRatings,
                    userId: userId,
                    itemIds: testingCoursesIds,
                    numberOfK: numberOfK
                ) { [weak self] recommendations, _ in
                    guard let _ = self else { return }
                    for recommendation in recommendations {
                        let error = CoursePredictionError(
                            userId: userId,
                            courseId: recommendation.courseId,
                            predictionValue: recommendation.predictionValue,
                            actualValue: testingDataActualRatings.first(where: {
                                $0.itemId == recommendation.courseId &&
                                $0.userId == userId
                            })?.value ?? 0
                        )
                        if error.actualValue != 0 {
                            errors.append(error)
                        }
                    }
                }
            }
        }
        print("all errors are \(errors)")
        
        // calculate MAE
        var maeSum = 0.0
        for error in errors {
            maeSum += abs(error.error)
        }
        let errorCount = Double(errors.count)
        let meanAbsoluteError = maeSum / errorCount
        print("MAE is \(meanAbsoluteError)")
        
        // calculate RMSE
        var rmseSum = 0.0
        for error in errors {
            rmseSum += pow(error.error, 2)
        }
        let rootMeanSquareError = sqrt(rmseSum / errorCount)
        print("RMSE is \(rootMeanSquareError)")
        
        // calculate std dev
        var meanSum = 0.0
        for error in errors {
            meanSum += error.error
        }
        let mean = meanSum / Double(errors.count)
        var errorSum = 0.0
        for error in errors {
            errorSum += pow(error.error - mean, 2)
        }
        let stdDev = sqrt(errorSum / Double(errors.count))
        print("Standard Deviation is \(stdDev)")
        
        let performanceResult = FBPerformance(
            meanAbsoluteError: meanAbsoluteError,
            rootMeanSquareError: rootMeanSquareError,
            errors: errors,
            trainingDataRatings: trainingDataRatings,
            testingDataRatings: testingDataRatings,
            testingDataUserIds: testingDataUserIds,
            standardDeviation: stdDev
        )
        
        completion(performanceResult)
    }
    
    func kfcvCalculateRecommenderPerformance(
        numberOfK: Int = 0,
        _ completion: (FBPerformance) -> Void
    ) {
        var allErrors = [CoursePredictionError]()
        let allCourses = FBCourse.allCourses()
        let testingCourses = allCourses.filter({ $0.areaOfInterest != nil && $0.oldCurriculumSemesterAvailability ?? 0 > 4 })
        let testingCoursesIds = testingCourses.map({ $0.id! })
        // declare all courses which its rating prediction will be counted
        // k-fold cross validation
        let shuffledRatings = ratings.shuffled()
        var splitArrays = [[FBRating]]()
        var newSplit = [FBRating]()
        var count = 0
        for rating in shuffledRatings {
            if count <= 378 {
                newSplit.append(rating)
                count += 1
            } else {
                count = 0
                splitArrays.append(newSplit)
                newSplit = []
            }
        }
        
        for (i, array) in splitArrays.enumerated() {
            print("currently array \(i)")
            // declare training data ratings
            let trainingDataRatings = {
                let ratingsArray = splitArrays.filter({ $0 != array })
                var ratings = [FBRating]()
                for testRatings in ratingsArray {
                    for rating in testRatings {
                        ratings.append(rating)
                    }
                }
                return ratings
            }()
            var testingDataRatings = array
            let testingDataActualRatings = testingDataRatings
            testingDataRatings.removeAll(where: { testingCoursesIds.contains($0.itemId!) == true })

            print("testing courses is \(testingCourses)")
            print("testing courses ids is \(testingCoursesIds)")
            print("training data ratings is \(trainingDataRatings)")
            print("testing data ratings is \(testingDataRatings)")
            print("test data user ids is \(array)")

            var errors = [CoursePredictionError]()
            var similarityValues = [SimilarityValue]()
            let userIds = array.map({ $0.userId })
            var testedUserIds = [String?]()
            
            for (i, userId) in userIds.enumerated() {
                print("currently user \(i + 1) of \(userIds.count)")
                if !testedUserIds.contains(userId) {
                    testedUserIds.append(userId)
                    getRecommendations(
                        ratings: trainingDataRatings + testingDataRatings,
                        userId: userId ?? "",
                        itemIds: testingDataActualRatings.filter({ $0.userId == userId
                            && (Int($0.itemId ?? "") ?? 0) > 32
                        }).map({ $0.itemId ?? "" }),
                        numberOfK: numberOfK,
                        similarityValues: similarityValues
                    ) { [weak self] recommendations, simVals in
                        guard let _ = self else { return }
                        for simVal in simVals {
                            if !similarityValues.contains(where: { $0.course.id == simVal.course.id && $0.similarToCourse.id == simVal.similarToCourse.id }) {
                                similarityValues.append(simVal)
                            }
                        }
                        if !recommendations.isEmpty {
                            for recommendation in recommendations {
                                let error = CoursePredictionError(
                                    userId: userId ?? "",
                                    courseId: recommendation.courseId,
                                    predictionValue: recommendation.predictionValue,
                                    actualValue: testingDataActualRatings.first(where: {
                                        $0.itemId == recommendation.courseId &&
                                        $0.userId == userId
                                    })?.value ?? 0
                                )
                                if error.actualValue != 0 {
                                    errors.append(error)
                                    allErrors.append(error)
                                }
                            }
                        }
                    }
                }
            }
            print("all errors are \(errors)")
        }
        
        // calculate MAE
        var maeSum = 0.0
        for error in allErrors {
            maeSum += abs(error.error)
        }
        let errorCount = Double(allErrors.count)
        let meanAbsoluteError = maeSum / errorCount
        print("MAE is \(meanAbsoluteError)")

        // calculate RMSE
        var rmseSum = 0.0
        for error in allErrors {
            rmseSum += pow(error.error, 2)
        }
        let rootMeanSquareError = sqrt(rmseSum / errorCount)
        print("RMSE is \(rootMeanSquareError)")

        // calculate std dev
        var meanSum = 0.0
        for error in allErrors {
            meanSum += error.error
        }
        let mean = meanSum / Double(allErrors.count)
        var errorSum = 0.0
        for error in allErrors {
            errorSum += pow(error.error - mean, 2)
        }
        let stdDev = sqrt(errorSum / Double(allErrors.count))
        print("Standard Deviation is \(stdDev)")

        let performanceResult = FBPerformance(
            meanAbsoluteError: meanAbsoluteError,
            rootMeanSquareError: rootMeanSquareError,
            errors: allErrors,
            trainingDataRatings: [],
            testingDataRatings: [],
            testingDataUserIds: [],
            standardDeviation: stdDev
        )
        completion(performanceResult)
    }
    
    func kfcvCalculateRecommenderPerformance(
        testingDataUserIds: [String?],
        numberOfK: Int = 0,
        _ completion: (FBPerformance) -> Void
    ) {
        var allErrors = [CoursePredictionError]()
        let allCourses = FBCourse.allCourses()
        let testingCourses = allCourses.filter({ $0.areaOfInterest != nil && $0.oldCurriculumSemesterAvailability ?? 0 > 4 })
        let testingCoursesIds = testingCourses.map({ $0.id! })
        // declare all courses which its rating prediction will be counted
        // k-fold cross validation

        let allUserIds = Array(Set(ratings.map { $0.userId }))
        
        // declare training data ratings
        var trainingDataRatings = self.ratings.filter({ allUserIds.contains($0.userId) == true })
        for testingDataUserId in testingDataUserIds {
            trainingDataRatings.removeAll(where: { $0.userId == testingDataUserId })
        }
        
        var testingDataRatings = self.ratings.filter({ testingDataUserIds.contains($0.userId ?? "") == true })
        let testingDataActualRatings = testingDataRatings
        testingDataRatings.removeAll(where: { testingCoursesIds.contains($0.itemId!) == true })

        print("testing courses is \(testingCourses)")
        print("testing courses ids is \(testingCoursesIds)")
        print("training data ratings is \(trainingDataRatings)")
        print("testing data ratings is \(testingDataRatings)")
        print("test data user ids is \(testingDataUserIds)")
        
        var similarityValues = [SimilarityValue]()
        for userId in testingDataUserIds {
            getRecommendations(
                ratings: trainingDataRatings + testingDataRatings,
                userId: userId ?? "",
                itemIds: testingDataActualRatings.filter({ $0.userId == userId
                    && (Int($0.itemId ?? "") ?? 0) > 32
                }).map({ $0.itemId ?? "" }),
                numberOfK: numberOfK,
                similarityValues: similarityValues
            ) { [weak self] recommendations, simVals in
                guard let _ = self else { return }
                for simVal in simVals {
                    if !similarityValues.contains(where: { $0.course.id == simVal.course.id && $0.similarToCourse.id == simVal.similarToCourse.id }) {
                        similarityValues.append(simVal)
                    }
                }
                if !recommendations.isEmpty {
                    for recommendation in recommendations {
                        let error = CoursePredictionError(
                            userId: userId ?? "",
                            courseId: recommendation.courseId,
                            predictionValue: recommendation.predictionValue,
                            actualValue: testingDataActualRatings.first(where: {
                                $0.itemId == recommendation.courseId &&
                                $0.userId == userId
                            })?.value ?? 0
                        )
                        if error.actualValue != 0 {
                            allErrors.append(error)
                        }
                    }
                }
            }
        }
        
        // calculate MAE
        var maeSum = 0.0
        for error in allErrors {
            maeSum += abs(error.error)
        }
        let errorCount = Double(allErrors.count)
        let meanAbsoluteError = maeSum / errorCount
        print("MAE is \(meanAbsoluteError)")

        // calculate RMSE
        var rmseSum = 0.0
        for error in allErrors {
            rmseSum += pow(error.error, 2)
        }
        let rootMeanSquareError = sqrt(rmseSum / errorCount)
        print("RMSE is \(rootMeanSquareError)")

        // calculate std dev
        var meanSum = 0.0
        for error in allErrors {
            meanSum += error.error
        }
        let mean = meanSum / Double(allErrors.count)
        var errorSum = 0.0
        for error in allErrors {
            errorSum += pow(error.error - mean, 2)
        }
        let stdDev = sqrt(errorSum / Double(allErrors.count))
        print("Standard Deviation is \(stdDev)")

        let performanceResult = FBPerformance(
            meanAbsoluteError: meanAbsoluteError,
            rootMeanSquareError: rootMeanSquareError,
            errors: allErrors,
            trainingDataRatings: trainingDataRatings,
            testingDataRatings: testingDataRatings,
            testingDataUserIds: testingDataUserIds,
            standardDeviation: stdDev
        )
        print("res are \(performanceResult)")
        completion(performanceResult)
    }
    
//    func kfcvCalculateRecommenderPerformance(
//        numberOfK: Int = 0,
//        _ completion: (FBPerformance) -> Void
//    ) {
//        var allErrors = [CoursePredictionError]()
//        let allUserIds = Array(Set(ratings.map { $0.userId })).shuffled()
//        let allCourses = FBCourse.allCourses()
//        let testingCourses = allCourses.filter({ $0.areaOfInterest != nil && $0.oldCurriculumSemesterAvailability ?? 0 > 4 })
//        let testingCoursesIds = testingCourses.map({ $0.id! })
//        // declare all courses which its rating prediction will be counted
//        // k-fold cross validation
//        let splitArrays = stride(from: 0, to: allUserIds.count, by: allUserIds.count / 10)
//            .map { startIndex -> ArraySlice<String?> in
//                let endIndex = startIndex + allUserIds.count / 10
//                return allUserIds[startIndex..<endIndex]
//            }
//            .map { Array($0) }
//        for array in splitArrays {
//            // declare training data ratings
//            let trainingDataRatings = self.ratings.filter({ array.contains($0.userId ?? "") == false })
//            var testingDataRatings = self.ratings.filter({ array.contains($0.userId ?? "") == true })
//            let testingDataActualRatings = testingDataRatings
//            testingDataRatings.removeAll(where: { testingCoursesIds.contains($0.itemId!) == true })
//
//            print("testing courses is \(testingCourses)")
//            print("testing courses ids is \(testingCoursesIds)")
//            print("training data ratings is \(trainingDataRatings)")
//            print("testing data ratings is \(testingDataRatings)")
//            print("test data user ids is \(array)")
//
//            var errors = [CoursePredictionError]()
//            for userId in array {
//                getRecommendations(
//                    ratings: trainingDataRatings + testingDataRatings,
//                    userId: userId ?? "",
//                    itemIds: testingCoursesIds,
//                    numberOfK: numberOfK
//                ) { [weak self] recommendations in
//                    guard let _ = self else { return }
//                    for recommendation in recommendations {
//                        let error = CoursePredictionError(
//                            userId: userId ?? "",
//                            courseId: recommendation.courseId,
//                            predictionValue: recommendation.predictionValue,
//                            actualValue: testingDataActualRatings.first(where: {
//                                $0.itemId == recommendation.courseId &&
//                                $0.userId == userId
//                            })?.value ?? 0
//                        )
//                        if error.actualValue != 0 {
//                            errors.append(error)
//                            allErrors.append(error)
//                        }
//                    }
//                }
//            }
//            print("all errors are \(errors)")
//        }
//
//        // calculate MAE
//        var maeSum = 0.0
//        for error in allErrors {
//            maeSum += abs(error.error)
//        }
//        let errorCount = Double(allErrors.count)
//        let meanAbsoluteError = maeSum / errorCount
//        print("MAE is \(meanAbsoluteError)")
//
//        // calculate RMSE
//        var rmseSum = 0.0
//        for error in allErrors {
//            rmseSum += pow(error.error, 2)
//        }
//        let rootMeanSquareError = sqrt(rmseSum / errorCount)
//        print("RMSE is \(rootMeanSquareError)")
//
//        // calculate std dev
//        var meanSum = 0.0
//        for error in allErrors {
//            meanSum += error.error
//        }
//        let mean = meanSum / Double(allErrors.count)
//        var errorSum = 0.0
//        for error in allErrors {
//            errorSum += pow(error.error - mean, 2)
//        }
//        let stdDev = sqrt(errorSum / Double(allErrors.count))
//        print("Standard Deviation is \(stdDev)")
//
//        let performanceResult = FBPerformance(
//            meanAbsoluteError: meanAbsoluteError,
//            rootMeanSquareError: rootMeanSquareError,
//            errors: allErrors,
//            trainingDataRatings: [],
//            testingDataRatings: [],
//            testingDataUserIds: allUserIds,
//            standardDeviation: stdDev
//        )
//        completion(performanceResult)
//    }
    
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
//                    let adjSim = cosineSimilarity(item1: rating1.itemId, item2: rating2.itemId, isAdjusted: true)
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

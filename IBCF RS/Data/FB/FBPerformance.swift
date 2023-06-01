//
//  FBPerformance.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 28/04/23.
//

import Foundation

struct FBPerformance {
    let meanAbsoluteError: Double
    let rootMeanSquareError: Double
    var errors: [CoursePredictionError]
    let trainingDataRatings: [FBRating]
    let testingDataRatings: [FBRating]
    let testingDataUserIds: [String?]
    let standardDeviation: Double
}

//
//  CoursePredictionError.swift
//  IBCF RS
//
//  Created by Bagas Ilham on 25/04/23.
//

import Foundation

struct CoursePredictionError {
    let userId: String
    let courseId: String
    let predictionValue: Double
    let actualValue: Double
    let error: Double
    
    init(userId: String, courseId: String, predictionValue: Double, actualValue: Double) {
        self.userId = userId
        self.courseId = courseId
        self.predictionValue = predictionValue
        self.actualValue = actualValue
        self.error = predictionValue - actualValue
    }
}

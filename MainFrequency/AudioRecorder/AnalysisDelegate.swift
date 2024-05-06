//
//  AnalysisDelegate.swift
//  UIKit MainFrequency
//
//  Created by Joaquim Pessoa Filho on 06/05/24.
//

import Foundation

protocol AnalysisDelegate: AnyObject {
    func didUpdate(frequency: Float)
}

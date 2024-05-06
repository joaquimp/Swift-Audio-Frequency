//
//  AudioRecorderDelegate.swift
//  UIKit MainFrequency
//
//  Created by Joaquim Pessoa Filho on 06/05/24.
//

import Foundation

protocol AudioRecorderDelegate {
    var delegate: AnalysisDelegate? { get set }
    var isRecording: Bool { get }
    
    func start()
    func stop()
}

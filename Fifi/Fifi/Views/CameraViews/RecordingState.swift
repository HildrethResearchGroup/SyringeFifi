//
//  RecordingState.swift
//  DNVNew
//
//  Created by Connor Barnes on 5/9/22.
//

import Foundation

struct RecordingState {
	var canRecord = false {
		didSet {
			if !canRecord {
				isRecording = false
			}
		}
	}
	
	var isRecording = false
	
	var recordingURL: URL? {
		didSet {
			isRecording = false
		}
	}
	
	init() {
		
	}
}

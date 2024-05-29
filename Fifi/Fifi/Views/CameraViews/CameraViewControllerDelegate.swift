//
//  CameraViewControllerDelegate.swift
//  DNVNew
//
//  Created by Connor Barnes on 5/9/22.
//

import Cocoa

protocol CameraViewControllerDelegate {
	func cameraViewController(_ viewController: CameraViewController, canRecordDidChange canRecord: Bool)
}

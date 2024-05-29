//
//  CustomEnvironmentVariables.swift
//  Fifi
//
//  Created by Connor Barnes on 6/29/22.
//

import Foundation
import SwiftUI
/*
 // 1. Create the key with a default value
 private struct TextFieldNumberFormatterKey: EnvironmentKey {
	 typealias Value = FloatingPointFormatStyle<Double>
	 
	 
	 static let defaultValue: FloatingPointFormatStyle<Double> = FloatingPointFormatStyle.number.precision(.fractionLength(4))
 }

 // 2. Extend the environment with our property
 extension EnvironmentValues {
	 var textFieldNumberFormatter: FloatingPointFormatStyle<Double> {
		 get { self[TextFieldNumberFormatterKey.self] }
		 set { self[TextFieldNumberFormatterKey.self] = newValue }
	 }
 }
 */


// 3. Optional convenience view modifier

 extension View {
     func appDefaultTextFieldNumberFormatter(_ length: Int = 4) -> FloatingPointFormatStyle<Double> {
		 FloatingPointFormatStyle.number.precision(.fractionLength(length))
	 }
 }

struct AppDefaultTextFieldModifier: ViewModifier {
		func body(content: Content) -> some View {
				content
				.font(.body.monospacedDigit())
				.multilineTextAlignment(.leading)
				.frame(width: 100)
		}
}

extension View {
		func appDefaultTextFieldStyle() -> some View {
				modifier(AppDefaultTextFieldModifier())
		}
}

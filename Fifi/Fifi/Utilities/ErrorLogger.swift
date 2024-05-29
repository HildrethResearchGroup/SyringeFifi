//
//  ErrorLogger.swift
//  ErrorLogger
//
//  Created by Connor Barnes on 7/21/21.
//

import SwiftUI

actor Logger: ObservableObject {
  @MainActor
  @Published var logs: [Instance] = []
  
  @MainActor
  @Published var lastLogOfLevel: [Level : Instance] = [:]
  
  @MainActor
  @Published var lastLogOfLevelOrHigher: [Level : Instance] = [:]
  
  struct Instance: Hashable, Identifiable {
    var message: String
    var date: Date
    var level: Level
    var id = UUID()
    
    @ViewBuilder
    var icon: some View {
      let name: String = {
        switch level {
        case .debug:
          return "d.circle.fill"
        case .info:
          return "info.circle.fill"
        case .warning:
          return "exclamationmark.triangle.fill"
        case .error:
          return "exclamationmark.octagon.fill"
        }
      }()
      
      let help: String = {
        switch level {
        case .debug:
          return "Debug"
        case .info:
          return "Info"
        case .warning:
          return "Warning"
        case .error:
          return "Error"
        }
      }()
      
      Image(systemName: name)
        .renderingMode(.original)
        .font(.body.weight(.bold))
        .help(help)
    }
  }
  
  enum Level: Comparable, CaseIterable {
    case debug
    case info
    case warning
    case error
  }
}

// MARK: - Logging
extension Logger {
  @MainActor
  private func addLog(_ string: String, level: Level) async {
    let instance = Instance(message: string, date: Date(), level: level)
    
    logs.append(instance)
    
    lastLogOfLevel[level] = instance
    
    Level.allCases
      .filter { $0 <= level }
      .forEach { lastLogOfLevelOrHigher[$0] = instance }
  }
  
  nonisolated func log<T: StringProtocol>(_ string: T, level: Level) {
    Task {
      await addLog(String(string), level: level)
    }
  }
  
  nonisolated func debug<T: StringProtocol>(_ string: T) {
    log(string, level: .debug)
  }
  
  nonisolated func info<T: StringProtocol>(_ string: T) {
    log(string, level: .info)
  }
  
  nonisolated func warning<T: StringProtocol>(_ string: T) {
    log(string, level: .warning)
  }
  
  nonisolated func error<T: StringProtocol>(_ string: T) {
    log(string, level: .error)
  }
}

// MARK: - Try or Log
extension Logger {
  nonisolated func tryOrLog(
    level: Level,
    code: () throws -> (),
    errorString: (Error) -> String = { "\($0)" }
  ) {
    do {
      try code()
    } catch {
      log(errorString(error), level: level)
    }
  }
  
  nonisolated func tryOrDebug(
    code: () throws -> (),
    errorString: (Error) -> String = { "\($0)" }
  ) {
    tryOrLog(level: .debug, code: code, errorString: errorString)
  }
  
  nonisolated func tryOrInfo(
    code: () throws -> (),
    errorString: (Error) -> String = { "\($0)" }
  ) {
    tryOrLog(level: .info, code: code, errorString: errorString)
  }
  
  nonisolated func tryOrWarning(
    code: () throws -> (),
    errorString: (Error) -> String = { "\($0)" }
  ) {
    tryOrLog(level: .warning, code: code, errorString: errorString)
  }
  
  nonisolated func tryOrError(
    code: () throws -> (),
    errorString: (Error) -> String = { "\($0)" }
  ) {
    tryOrLog(level: .error, code: code, errorString: errorString)
  }
  
  nonisolated func tryOrLog(
    level: Level,
    code: () async throws -> (),
    errorString: (Error) -> String = { "\($0)" }
  ) async {
    do {
      try await code()
    } catch {
      log(errorString(error), level: level)
    }
  }
  
  nonisolated func tryOrDebug(
    code: () async throws -> (),
    errorString: (Error) -> String = { "\($0)" }
  ) async {
    await tryOrLog(level: .debug, code: code, errorString: errorString)
  }
  
  nonisolated func tryOrInfo(
    code: () async throws -> (),
    errorString: (Error) -> String = { "\($0)" }
  ) async {
    await tryOrLog(level: .info, code: code, errorString: errorString)
  }
  
  nonisolated func tryOrWarning(
    code: () async throws -> (),
    errorString: (Error) -> String = { "\($0)" }
  ) async {
    await tryOrLog(level: .warning, code: code, errorString: errorString)
  }
  
  nonisolated func tryOrError(
    code: () async throws -> (),
    errorString: (Error) -> String = { "\($0)" }
  ) async {
    await tryOrLog(level: .error, code: code, errorString: errorString)
  }
}

let logger = Logger()

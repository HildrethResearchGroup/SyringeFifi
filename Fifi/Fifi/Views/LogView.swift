//
//  LogView.swift
//  LogView
//
//  Created by Connor Barnes on 7/21/21.
//

import SwiftUI

struct LogView: View {
  @ObservedObject private var logger = Fifi.logger
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm:ss.SSSZ"
    
    return formatter
  }()
  
  var body: some View {
    Table(logger.logs.reversed()) {
      TableColumn("Level") { (instance: Logger.Instance) in
        HStack {
          Spacer()
          instance.icon
            .font(.body.bold())
          Spacer()
        }
      }
      .width(36)
      
      TableColumn("Time") { (instance: Logger.Instance) in
        Text(dateFormatter.string(from: instance.date))
      }
      .width(150)
      
      TableColumn("Message", value: \.message)
        
    }
    .font(SwiftUI.Font.system(.body, design: .monospaced))
  }
}

struct LogView_Previews: PreviewProvider {
  static var previews: some View {
    LogView()
  }
}

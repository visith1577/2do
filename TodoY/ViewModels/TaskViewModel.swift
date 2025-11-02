//
//  TaskViewModel.swift
//  TodoY
//
//  Created by visith kumarapperuma on 2025-11-02.
//

import Foundation
import SwiftUI

extension Item {
    var ugencyColor: Color {
        guard let deadline = detail?.deadline else { return .gray }
        let now = Date()
        
        if deadline < now {
            return .red
        } else if deadline.timeIntervalSince(now) < 48 * 60 * 60 {
            return .orange
        } else {
            return .green
        }
    }
}

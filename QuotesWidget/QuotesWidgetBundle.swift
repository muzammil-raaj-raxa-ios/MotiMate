//
//  QuotesWidgetBundle.swift
//  QuotesWidget
//
//  Created by MacBook Pro on 16/04/2025.
//

import WidgetKit
import SwiftUI

@main
struct QuotesWidgetBundle: WidgetBundle {
    var body: some Widget {
        QuotesWidget()
        QuotesWidgetLiveActivity()
    }
}

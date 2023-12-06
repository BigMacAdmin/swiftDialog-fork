//
//  InfoBoxView.swift
//  dialog
//
//  Created by Bart Reardon on 2/1/2023.
//

import SwiftUI
import MarkdownUI

struct InfoBoxView: View {

    @ObservedObject var observedData: DialogUpdatableContent

    //var markdownStyle = MarkdownStyle(foregroundColor: .secondary)

    init(observedData: DialogUpdatableContent) {
        self.observedData = observedData
        writeLog("Displaying InfoBox")
    }

    var body: some View {
        Markdown(observedData.args.infoBox.value, baseURL: URL(string: "http://"))
            .multilineTextAlignment(.leading)
            .markdownTextStyle {
                ForegroundColor(.secondary)
            }
            .focusable(false)
            .lineLimit(nil)
    }
}



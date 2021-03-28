//
//  DialogView.swift
//  dialog
//
//  Created by Bart Reardon on 9/3/21.
//
// Center portion of the dialog window consisting of icon/image if optioned and message content

import Foundation
import SwiftUI
import AppKit

struct DialogView: View {
    init() {
        if appvars.iconIsHidden {
            appvars.imageWidth = 0
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/) {
            let iconFrameWidth: CGFloat = appvars.imageWidth
            let iconFrameHeight: CGFloat = appvars.imageHeight
            HStack {
                if (!appvars.iconIsHidden) {
                    VStack {
                            IconView()
                    }.frame(width: iconFrameWidth, height: iconFrameHeight, alignment: .top)
                    .offset(x: -40)
                }
                
                VStack(alignment: .center) {
                    //TitleView()
                    MessageContent()
                        
                }
            }
            
        }
    }
}

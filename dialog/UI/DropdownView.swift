//
//  DropdownView.swift
//  Dialog
//
//  Created by Reardon, Bart  on 2/6/21.
//

import Foundation
import SwiftUI
import Combine


struct DropdownView: View {
    
    @ObservedObject var observedData : DialogUpdatableContent
    @State var selectedOption : [String]
    //@State private var showingSheet = false

    var fieldwidth: CGFloat = 0
    
    init(observedDialogContent : DialogUpdatableContent) {
        self.observedData = observedDialogContent
        
        if !observedDialogContent.args.hideIcon.present { 
            fieldwidth = string2float(string: observedDialogContent.args.windowWidth.value)
        } else {
            fieldwidth = string2float(string: observedDialogContent.args.windowWidth.value) - string2float(string: observedDialogContent.args.iconSize.value)
        }
                
        var defaultOptions : [String] = []
        for i in 0..<observedDialogContent.appProperties.dropdownItems.count {
            defaultOptions.append(observedDialogContent.appProperties.dropdownItems[i].defaultValue)
        }
        _selectedOption = State(initialValue: defaultOptions)
    }
        
    var body: some View {
        if observedData.args.dropdownValues.present {
            VStack {
                ForEach(0..<observedData.appProperties.dropdownItems.count, id: \.self) {index in
                    HStack {
                        // we could print the title as part of the picker control but then we don't get easy access to swiftui text formatting
                        // so we print it seperatly and use a blank value in the picker
                        Text(observedData.appProperties.dropdownItems[index].title + (observedData.appProperties.dropdownItems[index].required ? " *":""))
                            //.bold()
                            .frame(idealWidth: fieldwidth*0.20, alignment: .leading)
                        Spacer()
                        Picker("", selection: $observedData.appProperties.dropdownItems[index].selectedValue)
                        {
                            if observedData.appProperties.dropdownItems[index].defaultValue.isEmpty {
                                // prevents "Picker: the selection "" is invalid and does not have an associated tag" errors on stdout
                                // this does mean we are creating a blank selection but it will still be index -1
                                // previous indexing schemes (first entry being index 0 etc) should still apply.
                                Text("").tag("")
                            }
                            ForEach(observedData.appProperties.dropdownItems[index].values, id: \.self) {
                                if $0.hasPrefix("---") {
                                    Divider()
                                } else {
                                    Text($0).tag($0)
                                        .font(.system(size: observedData.appProperties.labelFontSize))
                                }
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(idealWidth: fieldwidth*0.50, maxWidth: 350, alignment: .trailing)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                                    .stroke(observedData.appProperties.dropdownItems[index].requiredfieldHighlight, lineWidth: 2)
                                    .animation(
                                        .easeIn(duration: 0.2)
                                        .repeatCount(3, autoreverses: true)
                                    )
                                 )
                    }
                }
            }
            .font(.system(size: observedData.appProperties.labelFontSize))
            .padding(10)
            .background(Color.background.opacity(0.5))
            .cornerRadius(8)
        
        }
    }
}

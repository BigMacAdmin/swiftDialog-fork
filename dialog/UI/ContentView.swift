//
//  ContentView.swift
//  dialog
//
//  Created by Bart Reardon on 9/3/21.
//

import SwiftUI

struct ContentView: View {
    init() {
        //appvars.windowHeight = appvars.windowHeight + 200
        if CLOptionPresent(OptionName: CLOptions.bannerImage) {
            if CLOptionPresent(OptionName: CLOptions.smallWindow) {
                appvars.bannerHeight = 100
                bannerAdjustment = 10
            } else {
                appvars.bannerHeight = 150
            }
            appvars.bannerOffset = -30
            bannerImagePresent = true
            appvars.imageWidth = 0 // hides the side icon
        }
        appvars.debugBorderColour = Color.clear
    }
    
    var bannerImagePresent = false
    var bannerAdjustment       = CGFloat(5)
    
    var body: some View {
        VStack {
            if bannerImagePresent {
            HStack {
                BannerImageView()
                    .frame(width: appvars.windowWidth, height: appvars.bannerHeight-bannerAdjustment, alignment: .topLeading)
                    //.border(Color.green)
                    .clipped()
            }
            .offset(y: appvars.bannerOffset)
            }
            // Dialog title
            HStack(alignment: .top){
                TitleView()
                    .frame(width: appvars.windowWidth , height: appvars.titleHeight)
            }
            .border(appvars.debugBorderColour) //debuging
            
            // Horozontal Line
            HStack{
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 1)
            }
            .frame(width: (appvars.windowWidth * appvars.horozontalLineScale))
            .offset(y: -20)
            .border(appvars.debugBorderColour) //debuging
            
            // Dialog content including message and image if visible
            HStack(alignment: .top) {
                DialogView()
                    .frame(width: (appvars.windowWidth-30), height: (appvars.windowHeight * appvars.dialogContentScale * appvars.scaleFactor))
                    //.border(Color.green)
            }.frame(alignment: .topLeading)
            .border(appvars.debugBorderColour) //debuging
            //.border(Color.red) //debuging

            
            // Buttons
            Spacer() // force button to the bottom
            //Divider()
            HStack() {
                if (CLOptionPresent(OptionName: CLOptions.buttonInfoTextOption) || CLOptionPresent(OptionName: CLOptions.infoButtonOption)) {
                    MoreInfoButton()
                }
                Spacer()
                ButtonView()
                    //.frame(alignment: .bottom)
            }
            .frame(width: appvars.windowWidth-30, alignment: .bottom)
            .border(appvars.debugBorderColour) //debuging
        }
        //.frame(width: appvars.windowWidth, height: appvars.windowHeight-10)
        //.border(Color.purple) //debuging
            
        // Window Setings (pinched from Nudge https://github.com/macadmins/nudge/blob/main/Nudge/UI/ContentView.swift#L19)
        HostingWindowFinder {window in
            window?.standardWindowButton(.closeButton)?.isHidden = true //hides the red close button
            window?.standardWindowButton(.miniaturizeButton)?.isHidden = true //hides the yellow miniaturize button
            window?.standardWindowButton(.zoomButton)?.isHidden = true //this removes the green zoom button
            window?.center() // center
            window?.isMovable = appvars.windowIsMoveable
            if appvars.windowOnTop {
                window?.level = .floating
            } else {
                window?.level = .normal
            }
            
            NSApp.activate(ignoringOtherApps: true) // bring to forefront upon launch
        }
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HostingWindowFinder: NSViewRepresentable {
    var callback: (NSWindow?) -> ()

    func makeNSView(context: Self.Context) -> NSView {
        let view = NSView()
        
        // process command line options that just display info and exit before we show the main window
        if (CLOptionPresent(OptionName: CLOptions.helpOption) || CommandLine.arguments.count == 1) {
            print(helpText)
            quitDialog(exitCode: 0)
            //exit(0)
        }
        if CLOptionPresent(OptionName: CLOptions.getVersion) {
            printVersionString()
            quitDialog(exitCode: 0)
            //exit(0)
        }
        if CLOptionPresent(OptionName: CLOptions.showLicense) {
            print(licenseText)
            quitDialog(exitCode: 0)
            //exit(0)
        }
        if CLOptionPresent(OptionName: CLOptions.buyCoffee) {
            //I'm a teapot
            print("If you like this app and want to buy me a coffee https://www.buymeacoffee.com/bartreardon")
            quitDialog(exitCode: 418)
            //exit(418)
        }
        
        if CLOptionPresent(OptionName: CLOptions.hideIcon) {
            appvars.iconIsHidden = true
        //} else {
        //    iconVisible = true
        }
        
        if CLOptionPresent(OptionName: CLOptions.lockWindow) {
            appvars.windowIsMoveable = true
        }
        
        if CLOptionPresent(OptionName: CLOptions.forceOnTop) {
            appvars.windowOnTop = true
        }
                
        //----------
        
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

//
//  PhotoPickerUtility.swift
//  PVPickNCrop
//
//  Created by Dave Glassco on 12/14/20.
//

import Foundation
import UIKit
import SwiftUI

public enum PickProfileSteps {
    case main
    case utility
}

public struct PhotoPickerUtility: View {
    
    @Binding var currentStep: PickProfileSteps
    @State var showImagePicker: Bool
    
    @State var displayImage: Image?
    @State var selectedImage: UIImage?
    @Binding var returnedImage: UIImage?
    
    //Zoom and Drag ...
    @State var currentAmount: CGFloat = 0
    @State var finalAmount: CGFloat = 1
    
    @State var currentPosition: CGSize = .zero
    @State var newPosition: CGSize = .zero
    
    ///Testing stuff
    var showFeedback = false
    @State var inputW: CGFloat = 750.5556577
    @State var inputH: CGFloat = 1336.5556577
    @State var theAspectRatio: CGFloat = 0.0
    
    @State var zoom: CGFloat = 1.00
    @State var profileW: CGFloat = 0.0
    @State var profileH: CGFloat = 0.0
    @State var horizontalOffset: CGFloat = 0.0
    @State var verticalOffset: CGFloat = 0.0
    
    //Local Vars
    @State var firstLaunch = true
    let inset: CGFloat = 15
    let screenAspect = UIScreen.main.bounds.width / UIScreen.main.bounds.height
    let aniDuration = 0.2
    
    @State var newTest: Int = 1
    
    public init(returnedImage: Binding<UIImage?>, step: Binding<PickProfileSteps>, showPicker: Bool) {
        self._returnedImage = returnedImage
        self._currentStep = step
        self._showImagePicker = State(initialValue: false) 
    }
    
    func pickerActived() {
        returnedImage = nil
        displayImage = nil
        selectedImage = nil
        showImagePicker = true
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.8)
            
            //Profile Image
            VStack {
                if displayImage != nil {
                    displayImage?
                        .resizable()
                        .scaleEffect(finalAmount + currentAmount)
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .offset(x: self.currentPosition.width, y: self.currentPosition.height)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                }
            }
            
            
            //Image Mask
            if displayImage != nil {
                Rectangle()
                    .fill(Color.black).opacity(0.55)
                    .mask(HoleShapeMask().fill(style: FillStyle(eoFill: true)))
            }
            
            VStack {
                Text("Move and Scale")
                    .foregroundColor(.white)
                
                if showFeedback {
                    LiveFeedbackAndImageView(finalAmount: $finalAmount , inputW: $inputW, inputH: $inputH, profileW: $profileW, profileH: $profileH, newPosition: $newPosition)
                }
                
                Spacer()
                HStack{
                    //Bottom Buttons
                    BottomButtonsView(step: $currentStep, inputImage: $selectedImage, pickerActivated: pickerActived, saveFunction: saveCroppedImage)
                }
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
        .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
            SystemImagePicker(test: self.$newTest, image: self.$selectedImage)
                .accentColor(Color.systemOrange)
        }
        .gesture(
            MagnificationGesture()
                .onChanged { amount in
                    self.currentAmount = amount - 1
                    //                    repositionImage()
                }
                .onEnded { amount in
                    self.finalAmount += self.currentAmount
                    self.currentAmount = 0
                    repositionImage()
                }
        )
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                    //                    repositionImage()
                }
                .onEnded { value in
                    self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                    self.newPosition = self.currentPosition
                    repositionImage()
                }
        )
        .simultaneousGesture(
            TapGesture(count: 2)
                .onEnded({
                    resetImageOriginAndScale()
                    //                    setCroppedImage()
                })
        )
    }
}



struct ContactPhotoSelectionSheet_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerUtility(returnedImage: .constant(nil), step: .constant(.main), showPicker: false)
    }

}






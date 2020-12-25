//
//  ProfilePickerExtensions.swift
//  PVPickNCrop
//
//  Created by Dave Glassco on 12/17/20.
//  Evolved from the great work of Poltavets
//  https://stackoverflow.com/questions/28365819/ios-custom-uiimagepickercontroller-camera-crop-to-circle-in-preview-view/65278767#65278767
//


import Foundation
import SwiftUI

extension PhotoPickerUtility {
    
    //MARK: functions
    func loadImage() {
        guard let inputImage = selectedImage else { return }
        let w = inputImage.size.width
        let h = inputImage.size.height
        displayImage = Image(uiImage: inputImage)
        
//        inputW = w//.description
//        inputH = h//.description
        selectedAspectRatio = w / h
        
        resetImageOriginAndScale()
    }
    
    func resetImageOriginAndScale() {
        
        withAnimation(.easeInOut){
            if selectedAspectRatio > screenAspect {
                displayW = UIScreen.main.bounds.width
                displayH = displayW / selectedAspectRatio
            } else {
                displayH = UIScreen.main.bounds.height
                displayW = displayH * selectedAspectRatio
            }
            currentAmount = 0
            finalAmount = 1
            currentPosition = .zero
            newPosition = .zero
            
        }
    }
    
    func HoleShapeMask() -> Path {
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let insetRect = CGRect(x: inset, y: inset, width: UIScreen.main.bounds.width - ( inset * 2 ), height: UIScreen.main.bounds.height - ( inset * 2 ))
        var shape = Rectangle().path(in: rect)
        shape.addPath(Circle().path(in: insetRect))
        return shape
    }
    
    
    func repositionImage() {
        
        //Screen width
        let w = UIScreen.main.bounds.width
        
        if selectedAspectRatio > screenAspect {
            displayW = UIScreen.main.bounds.width * finalAmount
            displayH = displayW / selectedAspectRatio
        } else {
            displayH = UIScreen.main.bounds.height * finalAmount
            displayW = displayH * selectedAspectRatio
        }
        
        //Screen width * zoom - the screen width / 2
        //shows us how much of the picture now extends t pothe left of the screen.
        horizontalOffset = (displayW - w ) / 2
        verticalOffset = ( displayH - w ) / 2
        
        if finalAmount > 4.0 {
            withAnimation{
                finalAmount = 4.0
            }
        }
        
        if displayW >= UIScreen.main.bounds.width {
            
            if newPosition.width > horizontalOffset {
                withAnimation(.easeInOut) {
                    newPosition = CGSize(width: horizontalOffset + inset, height: newPosition.height)
                    currentPosition = CGSize(width: horizontalOffset + inset, height: currentPosition.height)
                }
            }
            
            if newPosition.width < ( horizontalOffset * -1) {
                withAnimation(.easeInOut){
                    newPosition = CGSize(width: ( horizontalOffset * -1) - inset, height: newPosition.height)
                    currentPosition = CGSize(width: ( horizontalOffset * -1 - inset), height: currentPosition.height)
                }
            }
        } else {
            
            withAnimation(.easeInOut) {
                newPosition = CGSize(width: 0, height: newPosition.height)
                currentPosition = CGSize(width: 0, height: newPosition.height)
            }
        }
        
        if displayH >= UIScreen.main.bounds.width {
            
            if newPosition.height > verticalOffset {
                withAnimation(.easeInOut){
                    newPosition = CGSize(width: newPosition.width, height: verticalOffset + inset)
                    currentPosition = CGSize(width: newPosition.width, height: verticalOffset + inset)
                }
            }
            
            if newPosition.height < ( verticalOffset * -1) {
                withAnimation(.easeInOut){
                    newPosition = CGSize(width: newPosition.width, height: ( verticalOffset * -1) - inset)
                    currentPosition = CGSize(width: newPosition.width, height: ( verticalOffset * -1) - inset)
                }
            }
        } else {
            
            withAnimation (.easeInOut){
                newPosition = CGSize(width: newPosition.width, height: 0)
                currentPosition = CGSize(width: newPosition.width, height: 0)
            }
        }
        
        if displayW < UIScreen.main.bounds.width && selectedAspectRatio > screenAspect {
            resetImageOriginAndScale()
        }
        if displayH < UIScreen.main.bounds.height && selectedAspectRatio < screenAspect {
            resetImageOriginAndScale()
        }
    }

    func saveCroppedImage(_ completion: () -> Void) {
        let scale = (selectedImage?.size.width)! / displayW
        let xPos = ( ( ( displayW - UIScreen.main.bounds.width ) / 2 ) + inset + ( currentPosition.width * -1 ) ) * scale
        let yPos = ( ( ( displayH - UIScreen.main.bounds.width ) / 2 ) + inset + ( currentPosition.height * -1 ) ) * scale
        let radius = ( UIScreen.main.bounds.width - inset * 2 ) * scale
        
        processedImage = imageWithImage(image: selectedImage!, croppedTo: CGRect(x: xPos, y: yPos, width: radius, height: radius))
        
        completion()
        
        ///Debug maths
//        print("Input: w \(inputW) h \(inputH)")
//        print("Profile: w \(profileW) h \(profileH)")
//        print("X Origin: \( ( ( profileW - UIScreen.main.bounds.width - inset ) / 2 ) + ( currentPosition.width  * -1 ) )")
//        print("Y Origin: \( ( ( profileH - UIScreen.main.bounds.width - inset) / 2 ) + ( currentPosition.height  * -1 ) )")
//        
//        print("Scale: \(scale)")
//        print("Profile:\(profileW) + \(profileH)" )
//        print("Curent Pos: \(currentPosition.debugDescription)")
//        print("Radius: \(radius)")
//        print("x:\(xPos), y:\(yPos)")
    }
}

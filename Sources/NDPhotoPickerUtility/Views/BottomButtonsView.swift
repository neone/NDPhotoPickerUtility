//
//  BottomButtonsView.swift
//  PVPickNCrop
//
//  Created by Dave Glassco on 12/17/20.
//

import SwiftUI

struct BottomButtonsView: View {
    @Binding var step: PickProfileSteps
    @Binding var inputImage: UIImage?
//    @Binding var displayImage: Image?
//    @Binding var isShowingImagePicker: Bool
    
    
    var pickerActivated: () -> Void
    var saveFunction: () -> Void
    
    
    var body: some View {
        HStack {
            Button(
                action: {
                    step = .main
                },
                label: { Text("Cancel") })
            Spacer()
            
            Button(action: {
                inputImage = nil
                pickerActivated()
            }, label: {
                ShowPhotoPickerButton()
            })
            
            Spacer()
            Button(
                action: {
                    if inputImage != nil {
                        saveFunction()
                        step = .main
                    }
                },
                label: { Text("Save") })
        }
        .padding(.horizontal)
        .foregroundColor(.white)
    }
}

struct BottomButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        BottomButtonsView(step: .constant(.main), inputImage: .constant(nil), pickerActivated: {}, saveFunction: {})
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(Color(.darkGray))
                .environment(\.colorScheme, .dark)
    }
}

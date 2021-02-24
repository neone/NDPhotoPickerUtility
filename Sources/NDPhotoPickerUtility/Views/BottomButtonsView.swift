//
//  BottomButtonsView.swift
//  PVPickNCrop
//
//  Created by Dave Glassco on 12/17/20.
//

import SwiftUI

struct BottomButtonsView: View {
    @Binding var step: PhotoPickerUtilityStep
    @Binding var selectedImage: UIImage?
    
    var pickerActivated: () -> Void
    var saveFunction: () -> Void
    var cancelFunction: () -> Void

    var body: some View {
        HStack {
            Button(
                action: {
                    cancelFunction()
                    step = .main
                },
                label: { Text("Cancel") })
            Spacer()
            
            Button(action: {
                pickerActivated()
            }, label: {
                ShowPhotoPickerButton()
            })
            
            Spacer()
            Button(
                action: {
                    if selectedImage != nil {
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
        BottomButtonsView(step: .constant(.main), selectedImage: .constant(nil), pickerActivated: {}, saveFunction: {})
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(Color(.darkGray))
                .environment(\.colorScheme, .dark)
    }
}

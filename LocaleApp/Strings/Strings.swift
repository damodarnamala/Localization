//
//  Strings.swift
//  Locale
//
//  Created by Damodar Namala on 08/06/24.
//

import Foundation
struct StringConfiguration {
    let common = Common()
}

extension StringConfiguration {
    struct SegmnetActions {
        let segmentUpdateTitle = String(localized: "segment.title.updateKey")
        let segmentDeleteTitle = String(localized: "segment.title.deleteKey")
        let segmentAddNewKeyTitle = String(localized: "segment.title.addNewKey")
    }
    
    struct InputPlaceholderStrings {
        let addKeyPlaceholderText = String(localized: "input.placeholder.enterKey")
        let addValuePlaceholderText = String(localized: "input.placeholder.enterValue")
        let updateKeyPlaceholderText = String(localized: "input.placeholder.updateKey")
        let updateValuePlaceholderText = String(localized: "input.placeholder.updateValue")
        let deleteKeyPlaceholderText = String(localized: "input.placeholder.deleteKey")
    }
    
    struct ButtonActionTitles {
        let updateActionButtonTitle = String(localized: "button.title.update")
        let deleteActionButtonTitle = String(localized: "button.title.delete")
        let addActionButtonTitle = String(localized: "button.title.add")
        let selectFolder = String(localized: "common.string.select.folder")
        let sortButtonTitle = String(localized: "button.title.sort")
    }
    
    struct Common {
        var segment = SegmnetActions()
        var placeholder = InputPlaceholderStrings()
        var buttonTile = ButtonActionTitles()
    }
    
    struct FileOperationErrorString {
        let fileNotFound = ""
    }

}




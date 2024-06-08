//
//  NSTextField+ext.swift
//  LocaleApp
//
//  Created by Damodar Namala on 08/06/24.
//

import AppKit
import Combine
import Foundation

extension NSTextField {
    func textPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: NSTextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? NSTextField)?.stringValue }
            .eraseToAnyPublisher()
    }
}

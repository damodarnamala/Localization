//
//  FileManagerHandler.swift
//  LocaleApp
//
//  Created by Damodar Namala on 08/06/24.
//

import Foundation
import Combine

final class FileManagerHelper {
    private let fileManager = FileManager.default

    func appendToFile(filePath: String, content: String) -> AnyPublisher<Void, FileOperationError> {
        do {
            let fileHandle = try FileHandle(forWritingTo: URL(fileURLWithPath: filePath))
            fileHandle.seekToEndOfFile()
            fileHandle.write(content.data(using: .utf8)!)
            fileHandle.closeFile()
            return Empty().eraseToAnyPublisher()
        } catch {
            return Fail(error: .writeError).eraseToAnyPublisher()
        }
    }

    func deleteKey(key: String, filePath: String) -> AnyPublisher<Void, FileOperationError> {
        do {
            let content = try String(contentsOfFile: filePath)
            let regex = try NSRegularExpression(pattern: "\"\(key)\"\\s*=\\s*\"(.*?)\";", options: .caseInsensitive)
            let range = NSRange(location: 0, length: content.utf16.count)
            let modifiedContent = regex.stringByReplacingMatches(in: content, options: [], range: range, withTemplate: "")
            try modifiedContent.write(toFile: filePath, atomically: true, encoding: .utf8)
            return Just(()).setFailureType(to: FileOperationError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: .fileOperationError).eraseToAnyPublisher()
        }
    }

    func sort(filePath: String) -> AnyPublisher<Void, FileOperationError> {
        do {
            var content = try String(contentsOfFile: filePath)
            var lines = content.components(separatedBy: .newlines)
            lines = lines.filter { !$0.isEmpty }
            lines.sort { line1, line2 in
                guard let key1 = line1.components(separatedBy: "=").first?.trimmingCharacters(in: .whitespaces),
                      let key2 = line2.components(separatedBy: "=").first?.trimmingCharacters(in: .whitespaces) else {
                    return false
                }
                return key1.localizedStandardCompare(key2) == .orderedAscending
            }
            content = lines.joined(separator: "\n")
            try content.write(toFile: filePath, atomically: true, encoding: .utf8)
            return Just(()).setFailureType(to: FileOperationError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: .fileOperationError).eraseToAnyPublisher()
        }
    }

    func updateValue(key: String, value: String, filePath: String) -> AnyPublisher<Void, FileOperationError> {
        do {
            var content = try String(contentsOfFile: filePath)
            let pattern = "\"\(key)\"\\s*=\\s*\"(.*?)\";"
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: content.utf16.count)
            if let match = regex.firstMatch(in: content, options: [], range: range) {
                let range = match.range(at: 1)
                if let range = Range(range, in: content) {
                    content.replaceSubrange(range, with: value)
                }
            } else {
                print("Key '\(key)' not found in file: \(filePath)")
                return Fail(error: .writeError).eraseToAnyPublisher()
            }
            try content.write(toFile: filePath, atomically: true, encoding: .utf8)
            return Just(()).setFailureType(to: FileOperationError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: .fileOperationError).eraseToAnyPublisher()
        }
    }
    
    func localizableStringsFilePaths(inParentFolder parentFolder: String) -> [String] {
        var filePaths: [String] = []
        let fileManager = FileManager.default
        
        guard let enumerator = fileManager.enumerator(atPath: parentFolder) else {
            return filePaths
        }
        
        for case let folderPath as String in enumerator {
            if folderPath.hasSuffix(".lproj") {
                let localizablePath = (parentFolder as NSString).appendingPathComponent(folderPath)
                let localizableStringsPath = (localizablePath as NSString).appendingPathComponent("Localizable.strings")
                if fileManager.fileExists(atPath: localizableStringsPath) {
                    filePaths.append(localizableStringsPath)
                }
            }
        }
        
        return filePaths
    }
}

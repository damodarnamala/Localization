import Cocoa
import SnapKit
import Combine

// MARK: - ViewModel Protocol

protocol LocaleViewModelProtocol {
    var keyText: String { get set }
    var valueText: String { get set }
    var pathSelectionSubject: CurrentValueSubject<Bool, Never> { get }
    func checkPathSaved() -> Bool
    func selectPath()
    func addKeyValue() -> AnyPublisher<Void, FileOperationError>
    func deleteKey() -> AnyPublisher<Void, FileOperationError>
    func sort() -> AnyPublisher<Void, FileOperationError>
    func updateValue() -> AnyPublisher<Void, FileOperationError>
    var selectedSegment: LocaleFormType {get set}
}

// MARK: - ViewModel Implementation

final class LocaleViewModel: LocaleViewModelProtocol {
    var keyText = ""
    var valueText = ""
    var pathSelectionSubject = CurrentValueSubject<Bool, Never>(false)
    var selectedSegment: LocaleFormType  = .add
    
    private var filePath: String?
    private var bag = Set<AnyCancellable>()
    private let defaults = UserDefaults.standard
    private let fileManager = FileManager.default
    private let fileManagerHelper = FileManagerHelper()
    
    func checkPathSaved() -> Bool {
        return defaults.bool(forKey: "isPathSelected")
    }
    
    func selectPath() {
        let dialog = NSOpenPanel()
        dialog.showsResizeIndicator = true
        dialog.canChooseDirectories = true
        dialog.allowsMultipleSelection = false
        
        if dialog.runModal() == .OK, let result = dialog.url {
            filePath = result.path
            pathSelectionSubject.send(true)
        }
    }
    
    private func checkFilePath() -> AnyPublisher<String, FileOperationError> {
        guard let folderPath = filePath else {
            return Fail(error: .fileNotFound).eraseToAnyPublisher()
        }
        return Just(folderPath).setFailureType(to: FileOperationError.self).eraseToAnyPublisher()
    }
    
    func addKeyValue() -> AnyPublisher<Void, FileOperationError> {
        return validateInputs()
            .flatMap { self.checkFilePath() }
            .flatMap { folderPath in
                let filePaths = self.fileManagerHelper.localizableStringsFilePaths(inParentFolder: folderPath)
                let publishers = filePaths.map { filePath in
                    self.appendKeyValueToFile(filePath: filePath, key: self.keyText, value: self.valueText)
                }
                return Publishers.MergeMany(publishers).collect().map { _ in
                }.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func appendKeyValueToFile(filePath: String, key: String, value: String) -> AnyPublisher<Void, FileOperationError> {
        let content = "\"\(key)\" = \"\(value)\";\n"
        return self.fileManagerHelper.appendToFile(filePath: filePath, content: content)
    }
    
    func deleteKey() -> AnyPublisher<Void, FileOperationError> {
        return validateInputs()
            .flatMap { self.checkFilePath() }
            .flatMap { folderPath in
                let filePaths = self.fileManagerHelper.localizableStringsFilePaths(inParentFolder: folderPath)
                let publishers = filePaths.map { filePath in
                    self.fileManagerHelper.deleteKey(key: self.keyText, filePath: filePath)
                }
                return Publishers.MergeMany(publishers).collect().map { _ in
                }.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func updateValue() -> AnyPublisher<Void, FileOperationError> {
        return validateInputs()
            .flatMap { self.checkFilePath() }
            .flatMap { folderPath in
                let filePaths = self.fileManagerHelper.localizableStringsFilePaths(inParentFolder: folderPath)
                let publishers = filePaths.map { filePath in
                    self.fileManagerHelper.updateValue(key: self.keyText, value: self.valueText, filePath: filePath)                }
                return Publishers.MergeMany(publishers).collect().map { _ in }.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func sort() -> AnyPublisher<Void, FileOperationError> {
        return checkFilePath()
            .flatMap { folderPath in
                let filePaths = self.fileManagerHelper.localizableStringsFilePaths(inParentFolder: folderPath)
                let publishers = filePaths.map { filePath in
                    self.fileManagerHelper.sort(filePath: filePath)
                }
                return Publishers.MergeMany(publishers).collect().map { _ in }.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}


extension LocaleViewModel {
    private func validateInputs() -> AnyPublisher<Void, FileOperationError> {
        guard !keyText.isEmpty, !valueText.isEmpty, keyText.count >= 2, valueText.count >= 2 else {
            if keyText.isEmpty {
                return .just(.inputError(.keyEmpty))
            } else if valueText.isEmpty {
                return .just(.inputError(.valueEmpty))
            } else if keyText.count < 2 {
                return .just(.inputError(.keyNotVallid))
            } else {
                return .just(.inputError(.valueEmpty))
            }
        }
        return Just(())
            .setFailureType(to: FileOperationError.self)
            .eraseToAnyPublisher()
    }
}

extension Publisher where Failure == FileOperationError, Output == Void {
    static func just(_ error: FileOperationError) -> AnyPublisher<Void, FileOperationError> {
        return Fail(error: error).eraseToAnyPublisher()
    }
}

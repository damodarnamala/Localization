import Foundation

enum FileOperationError: Error {
    case fileNotFound
    case encodingError
    case writeError
    case regexError
    case readError
    case decodingError
    case fileOperationError
    case unknownError
    case inputError(InputError)
    
    enum InputError {
        case keyEmpty
        case valueEmpty
        case keyNotVallid
        case valueNotValid
    }
    
    var errorMessage: (title: String, description: String, suggestion: String) {
        switch self {
        case .fileNotFound:
            return (
                title: "File Not Found",
                description: "The specified file could not be found. Please check the file path and ensure the file exists.",
                suggestion: "Please select a valid file and try again."
            )
        case .readError:
            return (
                title: "Read Error",
                description: "An error occurred while reading the file. This could be due to file permissions, corruption, or other issues.",
                suggestion: "Please check the file path and try again"
            )
        case .writeError:
            return (
                title: "Write Error",
                description: "An error occurred while writing to the file. This may be caused by insufficient disk space, permissions issues, or file system errors.",
                suggestion: "Please check the file permissions and try again."
            )
        case .encodingError:
            return (
                title: "Encoding Error",
                description: "Failed to encode the content. This usually happens when converting strings to data.",
                suggestion:"Please ensure the content is properly formatted and try again."
            )
        case .decodingError:
            return (
                title: "Decoding Error",
                description: "Failed to decode the content. This typically occurs when converting data back into the expected format, such as JSON decoding.",
                suggestion: "Please ensure the file content is in the correct format."
            )
        case .regexError:
            return (
                title: "Regex Error",
                description: "An error occurred while processing the regular expression. This could be due to an invalid pattern or a matching error.",
                suggestion: "Please check the regular expression syntax."
            )
        case .fileOperationError:
            return (
                title: "File Operation Error",
                description: "An unspecified file operation error occurred. Please try again.",
                suggestion: "Please try the operation again."
            )
        case .unknownError:
            return (
                title: "Unknown Error",
                description: "An unknown error occurred. Please try again later.",
                suggestion: "Please try again later."
            )
            
        case .inputError(let error):
            switch error {
            case .keyEmpty:
                return (
                    title: "Key Empty",
                    description: "The key field cannot be empty. Please provide a valid key.",
                    suggestion: "Please enter a valid key and try again."
                )
                
            case .valueEmpty:
                return (
                    title: "Value Empty",
                    description: "The value field cannot be empty. Please provide a valid value.",
                    suggestion: "Please enter a valid value and try again."
                )
                
            case .keyNotVallid:
                return (
                    title: "Invalid Key",
                    description: "The provided key is not valid. Please ensure it contains at least two characters.",
                    suggestion: "Please enter a valid key with at least two characters and try again."
                )
                
            case .valueNotValid:
                return (
                    title: "Invalid Value",
                    description: "The provided value is not valid. Please ensure it contains at least two characters.",
                    suggestion: "Please enter a valid value with at least two characters and try again."
                )
            }
        }
    }
}

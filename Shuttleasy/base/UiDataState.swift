//
//  UiDataState.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 3.12.2022.
//

import Foundation

enum UiDataState<T> {
    
    case Loading
    case Success(DataContent<T>)
    case Error(String)
    case Initial
    
    static func getDefaultCase() -> UiDataState {
        return UiDataState.Initial
    }

    // is Success 
    func isSuccess() -> Bool {
        switch self {
        case .Success:
            return true
        default:
            return false
        }
    }

    // data content or nil
    func getDataContent() -> DataContent<T>? {
        switch self {
        case .Success(let dataContent):
            return dataContent
        default:
            return nil
        }
    }

    // onSuccess 
    func onSuccess(onSuccess: (DataContent<T>) -> Void) -> UiDataState {
        switch self {
        case .Success(let dataContent):
            onSuccess(dataContent)
        default:
            break
        }
        
        return self
    }

    // onError
    func onError(onError: (String) -> Void) -> UiDataState {
        switch self {
        case .Error(let message):
            onError(message)
        default:
            break
        }
        
        return self    }

    // onLoading
    func onLoading(onLoading: () -> Void) -> UiDataState {
        switch self {
        case .Loading:
            onLoading()
        default:
            break
        }
        
        return self
    }

    // onInitial
    func onInitial(onInitial: () -> Void) -> UiDataState {
        switch self {
        case .Initial:
            onInitial()
        default:
            break
        }
        
        return self
    }
    
    func isLoading(isLoading : (Bool) -> Void) -> UiDataState {
        switch self {
        case .Loading:
            isLoading(true)
            break
        default :
            isLoading(false)
        }
        
        return self
    }
}
 
struct DataContent<Data> {
    let data : Data
    static func createFrom(data : Data) -> DataContent<Data> {
        return DataContent.init(data: data)
    }
}


extension Result {
    func toUiDataState() -> UiDataState<Success> {
        switch self {
            case .success(let data):
                return .Success(DataContent(data: data))
            case .failure(let error):
                return .Error(error.localizedDescription)
        }
    }
}

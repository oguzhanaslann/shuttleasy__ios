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
    func onSuccess(onSuccess: (DataContent<T>) -> Void) {
        switch self {
        case .Success(let dataContent):
            onSuccess(dataContent)
        default:
            break
        }
    }
}
 
struct DataContent<Data> {
    let data : Data
    static func createFrom(data : Data) -> DataContent<Data> {
        return DataContent.init(data: data)
    }
}

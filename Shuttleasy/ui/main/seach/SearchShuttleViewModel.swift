import Foundation
import Combine


class SearchShuttleViewModel {
    private let searchResultSubject = PassthroughSubject<UiDataState<[SearchResult]>, Error>()
    let searchResultsPublisher : AnyPublisher<UiDataState<[SearchResult]>, Error>

    private let searchRepository : SearchShuttleRepository
    
    private var task : Task<(), Error>? = nil

    init(searchRepository : SearchShuttleRepository) {
        self.searchRepository = searchRepository
        self.searchResultsPublisher = searchResultSubject.eraseToAnyPublisher()
    }
    
    func searchShuttle(query: String) {
        
        print(query)
        
        if task != nil && !task!.isCancelled {
            task?.cancel()
            return 
        }

        searchResultSubject.send(UiDataState.Loading)
        task = Task.init {
            let result = await searchRepository.searchShuttle(query: query)
            
            switch result {
            case .success(let results):
                searchResultSubject.send(UiDataState.Success(DataContent.createFrom(data: results)))

            case .failure(let error):
                searchResultSubject.send(UiDataState.Error(error.localizedDescription))
            }
        }
    }
}

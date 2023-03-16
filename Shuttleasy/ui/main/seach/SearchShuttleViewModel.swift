import Foundation
import Combine


class SearchShuttleViewModel {
    private let searchResultSubject = PassthroughSubject<UiDataState<[SearchResult]>, Error>()
    let searchResultsPublisher : AnyPublisher<UiDataState<[SearchResult]>, Error>

    private let searchRepository : SearchShuttleRepository
    
    private var task : Task<(), Error>? = nil
    
    
    private let destinationPointsPublisher =  CurrentValueSubject<UiDataState<[CGPoint]>, Error>(UiDataState.Initial)
    let destinationPoints : AnyPublisher<UiDataState<[CGPoint]>, Error>

    init(searchRepository : SearchShuttleRepository) {
        self.searchRepository = searchRepository
        self.searchResultsPublisher = searchResultSubject.eraseToAnyPublisher()
        self.destinationPoints = destinationPointsPublisher.eraseToAnyPublisher()
        
        self.getDestinationPoints()
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
    
    func getDestinationPoints() {
        Task.init {
            let destinationPointResults = await searchRepository.getDestinationPoints()

            switch destinationPointResults {
                case .success(let results):
                    destinationPointsPublisher.send(UiDataState.Success(DataContent.createFrom(data: results)))
                case .failure(let error):
                    destinationPointsPublisher.send(UiDataState.Error(error.localizedDescription))
            }
        }
    }
}

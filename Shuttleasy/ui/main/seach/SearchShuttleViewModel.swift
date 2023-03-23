import Foundation
import Combine


class SearchShuttleViewModel {
    private let searchResultSubject = PassthroughSubject<UiDataState<[SearchResult]>, Error>()
    let searchResultsPublisher : AnyPublisher<UiDataState<[SearchResult]>, Error>

    private let searchRepository : SearchShuttleRepository
    
    private var task : Task<(), Error>? = nil
    
    private let destinationPointsPublisher =  CurrentValueSubject<UiDataState<[CGPoint]>, Error>(UiDataState.Initial)
    let destinationPoints : AnyPublisher<UiDataState<[CGPoint]>, Error>

    
    let initialStartPoint : CGPoint = CGPoint(x : 38.4189, y: 27.1287)
    
    
    init(searchRepository : SearchShuttleRepository) {
        self.searchRepository = searchRepository
        self.searchResultsPublisher = searchResultSubject.eraseToAnyPublisher()
        self.destinationPoints = destinationPointsPublisher.eraseToAnyPublisher()
        
        self.getDestinationPoints()
    }
    
    func searchCompanyFor(destinationName: String) {
        
        print(destinationName)
        
        if task != nil && !task!.isCancelled {
            task?.cancel()
            return 
        }

        searchResultSubject.send(UiDataState.Loading)
        task = Task.init {
            let result = await searchRepository.searchCompanyFor(destinationName: destinationName)
            
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

    func getCurrentDestinationPoints() -> [CGPoint] {
        switch destinationPointsPublisher.value {
            case .Success(let data):
                return data.data
            default:
                return []
        }
    }

    func searchCompanyFor(destination: CGPoint) {
        if task != nil && !task!.isCancelled {
            task?.cancel()
            return 
        }

        searchResultSubject.send(UiDataState.Loading)
        task = Task.init {
            let result = await searchRepository.searchCompanyFor(destination: destination)

            switch result {
                case .success(let results):
                    searchResultSubject.send(UiDataState.Success(DataContent.createFrom(data: results)))
                case .failure(let error):
                    searchResultSubject.send(UiDataState.Error(error.localizedDescription))
            }
        }
    }
}

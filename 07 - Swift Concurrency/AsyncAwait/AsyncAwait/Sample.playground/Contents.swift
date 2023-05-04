import UIKit

// MARK: - Model

struct Todo: Codable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool
}

// MARK: - Errors

enum TodoError: Error {
    case invalidRequest
    case failedToDecode
    case custom(error: Error)
}

// MARK: - Service

struct TodoService {
    /* were marking to the compiler that we want a async function,
        The code will then be done on the background thread.
        Using `await` creates a suspension point which suspends the thread.
     */
    func fetch() async throws -> [Todo]{
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        /// Allowing us to throw and error when this is an invalid request
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw TodoError.invalidRequest
        }
        
        let decodedData = try JSONDecoder().decode([Todo].self, from: data)
        return decodedData
    }
}
 let service = TodoService()
/*
 This function throws an error so we need to map this with a try,
 await allows us to tell the systems that this is a suspension point
 */
Task{
    do {
        let todos = try await service.fetch()
        dump(todos)
    } catch {
        print(error)
    }
}

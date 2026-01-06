import Foundation
import Combine

class BackgroundTaskRunner<T>: ObservableObject {
    
    // Equivalent to BackgroundTaskEventArgs
    struct TaskState {
        var status: BackgroundTaskStatus = .none
        var result: T? = nil
        var error: Error? = nil
    }
    
    @Published var state = TaskState()
    
    private var currentTask: Task<Void, Never>?
    
    /// Runs a task in the background.
    /// 'operation' is the Swift equivalent of Func<Task<T>>
    func runInBackground(operation: @escaping () async throws -> T) {
        // Cancel existing task if running (Disposable logic)
        currentTask?.cancel()
        
        // Start a new Task
        currentTask = Task {
            // Update status to Running on Main Thread
            await updateState(status: .running)
            
            do {
                // Execute the background work
                let result = try await operation()
                
                // Success
                if !Task.isCancelled {
                    await updateState(status: .completed, result: result)
                }
            } catch {
                // Failure
                if !Task.isCancelled {
                    print("Task Error: \(error)")
                    await updateState(status: .failed, error: error)
                }
            }
        }
    }
    
    // Ensures UI-bound property updates happen on the Main Thread
    @MainActor
    private func updateState(status: BackgroundTaskStatus, result: T? = nil, error: Error? = nil) {
        self.state = TaskState(status: status, result: result, error: error)
    }
    
    func cancel() {
        currentTask?.cancel()
        currentTask = nil
    }
}

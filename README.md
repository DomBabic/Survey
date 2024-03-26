### Overview

Welcome to the XM iOS technical task implementation!

The task is comprised of `Survey` App, and two modules - `SurveyAPI` and `SurveyData` - each with its own purpose.
The App is fully implemented using SwiftUI and Combine frameworks, while using modern concurrency for networking. 
The implemented project follows a modular architecture and adopts the Model-View-ViewModel (MVVM) design pattern.

The implemented project follows defined requirements of the App:
1. Loading survey questions from the API, with retry mechanism in place:
   - API request is triggered by navigating to `SurveyView`.
2. Question preview:
   - each question is displayed via ScrollView using paging, each page contains a `title`, `TextField` input, and `Submit` button,
   - button is disabled in input is empty or answer was already submitted,
   - on submit, toast is presented showing if request was a success or not,
   - user can navigate between questions by tapping on left and right chevron in the `View`,
   - if questions are loaded:
     - view shows current index of a question instead of the title,
     - view shows total number of answered questions.
3. Additional features:
   - view states:
     - loading - displayed while fetching the questions,
     - loaded - displayed when questions are successfully fetched,
     - error - displayed when max number of retries has been exceeded, contains retry button to allow for additional retries

### Structure

The project is organized into distinct modules, with a dedicated App encapsulating the core application logic, user interface components, and navigation. 
Leveraging the power of modular frameworks, the `SurveyData` module contains data models used to decode API response while `SurveyAPI` module is responsible for handling network requests.
Doing so helps break down the App into smaller easily manageable chunks. There are additional benefits to using modular architecture which are explained below.

#### Modularity

Adopting a modular approach has emerged as a strategic design principle, offering a range of advantages that significantly impact the development process and the overall quality of the application. 
A modular architecture breaks down the monolithic structure of an app into smaller, self-contained modules, each responsible for specific functionalities. 
This deliberate separation of concerns yields a host of benefits:

1. Scalability: 
   - Modular design allows for the easy addition or removal of features, promoting scalability as the app grows.
2. Maintainability: 
   - Each module encapsulates specific functionality, making it easier to locate, update, and maintain code without affecting the entire codebase.
3. Reusability: 
   - Modular components can be reused across projects, saving development time and promoting consistent implementation of functionalities.
4. Collaboration: 
   - Facilitates collaboration among development teams, as different modules can be worked on independently without interfering with each other.
5. Testing: 
   - Modular architecture simplifies unit testing, as individual modules can be tested in isolation, ensuring more effective and focused testing efforts.
6. Flexibility: 
   - Enables the flexibility to adopt new technologies, frameworks, or tools in specific modules without impacting the entire application.
7. Clear Separation of Concerns: 
   - Each module focuses on a specific aspect of the application, promoting a clear separation of concerns and enhancing code organization.
8. Quick Iterations: 
   - Development and deployment become more agile, as changes to one module can be implemented and tested without affecting the entire application.
9. Code Understandability: 
   - Enhances code readability and understandability by grouping related functionalities together, making it easier for developers to comprehend and contribute to the project.
10. Adaptability: 
    - Allows for easy adaptation to changing requirements by facilitating the addition, removal, or modification of modules based on evolving project needs.
    
##### Testability

Breaking down an application into modular components creates a structured environment for testing, offering several benefits that streamline the testing process and enhance the overall quality of the application.
Some testability benefits of modular approach include:

1. Isolation of Concerns:
   - Modules encapsulate specific functionalities, enabling focused testing on individual components without affecting the entire application. This isolation ensures that tests are precise and targeted.
2. Unit Testing Simplification:
   - Modules promote the creation of smaller units of functionality, making it easier to implement and execute unit tests. Developers can test each module independently, validating its behavior in isolation.
3. Mocking and Stubbing:
   - Modular design allows for the easy integration of mocks and stubs, facilitating the simulation of external dependencies during testing. This ensures that tests remain controlled and predictable.
4. Parallel Testing:
   - Individual modules can be tested concurrently, speeding up the overall testing process. This parallelization of tests enhances efficiency, especially in larger codebases.
5. Clear Interface Contracts:
   - Well-defined interfaces between modules establish clear contracts. This clarity simplifies the creation of mock objects and stubs, making it straightforward to mimic interactions between modules.
6. Focused Integration Testing:
   - Integration testing becomes more focused and manageable, as the interaction between modules can be systematically tested. This approach ensures that the integration of different components behaves as expected.
7. Regression Testing Confidence:
   - Changes to one module are less likely to impact others, reducing the risk of unintended side effects. This stability enhances confidence in regression testing, ensuring that existing functionalities remain intact.

### Model-View-ViewModel

The MVVM pattern aims to improve the separation of concerns, making the codebase more modular and testable. It helps in achieving a clean and maintainable architecture, as responsibilities are clearly defined for each component. 
The ViewModel acts as a bridge between the UI and business logic, `SurveyAPI` module provides data on demand which ViewModel supplies to the View. 

The View component of the pattern is implemented fully in SwiftUI which has plethora of benefits, some of which are listed below:
1. Declarative Syntax:
   - SwiftUI uses a declarative syntax, making it more concise and readable.
2. Less Boilerplate Code:
   - SwiftUI dramatically reduces boilerplate code.
3. Automatic Updates:
   - SwiftUI automatically updates the UI when the underlying state changes, reducing the manual effort required to keep the interface in sync with the data.
4. Reactive Programming with Combine:
   - SwiftUI seamlessly integrates with the Combine framework, allowing for reactive programming. This facilitates the handling of asynchronous events and data flow in a more intuitive manner.
5. Animation Made Easy:
   - Animation in SwiftUI is straightforward with built-in animation APIs.
6. Interoperability with UIKit:
   - SwiftUI can be used alongside existing UIKit components, as is demonstrated with this project.
   
### Documentation

The project is fully documented using DocC, Apple's Documentation Compiler. This comprehensive documentation covers Swift code (excluding UI), providing clear insights into functions, properties, classes, structures, and enumerations.
   
### Final thoughts

Working on this project has been a lot of fun. There are some things that could probably be improved - namely localisation and accessibility - but overall I believe it to be in a great shape.

The project's structure and documentation using DocC provide a solid foundation for any future expansion.

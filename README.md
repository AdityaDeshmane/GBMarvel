## GBMarvel

Simple application to show all Marvel character list and details of characters.

### Architecture 

1. UI Layer

Consist of whole UI Design Pattern MVP, MVVM etc. 
I have used MVP in the assignment

2. Domain Layer

This will have use case, or application wide rules.

3. Data Layer

Data classes, or enterprise wide rules.

//TODO/Assignment Specific: In assignment app is having directories showing layer separation UI Layer, Domain Layer, Data Layer. In real project it should different project/framework.

Details -

App follows Clean architecture with principles,
1. Unidirectional flow,  UI -> Domain -> Data
2. Reverse communication follows dependency inversion principle, via protocols/delegates (weak back references)

Each layer accesses next layer via protocols to avoid direct access to classes.

Models from next layers are first converted in own format before use in previous layers.

Ownerships - 

ViewControllers -

presenterRequestDelegate//strong

router//strong

Presenter - 

presenterResponseDelegate//weak

interactor//strong

Interactor -

interactorResponseDelegate//weak

providerRequestDelegate//strong

Provider  -

providerResponsedelegate//weak

networkService//strong


### Configurations

UI - 
* Avoiding use of storyboard based initial view controller and segue keeping everything as passive as possible.
* ApplicationRouter class will be responsible for high level flow switching.
* Each ViewController router will perform only navigations from same flow.

Configurator - 
* All classes will be passive and will not perform any coupling or connection logic. 
* Connection logic should be configured from outside via configurator.
* UIConfigurator will configure only UI and next layer i.e Domain. 
* Domain layer will provide configuration and next layer configuration i.e Data will happen through DomainConfigurator

### Naming, File Conventions

1. UI Layer Classes

* GB_XYZ_Flow.storyboard - Separate storyboard per flow
* GB_UILayerXYZ_Configurator - Configures all wiring
* GB_XYZ_ViewController - View Controllers
* GB_XYZ_Presenter - Presenter of MVP
* GB_XYZ_Router - For same flow navigations

2. Domain Layer Classes

* GB_XYZDomainLayer_Configurator 
* GB_XYZ_Interactor - Use case. Mediator between UI and Data

3. Data Layer Classes

* GB_XYZ_Provider - Daata getters, fetches data from repo, database, API etc
TODO/Betterment:  Xcode Template


### Third party libraries via Pod

1. Alamofire - Simplified network operations 
2. SwiftyJSON - Simplified respose parsing 
3. SwiftLint - Formating warning and error generation

### Unit testing
Assingment has flow testing only
TODO/Betterment: Add more test cases for better coverage

### Support
iOS 12 and Above 
iPhone and iPad


### TODOs/Betterment
1. More test coverage currently only flow is covered.
2. Separate project/framework per layer to refrain access vialotions 
3. Using core data as response array is heavy, faulting would help in low memory usage
4. Retry mechanism
5. Common logger 
6. xcconfig for envs


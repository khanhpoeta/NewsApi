# NewsApi

About

    This project implement news api with 3 main features
    + Fetch top-headline with category "general" with paging 
    + Fetch articles with key words "bitcoint,apple,earthquake,animal" with paging 
    + Save user profile information with firtname and lastname

The purpose of this document lets developers know exactly what to do when joining to the project.
How to clone the repository

    Checkout the source code by running the command line git clone 

How to build the project

    Before building the source code, you ensure that runs command line 'pod install' to fetch all libraries for the project. It's time to build the project and enjoy coding!!
    
Project structure

+ CustomView: This folder contains custom view like uitableviewcell, uicollectionviewcell, uiview which can reuse from another View Controller.
+ Modules: The main module of the project. It containt ViewController and ViewModel. ViewModel have input, output data support for unitesting
+ Models: The data models of the project. It containt server model and local model
+ Helper: This folder support for extentions class or child class custom
+ Configuration: It contain project's environment 
+ Provider: It contain provider of the project it maybe LocalDbProvider, ServiceApiProvider or another service provider
+ Resources: It contain project resource like image, project color, project custom fonts, localize files and storyboard file
    
    
    Ref:
    News api documentation:
    
    Top headline: https://newsapi.org/docs/endpoints/top-headlines
    Everythink: https://newsapi.org/docs/endpoints/everything




# Implementation of a Data Analysis program in R Programming

### CSE 310-04 Applied Programming - Jeremiah Pineda
### W07 Module 3 R Programming & Data Analysis
## Scott LeFoll
## 02/18/23
## Created by Scott LeFoll

## Module 3 Overview

The software uses the R Statistical Programming Language to perform a Linear Regression analysis of 
the Boston Fire Department's fire incident data file. The intent is compare variables like zip code, 
neighborhood, dwelling type, etc... with Total_Loss and Fire type to determine correlation.
The project includes multiple visualizations and feature tables, and achieves a 97% AUC in prediction.

## It is highly recommended to run this file in R Studio workspace, with all of the code loaded into a single directory.

This application is provided for the following purpose:

To demonstrate a full range of basic R Programming features, including data structures, loops, machine 
learning algorithms and visualization techniques.
    
    The following functionality is implemented:
    
    Download a csv file from the internet, if it does not already exist locally
    Load a csv file into a dataframe
    Preprocess the dataframe, including converting to numerical data, and converting 
    categorical features to numeric features.
    create and display a number of relevent visualizations
    split the data set into testing data and training data.
    train the Linear Regression model on the training data
    test the model predictions using the model
    run a variety of evaluation metrics to check the performance of the model

[R Programming for Data Analysis Video](https://youtu.be/bZvF0f188Zc)

[R Programming for Data Analysis Programming Git Hub repo](https://github.com/scottlefoll/CSE310_R)

# Development Environment

I used a combination of Google Colab, R Studio and VS Code. I think I started in VS Code, then continued on in R Studio and finally switched over to Colab, where I finished. The environment was a PC running Windows 10 Pro with 32 gigs of RAM, using a chrome browser when running Colab.

The programming language used was the R Statistical Language, with the following libraries:

-"plyr"
-"reshape2"
-"pivottabler"
-"corrplot"
-"lubridate"
-"datetime"
-"caret"
-"dplyr"
-"ROCR"

# Useful Websites

{Make a list of websites that you found helpful in this project}

- [Stats and R](https://statsandr.com/blog/an-efficient-way-to-install-and-load-r-packages/)
- [Geeks for Geeds - R dataframes](https://www.geeksforgeeks.org/r-data-frames/)
- [Data Camp - R](https://www.datacamp.com/blog/r-project-ideas)
- [Kaggle - R Programming](https://www.kaggle.com/general/217499)
- [Tutorials Point - R Programming](https://www.tutorialspoint.com/r/r_data_frames.htm)
- [Stack Exchange](https://stackexchange.com/)
- [The R Project](https://www.r-project.org/)
- [Free Code Camp - Learn R](https://www.freecodecamp.org/news/r-programming-course/)
- [Dataquest Learn R](https://www.dataquest.io/blog/learn-r-for-data-science/)


# Future Work

{Make a list of things that you need to fix, improve, and add in the future.}

- Implement the Polars library - I have heard a lot about this and I would like to try it.
- Get the code fully functioning inside of VS Code using Qustodio
- Add a neural network and increase the data inputs
- add a geocoded visualization

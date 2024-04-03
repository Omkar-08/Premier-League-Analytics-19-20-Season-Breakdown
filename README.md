# Premier League Player Statistics Database Management Project

This repository contains the resources and documentation for a project focused on creating a structured SQL database from Premier League player statistics for the 2019/2020 season.

## Table of Contents
- [Project Overview](#project-overview)
- [Dependencies](#dependencies)
- [Database Structure](#database-structure)
- [Procedure](#procedure)
- [Business Questions Addressed](#business-questions-addressed)
- [Contributing](#contributing)

## Project Overview
This project focuses on developing a structured and optimized SQL database, originating from a dataset that encompasses detailed statistics of Premier League players from the 2019/2020 season. This facilitates an in-depth analysis and provides insight into different metrics to measure some of the best performers in this season. The dataset was sourced from Kaggle.

On a high level, this dataset is quite extensive, but the dataset's complexity can hinder understanding, so normalization is necessary. By the end of this engagement, the initial dataset which is in csv format will be converted to a normalized SQL database.

[Link to dataset](https://www.kaggle.com/datasets/cashncarry/epl-players-deep-stats-20192020/)

## Dependencies
- MySQL Workbench
- Tableau (for visualizations)

## Database Structure
The database consists of multiple tables, which include
the database can be normalized to: 
-	Player Table (Player ID, Player Name, age, height, weight, games played…)
-	Team Table (Team ID, Team)
-	Nationality table (Nation ID, Nation Name)
-	Position Table (Position ID, Position Name)
-	Outfield Player Table (Player ID, Team ID, Position ID, Goals, Assists, Tackles….)
-	Goalkeeper Table (Player ID, Team ID, Position ID, Saves, Saves of shots inside the box…)


## Procedure
1. **Data Import**: Using MySQL's Table Data Import Wizard to transfer and normalize data into designated tables. This process entailed selecting certain columns from the dataset and generating distinct CSV files for each table.
2. **Table Creation**: Subsequently, I established the EPL_PLAYERS Database and crafted six tables within this MySQL database. This was to organize player statistics, team information, and other relevant data.
3. **Data Analysis**: Utilizing SQL queries to explore and answer various business questions.

## Business Questions Addressed
- Distribution of player nationalities
- Top players in different categories
- Correlation between player attributes
- Were there any players who went out on loan/transferred to another team during the season?


## Contributing
Feel free to fork this repository or submit pull requests.


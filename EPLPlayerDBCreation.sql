DROP DATABASE IF EXISTS EPL_PLAYERS;

# Create Database
CREATE DATABASE IF NOT EXISTS EPL_PLAYERS;

USE EPL_PLAYERS;

# Create Tables
CREATE TABLE IF NOT EXISTS NATIONALITY (
	Nationality_ID INT PRIMARY KEY,
    Nationality_Name VARCHAR(255)
);

# Data dictionary of Nationality Table
DESCRIBE NATIONALITY;

CREATE TABLE IF NOT EXISTS TEAM (
	Team_ID INT PRIMARY KEY,
    Team_Name VARCHAR(255)
);

# Data dictionary of Team Table
DESCRIBE TEAM;

CREATE TABLE IF NOT EXISTS PLAYER_POSITION (
	Position_ID INT PRIMARY KEY,
    Position_Name VARCHAR(255)
);

# Data dictionary of Player_Position Table
DESCRIBE PLAYER_POSITION;


CREATE TABLE IF NOT EXISTS PLAYER (
    Player_ID INT,
    Team_ID INT,
    Position_ID INT,
    Nationality_ID INT,
    Player_Name VARCHAR(255),
    Age INT,
    Weight INT,
    Height INT,
    Games_Played INT,
    PRIMARY KEY (Player_ID,Team_ID),
    FOREIGN KEY (Team_ID) REFERENCES TEAM(Team_ID),
    FOREIGN KEY (Nationality_ID) REFERENCES NATIONALITY(Nationality_ID),
    FOREIGN KEY (Position_ID) REFERENCES PLAYER_POSITION(Position_ID)
);


# Data dictionary of Player Table
DESCRIBE PLAYER;


CREATE TABLE IF NOT EXISTS OUTFIELD_PLAYER (
	Player_ID INT,
    Position_ID INT,
    Rating FLOAT,
    Goals INT,
    Assists INT,
    Tackles FLOAT,
    Clearences FLOAT,
    Interceptions FLOAT,
    Pass_Completion_Percentage FLOAT,
    Long_Passes FLOAT,
    Short_Passes FLOAT,
    Key_Passes FLOAT,
    Dribbles_Won FLOAT,
    FOREIGN KEY (Player_ID) REFERENCES PLAYER(Player_ID),
    FOREIGN KEY (Position_ID) REFERENCES PLAYER_POSITION(Position_ID)    
);

# Data dictionary of Outfield_Player Table
DESCRIBE OUTFIELD_PLAYER;

CREATE TABLE IF NOT EXISTS GOALKEEPER (
	Player_ID INT,
    Position_ID INT,
    Rating FLOAT,
    In_Goal_Area_Saves FLOAT,
    Inside_Box_Saves FLOAT,
    Outside_Box_Saves FLOAT, 
    Saves_Per_Game FLOAT,
    FOREIGN KEY (Player_ID) REFERENCES PLAYER(Player_ID),
    FOREIGN KEY (Position_ID) REFERENCES PLAYER_POSITION(Position_ID)  
);

# Data dictionary of Goalkeeper Table
DESCRIBE GOALKEEPER;

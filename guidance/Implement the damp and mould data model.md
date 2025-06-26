# Implement the damp and mould data model

## Table of contents

— [What’s included](#whats-included)  
— [How to implement the data model](#how-to-implement-the-data-model)

This page explains how to set up the damp and mould data model using SQL files.

You can choose to run the full model at once or review and adapt specific components to fit your own database setup.

[Read more about the key features of the Awaab’s Law data model]().

## What’s included

The SQL files contain [Data Definition Language (DDL)]() scripts, which serve as setup scripts to:

* create tables  
* define relationships using foreign keys  
* insert pre-defined values like code lists  
* apply constraints and checks

## How to implement the data model

There are 2 different methods you can use to implement the data model:

### Method 1: run the SQL file in your database

Use this method if you want to set up everything at once:

1. Open your database management tool   
2. Load in the full SQL file  
3. Execute the script to create all tables, relationships, constraints and pre-populated data in the code lists.

### Method 2: open the SQL file to copy or edit specific parts 

Use this method if you don’t want to run the entire model at once, or if you want to customise parts of it:

1. Open the SQL file using a text editor like [Notepad++](https://notepad-plus-plus.org/) or [Visual Studio Code](https://code.visualstudio.com/)  
2. Then, you can:  
   1. Copy individual table definitions and run them in your database  
   2. Add or remove fields, rename columns and extend code lists

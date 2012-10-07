# Overview

This is a temporary repo.

The goal is to figure out how to achieve the following:

- Manage the schema separately from any application
- Balance schema design tools (Navicat, pgAdmin, etc.) and code.
- Version the schema
- Migrate the schema


## Install

    ./install

You can specify the host, database or version via the env vars HOST,
DATABASE and VERSION. By default, HOST=localhost, DATABASE=pooldin and
VERSION is the latest version. For specific help:

    ./install help


## Management

At this point, the schema is kept in Navicat to simplify the design process
by leveraging the Model Designer. The issue with the Model Designer is
that it does not support constraints, custom types, functions, etc.

For now we will manage the following in Navicat:

- Tables
- Primary Keys
- Indexes
- Uniques

This repo will track all schema requirements not manageable via Navicat.


## TODO

- Figure out migrations
- Figure out versioning
- Figure out fixtures
- Implement a management cli

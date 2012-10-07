# Overview

This is a temporary repo.

The goal is to figure out how to achieve the following:

- Manage the schema separately from any application
- Balance schema design tools (Navicat, pgAdmin, etc.) and code.
- Version the schema
- Migrate the schema


## Quick Install

    make deps db

Or...

    make
    make db


## Commands

Commands are defined via the [cement2][cement2] library and executed
via the manage.py script.

Help

    python manage.py

Shell

    python manage.py shell --help

Install

    python manage.py install --help


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

[cement2]: http://cement.readthedocs.org/en/latest/

# The Campus Cache

TODO: link to video showing usage


This repo contains our full-stack application, composed of three Docker containers:

1. A MySQL 8 container for hosting our data
1. A Python Flask container which implements a REST API
1. A Local AppSmith Server which offers an extensive UI and interacts with the
   Flask container

## Overview

An Air BnB-type situation specific to storage space for students. Many students leave
campus or temporarily don’t have housing over a break and need somewhere to store their
belongings. Other students may have surplus space but cannot rent it out to a person for
one reason or another. Our service connects these two groups of people, allowing the
space owners to make money and offering the renters a safe place to leave their things.

## How to setup and start the containers

Just run `docker compose up` in the root directory of this project to spin up
the Database, Flask, and AppSmith containers. Once initialized, we may open
a web browser and navigate to AppSmith at the URL `localhost:8080/`.

TODO: finish this ...



#!/usr/bin/env bash

# Languages
@languages()

# Libs
@include('src/libs/utils')
@include('src/libs/language')
@include('src/libs/message')

# Tasks
@include('src/tasks/installation')

@include('src/index')
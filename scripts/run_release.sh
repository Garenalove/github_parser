#!/bin/bash

if [[ ! -z "$CREATE_DB_ON_INIT" ]]; then
  bin/github_parser eval "GithubParser.Release.create_db"
fi

bin/github_parser eval "GithubParser.Release.migrate"
bin/github_parser start

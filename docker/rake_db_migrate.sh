#!/bin/bash
rake db:migrate

if [[ $? != 0 ]]; then
  echo
  echo "== Failed to migrate. Running setup first."
  echo
  rake db:setup && \
  rake db:populate && \
  rake db:migrate
fi
#!/usr/bin/env bash
gdbus call --session --dest io.universalworkspace.UniversalWorkspace \
    --object-path /io/universalworkspace/UniversalWorkspace/Object \
    --method io.universalworkspace.UniversalWorkspace.Open "['$1']" {}

#!/bin/bash
find . -type f -name '*.php' -exec php -l {} \; | (! grep -v "No syntax errors detected" )

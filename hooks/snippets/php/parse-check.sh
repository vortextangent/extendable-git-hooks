#!/bin/bash
# Author: Remigijus Jarmalavičius <remigijus@jarmalavicius.lt>
# Author: Vytautas Povilaitis <php-checker@vytux.lt>
#
# XDebug check added by William Clemens <http://github.com/wesclemens>
# Handle spaces in filenames Dave Barnwell <https://github.com/freshsauce>

ROOT_DIR="$(pwd)/"
LIST=$(git diff-index --cached --name-only --diff-filter=ACMR HEAD)
ERRORS_BUFFER=""
for file in $LIST
do
    EXTENSION=$(echo "$file" | grep ".php$")
    if [ "$EXTENSION" != "" ]; then
        ERRORS=$(php -l "$ROOT_DIR$file" 2>&1 | grep "Parse error")
        if [ "$ERRORS" != "" ]; then
            if [ "$ERRORS_BUFFER" != "" ]; then
                ERRORS_BUFFER="$ERRORS_BUFFER\n$ERRORS"
            else
                ERRORS_BUFFER="$ERRORS"
            fi
            echo "Syntax errors found in file: $file "
        fi

        # Check for xdebug statments
        ERRORS=$(grep -nH xdebug_ "$ROOT_DIR$file" | \
                 sed -e 's/^/Found XDebug Statement : /')
        if [ "$ERRORS" != "" ]; then
            if [ "$ERRORS_BUFFER" != "" ]; then
                ERRORS_BUFFER="$ERRORS_BUFFER\n$ERRORS"
            else
                ERRORS_BUFFER="$ERRORS"
            fi
        fi
    fi
done
if [ "$ERRORS_BUFFER" != "" ]; then
    echo  >&2
    echo "Found PHP parse errors: " >&2
    echo -e $ERRORS_BUFFER >&2
    echo  >&2
    echo "PHP parse errors found. Fix errors and commit again." >&2
    exit 1
fi
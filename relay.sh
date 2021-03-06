verbose() {
    if [ -n "$RELAY_VERBOSE" ]
    then
        echo "$@" >&2
    fi
}

info() {
    if [ -n "$RELAY_INFO" ]
    then
        echo "$@" >&2
    fi
}

verbose
verbose

while [ $# -gt 0 ]
do
    case $1 in
        --build-dir)
            BUILD_DIR=$2
            shift 2
            ;;
        --command-file)
            CMD_FILE=$2
            shift 2
            ;;
        --target)
            TARGET=$2
            shift 2
            ;;
        --prerequisites)
            shift 1
            while [ $# -gt 0 ]
            do
                case $1 in
                    --)
                        shift 1
                        break
                        ;;
                    *)
                        PREREQS="$PREREQS $1"
                        shift 1
                        ;;
                esac
            done
            ;;
        --phony)
            shift 1
            PHONY=True
            ;;
        *)
            break
            ;;
    esac
done

info "$@"

verbose Making "$TARGET" with command "$@", with updated prereqs "$PREREQS",\
 putting command into "$CMD_FILE", build dir is "$BUILD_DIR"


if [ "$PHONY" = "True" ]
then
    verbose We\'re building phony target
fi

CMD="$@"
if [ ! -z $CMD_FILE ]
then
    mkdir -p $(dirname $CMD_FILE)
    echo "$CMD" > $CMD_FILE
fi

verbose Resulting CMD: "$CMD"

set -e
eval "$CMD" $REDIRECT
set +e

for arg in "$@"
do
    echo "$arg"
    zipinfo -1 $arg | grep \.so$
done
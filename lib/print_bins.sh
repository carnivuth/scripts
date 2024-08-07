print_bins(){
  {
    IFS=:;
    set -f;
    find -L $PATH -maxdepth 1 -type f -perm -100 -print;
  } | sed 's!.*/!!'
}

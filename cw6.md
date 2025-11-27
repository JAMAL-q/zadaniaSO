## 1 head -n 1 iris.csv
## 2 tail -n +2 iris.csv
## 3 sed 's/Setosa/1/g; s/Versicolor/2/g; s/Virginica/3/g' iris.csv
## 4 cut -d ',' -f 5 iris.csv | sort | uniq
## 5 awk -F ',' 'NR>1 {print $1 + $2 + $3 + $4}' iris.csv
## 6 awk -F ',' 'NR>1 {sum += $2; n++} END {print "średnica =", sum/n}' iris.csv
## 7 awk -F ',' 'NR>1 && $4 > max {max=$4; line=$0} END {print line}' iris.csv
## 8 awk -F ',' 'NR>1 && $1 > 7 {print $5}' iris.csv
## 9 
awk -F',' '
NR==1 { print; next } 
{
    printf "%d\t%d\t%d\t%d\t%s\n", int($1), int($2), int($3), int($4), $5
}' iris.csv

## 10 
awk 'NR==1{h=$0;next}{r[++n]=$0}END{srand();print h;while(n){i=int(rand()*n)+1;print r[i];r[i]=r[n];n--}}' iris.csv > iris2.csv

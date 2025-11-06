## 1
- head -n 1 iris.csv
## 2 
- tail -n +2 iris.csv
## 3 
- sed 's/Setosa/1/g; s/Versicolor/2/g; s/Virginica/3/g' iris.csv
## 4
- cut -d ',' -f 5 iris.csv | sort | uniq
## 5

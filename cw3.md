##1 
mkdir lab
##2
ls -ld lab
##3
chmod 750 lab
##4 
ls -l /boot > lab/boot.txt
##5 
mkdir lab/dir1/dir2/dir3
##6
cd lab/dir1/dir2
cat ../../boot.txt
##7
touch ~/lab/tekst1.txt ~/lab/tekst2.txt ~/lab/tekst3.txt
##8
cp ~/lab/tekst*.txt ~/lab/dir1/dir2/dir3/
##9

##10
mv ~/lab/dir1/dir2/dir3/tekst1.txt ~/lab/dir1/dir2/dir3/nowanazwa.txt
##11
cat /proc/meminfo > ~/lab/tekst.txt
##12
cat /proc/cpuinfo >> ~/lab/tekst1.txt
##13
who ~/lab/tekst2.txt
##14
find / -type d -name share 2>/dev/null
##15
find /usr/in -type f -size +5M 2>/dev/null
##16

##17
ln ~/lab/tekst2.txt ~/lab/TEKST2.TXT
##18
ln -s ~/lab/tekst2.txt ~/lab/Tekst2.txt
##19
ls -la ~/lab
##20
ls /dev/ |grep tty
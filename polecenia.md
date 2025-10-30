1. ps axo command | grep [[:space:]]
## -E powoduje wybór znaku nieregularnego np. space 
2. mount | grep -E " (/dev/|/sys/)"
## dodawanie i powoduje niezależność w obec wielkości znaków 
3. journalctl -b | grep -Ei "(PCI|USB)"
## trzeba podać wszystkie cyfry z peselu 9+1+1
4. grep -E ^[0-9]{9}[13579][0-9]$ numery.txt
## trzeba dodać 99 na początku 
5. grep -E "^99[0-9]{7}[02468][0-9]$" numery.txt
## alnum sprawdza czy przed @ są liczby lub cyfry \. sprawdza czy jest kropka {2,} sprawdza 2 ostatnie znaki
6. grep -E "^[[:alnum:]]{1,16}@[a-z]+\.[a-z]{2,}$" adresy.txt

7. grep -E "([[:digit:]]|[[:alpha:]]|[[:upper:]])" hasla.txt | grep [!@#$%^&*()]' hasla.txt


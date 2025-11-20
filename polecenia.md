## 1. ps axo command | grep [[:space:]]

## 2. mount | grep -E " (/dev/|/sys/)"

## 3. journalctl -b | grep -Ei "(PCI|USB)"

## 4. grep -E ^[0-9]{9}[13579][0-9]$ numery.txt

## 5. grep -E "^99[0-9]{7}[02468][0-9]$" numery.txt

## 6. grep -E "^[[:alnum:]]{1,16}@[a-z]+\.[a-z]{2,}$" adresy.txt

## 7. grep -E "([[:digit:]]|[[:alpha:]]|[[:upper:]])" hasla.txt | grep [!@#$%^&*()]' hasla.txt

## 8. grep -RIn "strlen" git-master

## 9. ip link | grep -E "([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}"

## 10. ip addr | grep -E "[0-9]{1,3}(\.[0-9]{1,3}){3}"

## 11. grep -E "^(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])){3}$" ip.txt

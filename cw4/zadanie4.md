### 1. Nadpisywanie pliku
Użycie `>`, aby zastąpić zawartość pliku:

```bash
echo "Tekst" > plik.txt
```
Dodawanie tekstu na koniec pliku

```bash

echo "Dodatkowy tekst" >> plik.txt

```

### 2. Dodawanie i usuwanie komentarza 
Wciskane kolejno:
```
Esc, 3 
```

### 3. Dodawanie i usuwanie wcięcia w tekście 

Dodawanie
```
ctrl + i lub alt + }
```
Usuwanie 
```
shift + tab  lub alt + {
```
### 4. zmiana tab na space przy każdym uruchomieniu (nano)
nazwa pliku
```
nanorc
```
treść do wpisania 
```bash
set tabstospaces
set tabsize 4
```
### 5. zmiana tab na space przy każdym uruchomieniu (vim)
nazwa pliku 
```
vimrc 
```
treść do wpisania 
```bash
set expandtab
set tabstop=4
```
### 6. vimtutor

wpisane kolejno polecenia:
```bash
vimtutor
:w vim.txt
vim vim.txt
```

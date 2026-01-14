mkdir -p /tmp/data/random /tmp/data/empty /tmp/data/various
# Generowanie przykładowych plików
dd if=/dev/urandom of=/tmp/data/random/file1 bs=5M count=1
dd if=/dev/zero of=/tmp/data/empty/file1 bs=5M count=1
# (Dla folderu various możesz po prostu skopiować tam kilka dowolnych plików tekstowych/obrazków)
sudo apt update
sudo apt install gzip bzip2 xz-utils zstd lz4 p7zip-full bc
# w razie problemów
chmod +x compr-bench
# dodanie uprawnień


# Tworzenie struktury katalogów
mkdir -p /tmp/data/random /tmp/data/empty /tmp/data/various

# 5 plików po 5M z losowymi bajtami
for i in {1..5}; do dd if=/dev/urandom of=/tmp/data/random/file$i bs=5M count=1; done

# 5 plików po 5M z zerami
for i in {1..5}; do dd if=/dev/zero of=/tmp/data/empty/file$i bs=5M count=1; done

# Pobranie i rozpakowanie Silesia Corpus (różnorodne pliki)
cd /tmp/data/various
wget http://sun.aei.polsl.pl/~sdeor/corpus/silesia.zip
unzip silesia.zip && rm silesia.zip

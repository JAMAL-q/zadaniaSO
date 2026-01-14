#!/bin/bash
 
# Sprawdzenie czy podano argumenty
if [ $# -eq 0 ]; then
    echo "Użycie: $0 katalog1 [katalog2 ...]"
    exit 1
fi

tmp_dir=$(mktemp -d)

# Lista programów: nazwa | komenda_kompresji | komenda_dekompresji | rozszerzenie
// -k (keep), aby nie usuwać plików źródłowych tam, gdzie to możliwe
algorithms=(
    "gzip|gzip -k|gunzip -k|gz"
    "bzip2|bzip2 -k|bunzip2 -k|bz2"
    "xz|xz -k|unxz -k|xz"
    "zstd|zstd -k|unzstd -k|zst"
    "lz4|lz4 -k|unlz4 -k|lz4"
    "7z|7z a -t7z|7z x|7z"
)

for dir in "$@"; do
    echo -e "\n$dir"
    echo -e "name\tcompress\tdecompress\tratio"

    # 1. Tworzenie bazowego archiwum TAR
    tar -cf "$tmp_dir/archive.tar" -C "$dir" .
    orig_size=$(stat -c%s "$tmp_dir/archive.tar")

    for algo in "${algorithms[@]}"; do
        IFS="|" read -r name comp_cmd decomp_cmd ext <<< "$algo"

        # --- KOMPRESJA ---
        start=$(date +%s.%N)
        if [ "$name" == "7z" ]; then
            $comp_cmd "$tmp_dir/archive.$ext" "$tmp_dir/archive.tar" > /dev/null
        else
            $comp_cmd "$tmp_dir/archive.tar" > /dev/null
        fi
        end=$(date +%s.%N)
        comp_time=$(echo "$end - $start" | bc -l)

        # Pobranie rozmiaru skompresowanego
        comp_size=$(stat -c%s "$tmp_dir/archive.tar.$ext" 2>/dev/null || stat -c%s "$tmp_dir/archive.$ext")
        ratio=$(echo "scale=2; ($comp_size / $orig_size) * 100" | bc -l)

        # Usunięcie oryginału tar przed dekompresją (by sprawdzić czy dekompresja działa)
        rm "$tmp_dir/archive.tar"

        # --- DEKOMPRESJA ---
        start=$(date +%s.%N)
        if [ "$name" == "7z" ]; then
            $decomp_cmd "$tmp_dir/archive.$ext" -o"$tmp_dir/" > /dev/null
        else
            $decomp_cmd "$tmp_dir/archive.tar.$ext" > /dev/null
        fi
        end=$(date +%s.%N)
        decomp_time=$(echo "$end - $start" | bc -l)

        # Wyświetlenie wyników
        printf "%s\t%.9f\t%.9f\t%.1f%%\n" "$name" "$comp_time" "$decomp_time" "$ratio"

        # Sprzątanie po algorytmie
        rm -f "$tmp_dir/archive.tar.$ext" "$tmp_dir/archive.$ext"
    done

    # Usuwamy bazowy tar przed kolejnym katalogiem z argumentów
    rm -f "$tmp_dir/archive.tar"
done

# Usuwanie katalogu tymczasowego
rm -rf "$tmp_dir"

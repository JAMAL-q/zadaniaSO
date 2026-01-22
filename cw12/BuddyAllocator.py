#!/usr/bin/env python3
import math

class BuddyAllocator:
    def __init__(self, total_size, split_limit):
        self.total_size = total_size
        self.split_limit = split_limit
        
        # Obliczanie minimalnego rozmiaru bloku na podstawie limitu podziałów
        # limit 0 -> min_size = total_size
        # limit 1 -> min_size = total_size / 2 itd.
        self.min_block_size = total_size // (2 ** split_limit)
        
        # Mapa wolnych bloków: { rozmiar: [adresy] }
        self.free_blocks = { (total_size // (2**i)): [] for i in range(split_limit + 1) }
        self.free_blocks[total_size].append(0)
        
        # Słownik do śledzenia zajętych bloków (adres: rozmiar) dla metody free
        self.allocated_blocks = {}

    def alloc(self, size):
        if size <= 0:
            return None
        
        # 1. Wyznaczenie wymaganego rozmiaru bloku (potęga 2)
        target_size = 2 ** math.ceil(math.log2(size))
        
        # Uwzględnienie limitu podziałów (nie mniejszy niż min_block_size)
        target_size = max(target_size, self.min_block_size)
        
        if target_size > self.total_size:
            print(f"Błąd: Rozmiar {size} przekracza całkowitą pamięć.")
            return None

        # 2. Szukanie dostępnego bloku (ewentualny podział)
        current_size = target_size
        while current_size <= self.total_size and not self.free_blocks[current_size]:
            current_size *= 2
            
        if current_size > self.total_size:
            print(f"Błąd: Brak wolnego bloku dla rozmiaru {target_size}.")
            return None

        # 3. Pobranie bloku i ewentualne dzielenie (splitting)
        addr = self.free_blocks[current_size].pop(0)
        
        while current_size > target_size:
            current_size //= 2
            buddy_addr = addr + current_size
            self.free_blocks[current_size].append(buddy_addr)
            # Sortujemy adresy, aby zachować porządek (opcjonalne, ale pomaga w debugowaniu)
            self.free_blocks[current_size].sort()

        self.allocated_blocks[addr] = target_size
        return (addr, target_size)

    def free(self, address, size=None):
        # Zabezpieczenie przed invalid/double free
        if address not in self.allocated_blocks:
            print(f"Błąd: Nieprawidłowy adres lub podwójne zwalnianie: {address}")
            return
        
        # Pobierz rozmiar, jeśli nie został podany 
        if size is None:
            size = self.allocated_blocks.pop(address)
        
        if size == self.total_size:
            self.free_blocks[size].append(address)
            return

        # Wyznacz adres bloku za pomocą XOR
        buddy_address = address ^ size
        
        # Rekurencyjne łączenie (coalescing)
        if buddy_address in self.free_blocks[size]:
            # usuwamy go i łączymy w większy blok
            self.free_blocks[size].remove(buddy_address)
            new_address = min(address, buddy_address)
            self.free(new_address, size * 2)
        else:
            # dodajemy obecny blok do listy wolnych
            self.free_blocks[size].append(address)
            self.free_blocks[size].sort()

    def status(self):
        print("\n--- Stan Buddy Allocatora ---")
        for size, addrs in sorted(self.free_blocks.items(), reverse=True):
            print(f"Rozmiar {size:4}: {addrs}")
        print("-----------------------------\n")


if __name__ == "__main__":
    allocator = BuddyAllocator(2048, 6)
    
    print("Alokacja 1 (100):", (a1 := allocator.alloc(100)))
    print("Alokacja 2 (200):", (a2 := allocator.alloc(200))) 
    allocator.status()
    
    print(f"Zwalnianie adresu {a1[0]}...")
    allocator.free(a1[0])
    allocator.status()

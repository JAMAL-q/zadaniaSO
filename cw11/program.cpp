#include <iostream>
#include <vector>
#include <cmath>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/wait.h>
#include <pthread.h>
#include <thread>
#include <cstring>

// Struktura danych w pamięci współdzielonej
struct SharedData {
    unsigned int counts[26];
    double sum_sqrt;
    pthread_mutex_t mutex;
};

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Użycie: " << argv[0] << " <plik> [ilość_procesów]" << std::endl;
        return 1;
    }

    const char* file_path = argv[1];
    int n_procs = (argc > 2) ? std::stoi(argv[2]) : std::thread::hardware_concurrency();
    if (n_procs < 1) n_procs = 1;

    // 1. Mapowanie pliku tekstowego do pamięci
    int fd = open(file_path, O_RDONLY);
    if (fd < 0) { perror("Błąd open"); return 1; }

    struct stat st;
    fstat(fd, &st);
    size_t file_size = st.st_size;

    char* file_data = (char*)mmap(NULL, file_size, PROT_READ, MAP_PRIVATE, fd, 0);
    close(fd); // Plik można zamknąć po mmap

    // 2. Alokacja anonimowej pamięci współdzielonej
    SharedData* shared = (SharedData*)mmap(NULL, sizeof(SharedData), 
                                           PROT_READ | PROT_WRITE, 
                                           MAP_SHARED | MAP_ANONYMOUS, -1, 0);

    // Inicjalizacja danych
    std::memset(shared->counts, 0, sizeof(shared->counts));
    shared->sum_sqrt = 0.0;

    // Inicjalizacja mutexu do pracy między procesami (PTHREAD_PROCESS_SHARED)
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_setpshared(&attr, PTHREAD_PROCESS_SHARED);
    pthread_mutex_init(&shared->mutex, &attr);

    // 3. Podział pracy i tworzenie procesów
    size_t chunk_size = file_size / n_procs;

    for (int i = 0; i < n_procs; ++i) {
        pid_t pid = fork();
        if (pid == 0) { // Proces potomny
            size_t start = i * chunk_size;
            size_t end = (i == n_procs - 1) ? file_size : (i + 1) * chunk_size;

            // Lokalne zmienne (optymalizacja - rzadsze blokowanie mutexu)
            unsigned int local_counts[26] = {0};
            double local_sum = 0.0;

            for (size_t j = start; j < end; ++j) {
                unsigned char c = file_data[j];
                local_sum += std::sqrt((double)c);

                if (c >= 'a' && c <= 'z') local_counts[c - 'a']++;
                else if (c >= 'A' && c <= 'Z') local_counts[c - 'A']++;
            }

            // Aktualizacja pamięci współdzielonej (jedno zablokowanie na proces)
            pthread_mutex_lock(&shared->mutex);
            for (int k = 0; k < 26; ++k) shared->counts[k] += local_counts[k];
            shared->sum_sqrt += local_sum;
            pthread_mutex_unlock(&shared->mutex);

            exit(0);
        }
    }

    // 4. Oczekiwanie na procesy i wypisanie wyników
    for (int i = 0; i < n_procs; ++i) wait(NULL);

    std::cout << "Wyniki zliczania liter (case-insensitive):" << std::endl;
    for (int i = 0; i < 26; ++i) {
        if (shared->counts[i] > 0)
            std::cout << (char)('a' + i) << ": " << shared->counts[i] << " ";
    }
    std::cout << "\n\nSuma pierwiastków kodów ASCII: " << shared->sum_sqrt << std::endl;

    // Sprzątanie
    pthread_mutex_destroy(&shared->mutex);
    munmap(shared, sizeof(SharedData));
    munmap(file_data, file_size);

    return 0;
}
// kompresja 
// g++ -O3 program.cpp -o program -pthread
// ./program sciezka_do_pliku.txt 4

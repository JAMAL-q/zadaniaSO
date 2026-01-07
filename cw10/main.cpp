#include <iostream>
#include <fstream>
#include <string>
#include <thread>
#include <vector>
#include <mutex>
#include <cmath>
#include <cctype>

#define LETTER_COUNT 26

struct context {
    std::string content;
    unsigned long count[LETTER_COUNT] = {0};
    double sumOfSquares = 0.0;
    std::mutex mutex;
};

int main(int argc, char* argv[])
{
    if (argc < 2) {
        std::cerr << "Użycie: " << argv[0] << " <plik> [watki]\n";
        return 1;
    }

    unsigned int threadsCount =
        (argc > 2) ? std::stoul(argv[2]) : std::thread::hardware_concurrency();

    if (threadsCount == 0) threadsCount = 1;

    context ctx;

    // Wczytanie pliku
    std::ifstream file(argv[1], std::ios::binary);
    ctx.content.assign(
        std::istreambuf_iterator<char>(file),
        std::istreambuf_iterator<char>()
    );

    size_t size = ctx.content.size();
    size_t chunk = size / threadsCount;

    std::vector<std::thread> threads;

    for (unsigned int t = 0; t < threadsCount; ++t) {
        size_t begin = t * chunk;
        size_t end = (t == threadsCount - 1) ? size : begin + chunk;

        threads.emplace_back([&ctx, begin, end]() {
            unsigned long localCount[LETTER_COUNT] = {0};
            double localSum = 0.0;

            for (size_t i = begin; i < end; ++i) {
                unsigned char c = ctx.content[i];
                localSum += std::sqrt(c);

                if (std::isalpha(c)) {
                    char l = std::tolower(c);
                    localCount[l - 'a']++;
                }
            }

            std::lock_guard<std::mutex> lock(ctx.mutex);
            for (int i = 0; i < LETTER_COUNT; ++i)
                ctx.count[i] += localCount[i];
            ctx.sumOfSquares += localSum;
        });
    }

    for (auto& t : threads)
        t.join();

    for (int i = 0; i < LETTER_COUNT; ++i)
        std::cout << char('a' + i) << ": " << ctx.count[i] << '\n';

    std::cout << "Suma pierwiastków ASCII: " << ctx.sumOfSquares << '\n';
}

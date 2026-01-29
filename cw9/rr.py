import csv
import sys
from collections import deque

class Process:
    def __init__(self, name, length, start):
        self.name = name
        self.remaining_time = int(length)
        self.start_time = int(start)
        self.initial_length = int(length)

    def __repr__(self):
        return f"{self.name}(left={self.remaining_time})"

class RoundRobinScheduler:
    def __init__(self, quantum, processes_list):
        self.quantum = quantum
        # Kolejka procesów, które jeszcze nie pojawiły się w systemie
        self.waiting_to_arrive = deque(processes_list)
        # Kolejka procesów gotowych do wykonania (ready queue)
        self.ready_queue = deque()
        self.current_time = 0

    def run(self):
        while self.waiting_to_arrive or self.ready_queue:
            # 1. Sprawdź, czy w tym czasie (T) pojawiają się nowe procesy
            arrived_now = False
            while self.waiting_to_arrive and self.waiting_to_arrive[0].start_time == self.current_time:
                p = self.waiting_to_arrive.popleft()
                self.ready_queue.append(p)
                print(f"T={self.current_time}: New process {p.name} is waiting for execution (length={p.initial_length})")
                arrived_now = True

            # 2. Jeśli nic nie ma w kolejce gotowych
            if not self.ready_queue:
                if self.waiting_to_arrive:
                    print(f"T={self.current_time}: No processes currently available")
                    self.current_time += 1
                    continue
                else:
                    break

            # 3. Pobierz proces z kolejki gotowych
            current_process = self.ready_queue.popleft()
            
            # Oblicz czas pracy (minimum z kwantu i pozostałego czasu procesu)
            run_time = min(self.quantum, current_process.remaining_time)
            
            print(f"T={self.current_time}: {current_process.name} will be running for {run_time} time units. "
                  f"Time left: {current_process.remaining_time - run_time}")

            # Symulacja upływu czasu
            for _ in range(run_time):
                self.current_time += 1
                # W trakcie trwania kwantu mogą pojawić się nowe procesy!
                while self.waiting_to_arrive and self.waiting_to_arrive[0].start_time == self.current_time:
                    p = self.waiting_to_arrive.popleft()
                    self.ready_queue.append(p)
                    print(f"T={self.current_time}: New process {p.name} is waiting for execution (length={p.initial_length})")

            current_process.remaining_time -= run_time

            # 4. Jeśli proces skończył działanie
            if current_process.remaining_time == 0:
                print(f"T={self.current_time}: Process {current_process.name} has been finished")
            else:
                # Jeśli nie skończył, wraca na koniec kolejki gotowych
                self.ready_queue.append(current_process)

        print(f"T={self.current_time}: No more processes in queues")

def main():
    if len(sys.argv) < 3:
        print("Użycie: python rr.py <plik.csv> <kwant>")
        return

    file_path = sys.argv[1]
    quantum = int(sys.argv[2])
    processes = []

    try:
        with open(file_path, mode='r') as f:
            reader = csv.reader(f)
            for row in reader:
                if row:
                    processes.append(Process(row[0], row[1], row[2]))
    except FileNotFoundError:
        print("Błąd: Nie znaleziono pliku CSV.")
        return

    scheduler = RoundRobinScheduler(quantum, processes)
    scheduler.run()

if __name__ == "__main__":
    main()

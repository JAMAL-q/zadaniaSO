import os
import pwd 

def main():
    print(f"{'USER':<15}{'PID':<10}{'COMMAND'}")
    for pid in os.listdir('/proc'):
        if not pid.isdigit():
            continue
        
        try:
            with open(f"/proc/{pid}/comm") as f:
                comm = f.readline().strip()
        
            uid = None
            with open(f"/proc/{pid}/status") as f:
                for line in f:
                    if line.startswith("Uid:"):
                        uid = int(line.split()[1])
                        break

            user = pwd.getpwuid(uid).pw_name if uid is not None else "?"

            print(f"{user:<15}{pid:<10}{comm}")

        except FileNotFoundError:
            continue

        except PermissionError:
            continue


if __name__ == "__main__":
    main()
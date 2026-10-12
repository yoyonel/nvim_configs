#!/usr/bin/env python3
"""
Test automatisé du rendu de Neovim via pseudo-terminal (PTY).
Vérifie qu'aucun surlignement parasite (vidéo inverse / standout / couleur fond 103)
n'est présent sur le tableau de bord Alpha.
"""
import os
import pty
import re
import select
import sys
import time

def run_test():
    master, slave = pty.openpty()
    pid = os.fork()

    if pid == 0:
        os.close(master)
        os.setsid()
        import fcntl, struct, termios
        winsize = struct.pack("HHHH", 45, 120, 0, 0)
        fcntl.ioctl(slave, termios.TIOCSWINSZ, winsize)
        os.dup2(slave, 0)
        os.dup2(slave, 1)
        os.dup2(slave, 2)
        os.close(slave)
        env = os.environ.copy()
        env["TERM"] = "screen-256color"
        os.execvpe("nvim", ["nvim"], env)
    else:
        os.close(slave)
        output = b""
        start = time.time()
        while time.time() - start < 3.0:
            r, _, _ = select.select([master], [], [], 0.3)
            if r:
                try:
                    data = os.read(master, 4096)
                    if not data:
                        break
                    output += data
                except OSError:
                    break
            else:
                if len(output) > 5000:
                    break
        os.write(master, b":qa!\r")
        time.sleep(0.3)
        os.close(master)
        os.waitpid(pid, 0)

    raw = output.decode("utf-8", errors="ignore")

    # Vérifications
    bad_bg = re.findall(r"\x1b\[48;2;135;135;175m", raw)
    inv_codes = re.findall(r"\x1b\[(?:[0-9;]*;)?7m", raw)

    errors = []
    if bad_bg:
        errors.append(f"Couleur de fond parasite #8787af détectée ({len(bad_bg)} fois)")
    if inv_codes:
        errors.append(f"Codes vidéo inverse (\\x1b[7m) détectés ({len(inv_codes)} fois)")

    if "Raccourcis Clavier" not in raw:
        errors.append("Le cheatsheet des raccourcis n'a pas été trouvé dans le rendu PTY")

    if errors:
        for err in errors:
            print(f"❌ {err}", file=sys.stderr)
        sys.exit(1)

    print("✅ Rendu PTY Neovim valide : aucun surlignement ou vidéo inverse détecté.")

if __name__ == "__main__":
    run_test()

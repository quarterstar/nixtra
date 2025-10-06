#!/usr/bin/env python3

import os, json, hashlib, hmac, binascii, sys
import getpass

SANDBOX_DIR = sys.argv[1]
SIGNATURE_FILE = os.path.join(SANDBOX_DIR, ".signature.json")

def iter_files(root):
    for dirpath, dirs, files in os.walk(root):
        dirs.sort()
        files.sort()
        for f in files:
            if f == ".signature.json":
                continue  # skip signature file itself
            yield os.path.join(dirpath, f)

def file_sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        while True:
            blk = fh.read(8192)
            if not blk:
                break
            h.update(blk)
    return h.hexdigest()

def build_manifest(root):
    root = os.path.abspath(root)
    lines = []
    for full in iter_files(root):
        rel = os.path.relpath(full, root)
        sha = file_sha256(full)
        size = os.path.getsize(full)
        lines.append(f"{rel}\t{size}\t{sha}")
    manifest = "\n".join(lines).encode("utf-8")
    return manifest


def get_password_confirm():
    while True:
        pw1 = getpass.getpass("Password: ")
        pw2 = getpass.getpass("Confirm password: ")
        if pw1 == pw2:
            return pw1
        print("Passwords do not match. Please try again.")


def main():
    if not os.path.isdir(SANDBOX_DIR):
        print("Directory does not exist:", SANDBOX_DIR, file=sys.stderr)
        sys.exit(1)

    password = get_password_confirm()
    password = password.encode("utf-8")

    manifest = build_manifest(SANDBOX_DIR)
    manifest_hash = hashlib.sha256(manifest).hexdigest()

    salt = os.urandom(16)
    iterations = 200_000

    key = hashlib.pbkdf2_hmac("sha256", password, salt, iterations, dklen=32)
    mac = hmac.new(key, manifest_hash.encode("utf-8"), hashlib.sha256).hexdigest()

    payload = {
        "kdf": "pbkdf2_sha256",
        "salt": binascii.hexlify(salt).decode(),
        "iterations": iterations,
        "hmac": mac,
        "digest_algo": "sha256",
        "manifest_hash": manifest_hash,
    }

    with open(SIGNATURE_FILE, "w") as f:
        json.dump(payload, f, indent=2)
    print("Signature stored in", SIGNATURE_FILE)

if __name__ == "__main__":
    main()

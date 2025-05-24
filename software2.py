from gmssl.sm4 import CryptSM4, SM4_ENCRYPT, SM4_DECRYPT

def u32_to_bytes_be(x):
    """Chuyển 32-bit unsigned int sang 4 bytes big-endian."""
    return x.to_bytes(4, byteorder='big')

def make_test_vectors():
    """Tạo 50 bộ test: (key_bytes, plaintext_bytes)."""
    vectors = []
    common_key = bytes.fromhex("0123456789abcdeffedcba9876543210")
    for i in range(50):
        w0 = (0x11111111 * (i + 1)) & 0xFFFFFFFF
        w1 = (0x22222222 * (i + 1)) & 0xFFFFFFFF
        w2 = (0x33333333 * (i + 1)) & 0xFFFFFFFF
        w3 = (0x44444444 * (i + 1)) & 0xFFFFFFFF
        plaintext = u32_to_bytes_be(w0) + u32_to_bytes_be(w1) + \
                    u32_to_bytes_be(w2) + u32_to_bytes_be(w3)
        key = common_key if i < 25 else plaintext
        vectors.append((key, plaintext))
    return vectors

def test_sm4_vectors():
    sm4 = CryptSM4()
    vectors = make_test_vectors()
    print("Running 50 SM4 ECB test cases...\n")
    for idx, (key, pt) in enumerate(vectors, start=1):
        # Encrypt
        sm4.set_key(key, SM4_ENCRYPT)
        ct = sm4.crypt_ecb(pt)
        # Decrypt
        sm4.set_key(key, SM4_DECRYPT)
        pt2 = sm4.crypt_ecb(ct)

        ok = (pt2 == pt)
        key_hex    = key.hex()
        pt_hex     = pt.hex()
        ct_hex     = ct.hex()[:32]
        pt2_hex    = pt2.hex()

        print(f"Case {idx:02d}:")
        print(f"  Key       = {key_hex}")
        print(f"  Plain     = {pt_hex}")
        print(f"  Cipher    = {ct_hex}")
        print(f"  Decrypt   = {pt2_hex}  -> {'OK' if ok else 'FAIL'}")
        print("-" * 60)
    print("\nDone.")

if __name__ == "__main__":
    test_sm4_vectors()

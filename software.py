from gmssl.sm4 import CryptSM4, SM4_ENCRYPT, SM4_DECRYPT

# Chỉ mã hóa đúng 1 block 16 bytes (128-bit)

# key = bytes.fromhex("0123456789abcdeffedcba9876543210")  # đúng 16 bytes
# plaintext = bytes.fromhex("9152c7b25e7d4e6a25c8c16d7f2f45aa")  # đúng 16 bytes


key = bytes.fromhex("33333333333333333333333333333333")  # đúng 16 bytes
plaintext = bytes.fromhex("0123456789abcdeffedcba9876543210")  # đúng 16 bytes


crypt_sm4 = CryptSM4()
crypt_sm4.set_key(key, SM4_ENCRYPT)

# Mã hóa thủ công từng block (tránh padding)
ciphertext = crypt_sm4.crypt_ecb(plaintext[:16])  # rõ ràng chỉ 1 block
result = ciphertext.hex()
print("CIPHERTEXT :", result[:32])  # 16 bytes = 32 hex characters
if ("0de850ed65cd2eb248ca2774a79fd684" == result[:32]):
    print("Bang")
else: 
    print("Khong bang") 
# 0123456789abcdeffedcba9876543210 - 681edf34d206965e86b3e94f536e4246 - # 9338375E 82EEC1CB BEF65EDF 8757A631
# 11111111111111111111111111111111 - 6b3633a5ed04f5abd5197870b5506642 - # cb4d25566932139ddd305c782bb22862
# 22222222222222222222222222222222 - 7c3bc4eb1c18e7f1d879ea602eec46cf - # 26929e9f0aa1db106d92d01ad34d22ee
# 33333333333333333333333333333333 - 99cfe9d2b4f88cb9d52049f758e230d9
# 44444444444444444444444444444444 - d7a7d1b8c65c593ae8694c078c54e853
# 55555555555555555555555555555555 - a3ca4b36cc98e643e5ea6b78f076cd9e
# 66666666666666666666666666666666 - 4b3e79ad9e7e1e672fd1a78e9f51e758
# 77777777777777777777777777777777 - 13f996459688fd3dfd1879c28dad2af2
# 88888888888888888888888888888888 - 0de850ed65cd2eb248ca2774a79fd684

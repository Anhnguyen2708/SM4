for i in range(32):
    # Tính các giá trị CKi
    values = [((4 * i + j) * 7) % 256 for j in range(4)]
    
    # Ghép thành 32-bit word (big endian)
    word = (values[0] << 24) | (values[1] << 16) | (values[2] << 8) | values[3]
    
    print(f"assign CK[{i}] = 32'h{word:08X};")

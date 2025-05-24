#include "system.h"
#include "io.h"
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

#define SM4_BASE SM4_V2_0_BASE

int main(void) {
    const uint32_t common_key[4] = {
        0x01234567, 0x89abcdef,
        0xfedcba98, 0x76543210
    };

    uint32_t plaintexts[50][4];
    uint32_t keys[50][4];
    uint32_t ciphertexts[50][4];
    uint32_t decrypted[50][4];
    uint32_t tmp;
    int i, j;

    // 1) Khởi tạo plaintext và key
    for (i = 0; i < 50; i++) {
        //plaintext là bốn từ 0x11111111 * (i+1), 0x22222222*(i+1), ...
        plaintexts[i][0] = 0x11111111 * (i + 1);
        plaintexts[i][1] = 0x22222222 * (i + 1);
        plaintexts[i][2] = 0x33333333 * (i + 1);
        plaintexts[i][3] = 0x44444444 * (i + 1);

        if (i < 25) {
            // 25 case đầu: key cố định common_key
            for (j = 0; j < 4; j++)
                keys[i][j] = common_key[j];
        } else {
            // 25 case sau: key = plaintext
            for (j = 0; j < 4; j++)
                keys[i][j] = plaintexts[i][j];
        }
    }

    // --- PHẦN 1: MÃ HÓA 50 CASE ---
    printf("=== ENCRYPTION RESULTS (50 CASES) ===\n\n");
    for (i = 0; i < 50; i++) {
        // chọn encrypt mode
        IOWR(SM4_BASE, 10, 0);
        // nạp key
        for (j = 0; j < 4; j++)
            IOWR(SM4_BASE, j, keys[i][j]);
        // enable key expansion
        IOWR(SM4_BASE, 4, 1);
        // nạp plaintext
        for (j = 0; j < 4; j++)
            IOWR(SM4_BASE, 5 + j, plaintexts[i][j]);
        // start encrypt
        IOWR(SM4_BASE, 9, 1);
        // chờ hoàn thành
        do {
            tmp = IORD(SM4_BASE, 15) & 0x1;
        } while (!tmp);
        // đọc ciphertext
        for (j = 0; j < 4; j++)
            ciphertexts[i][j] = IORD(SM4_BASE, 11 + j);

        // in kết quả encrypt
        printf("Enc Case %2d: Key =", i+1);
        for (j = 0; j < 4; j++)
            printf(" 0x%08" PRIx32, keys[i][j]);
        printf("  |  Plain =");
        for (j = 0; j < 4; j++)
            printf(" 0x%08" PRIx32, plaintexts[i][j]);
        printf("  |  Cipher =");
        for (j = 0; j < 4; j++)
            printf(" 0x%08" PRIx32, ciphertexts[i][j]);
        printf("\n");
    }

    // --- PHẦN 2: GIẢI MÃ 50 CASE ---
    printf("\n=== DECRYPTION RESULTS (50 CASES) ===\n\n");
    for (i = 0; i < 50; i++) {
        // chọn decrypt mode
        IOWR(SM4_BASE, 10, 1);
        // nạp lại key
        for (j = 0; j < 4; j++)
            IOWR(SM4_BASE, j, keys[i][j]);
        // enable key expansion
        IOWR(SM4_BASE, 4, 1);
        // nạp ciphertext
        for (j = 0; j < 4; j++)
            IOWR(SM4_BASE, 5 + j, ciphertexts[i][j]);
        // start decrypt
        IOWR(SM4_BASE, 9, 1);
        // chờ hoàn thành
        do {
            tmp = IORD(SM4_BASE, 15) & 0x1;
        } while (!tmp);
        // đọc decrypted
        for (j = 0; j < 4; j++)
            decrypted[i][j] = IORD(SM4_BASE, 11 + j);

        // in kết quả decrypt
        printf("Dec Case %2d: Cipher =", i+1);
        for (j = 0; j < 4; j++)
            printf(" 0x%08" PRIx32, ciphertexts[i][j]);
        printf("  |  Decrypt =");
        for (j = 0; j < 4; j++)
            printf(" 0x%08" PRIx32, decrypted[i][j]);
        printf("  |  OrigPlain =");
        for (j = 0; j < 4; j++)
            printf(" 0x%08" PRIx32, plaintexts[i][j]);
        printf("\n");
    }

    return 0;
}

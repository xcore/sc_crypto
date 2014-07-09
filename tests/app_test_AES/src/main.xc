#include "AESfunctions.h"
#include <string.h>
#include <print.h>
#include <stdlib.h>

typedef struct testvec_t {
  unsigned char key[16];
  unsigned char plaintext[16];
  unsigned char ciphertext[16];
} testvec_t;

testvec_t vectors[] = {
#include "ECBVarTxt128.inc"
  ,
#include "ECBVarKey128.inc"
  ,
#include "ECBKeySbox128.inc"
  ,
#include "ECBGFSbox128.inc"
};

static const unsigned num_vectors = sizeof(vectors) / sizeof(vectors[0]);

int main() {
  unsigned int key[4];
  unsigned int ciphertext[4];
  unsigned int plaintext[4];
  // Test encryption.
  for (unsigned i = 0; i < num_vectors; i++) {
    testvec_t &vector = vectors[i];
    memcpy(key, vector.key, sizeof(key));
    memcpy(plaintext, vector.plaintext, sizeof(plaintext));
    memset(ciphertext, 0, sizeof(ciphertext));
    AESEncrypt(plaintext, key, ciphertext);
    if (memcmp(ciphertext, vector.ciphertext, sizeof(ciphertext)) != 0) {
      printstr("Error encrypting vector "); printintln(i);
      _Exit(1);
    }
  }
  // Test decryption.
  for (unsigned i = 0; i < num_vectors; i++) {
    testvec_t &vector = vectors[i];
    memcpy(key, vector.key, sizeof(key));
    memcpy(ciphertext, vector.ciphertext, sizeof(ciphertext));
    memset(plaintext, 0, sizeof(plaintext));
    AESDecrypt(ciphertext, key, plaintext);
    if (memcmp(plaintext, vector.plaintext, sizeof(plaintext)) != 0) {
      printstr("Error decrypting vector "); printintln(i);
      _Exit(1);
    }
  }
  printstr("All tests passed\n");
  return 0;
}

#include "AESfunctions.h"
#include <stdio.h>
#include <print.h>
#include <xs1.h>

#define REPETITIONS 10

double compute_rate(double bits, double timer_ticks)
{
  double megabits = bits / (1024 * 1024);
  double seconds = timer_ticks / XS1_TIMER_HZ;
  return megabits / seconds;
}

int main() {
  timer t;
  unsigned t1, t2;
  unsigned int w[Nb * (Nr + 1)];
  unsigned int key[4] = {0};
  unsigned int ciphertext[4] = {0};
  unsigned int plaintext[4] = {0};

  t :> t1;
  for (int i = 0; i < REPETITIONS; i++) {
    AESDecryptExpandKey(key, w);
  }
  t :> t2;
  printf("Key expansion (decrypt): %d ticks\n", (t2 - t1) / REPETITIONS);

  t :> t1;
  for (int i = 0; i < REPETITIONS; i++) {
    AESDecryptBlock(ciphertext, w, plaintext);
  }
  t :> t2;
  printf("Decrypt speed: %02f Mbit/s\n", compute_rate(128, (double)(t2 - t1) / REPETITIONS));

  t :> t1;
  for (int i = 0; i < REPETITIONS; i++) {
    AESEncryptExpandKey(key, w);
  }
  t :> t2;
  printf("Key expansion (encrypt): %d ticks\n", (t2 - t1) / REPETITIONS);

  t :> t1;
  for (int i = 0; i < REPETITIONS; i++) {
    AESEncryptBlock(plaintext, w, ciphertext);
  }
  t :> t2;
  printf("Encrypt speed: %02f Mbit/s\n", compute_rate(128, (double)(t2 - t1) / REPETITIONS));

  return 0;
}

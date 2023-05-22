#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  char *pane_pid = argv[9];
  FILE *statFP;
  int oldNumbers[7];
  int newNumbers[7];
  int diffNumbers[7];
  char cpu[10]; // Not used

  statFP = fopen("/proc/stat", "r");

  fscanf(statFP, "%s %d %d %d %d %d %d %d", cpu, &oldNumbers[0], &oldNumbers[1],
         &oldNumbers[2], &oldNumbers[3], &oldNumbers[4], &oldNumbers[5],
         &oldNumbers[6]);

  sleep(1);
  rewind(statFP);

  fscanf(statFP, "%s %d %d %d %d %d %d %d", cpu, &newNumbers[0], &newNumbers[1],
         &newNumbers[2], &newNumbers[3], &newNumbers[4], &newNumbers[5],
         &newNumbers[6]);

  fclose(statFP);

  for (int ii = 0; ii < 7; ii++) {
    diffNumbers[ii] = newNumbers[ii] - oldNumbers[ii];
    printf("%d: %d\n", ii, diffNumbers[ii]);
  }
  return 0;
}

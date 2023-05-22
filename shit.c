

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
  // Check for valid number of arguments
  if (argc != 2) {
    printf("Error: Invalid number of arguments.\n");
    return 1;
  }

  // Get the parent pid from the command line argument
  int parent_pid = atoi(argv[1]);

  // Open the file containing the list of child pids
  char filename[50];
  sprintf(filename, "/proc/%d/task/%d/children", parent_pid, parent_pid);
  FILE *fp = fopen(filename, "r");
  if (fp == NULL) {
    printf("Error: Could not open file.\n");
    return 1;
  }

  // Read the first line of the file to get the child pid
  int child_pid;
  fscanf(fp, "%d", &child_pid);
  fclose(fp);

  // Get the time the child has used the CPU by reading /proc/{pid}/stat
  char stat_filename[50];
  sprintf(stat_filename, "/proc/%d/stat", child_pid);
  fp = fopen(stat_filename, "r");
  if (fp == NULL) {
    printf("Error: Could not open file.\n");
    return 1;
  }

  // Read the 14th and 15th fields of the stat file
  int utime, stime;
  for (int i = 0; i < 14; i++) {
    fscanf(fp, "%*s");
  }
  fscanf(fp, "%d %d", &utime, &stime);
  fclose(fp);

  // Wait half a second
  sleep(1);

  // Read the stat file again
  fp = fopen(stat_filename, "r");
  if (fp == NULL) {
    printf("Error: Could not open file.\n");
    return 1;
  }

  // Read the 14th and 15th fields of the stat file
  int utime2, stime2;
  for (int i = 0; i < 14; i++) {
    fscanf(fp, "%*s");
  }
  fscanf(fp, "%d %d", &utime2, &stime2);
  fclose(fp);

  // Calculate the CPU usage
  int elapsed_time = (utime2 + stime2) - (utime + stime);
  float cpu_usage = (float)elapsed_time / 0.5;

  // Print the result
  printf("elapsed: %d\n", elapsed_time);
  printf("%d %d\n", utime, stime);
  printf("%d %d\n", utime2, stime2);
  printf("Child pid: %d\n", child_pid);
  printf("CPU usage: %f\n", cpu_usage);

  return 0;
}

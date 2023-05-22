#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

// gcc window.c -o window; ./window $(tmux display -p "#{window_active}
// #{window_index} '#{window_name}' #{window_marked_flag} #{window_bell_flag}
// #{window_last_flag} #{window_zoomed_flag} #{pane_in_mode} #{pane_pid}")

long get_cpu_usage(int pid) {
  char *filename;
  asprintf(&filename, "/proc/%d/stat", pid);
  FILE *fp = fopen(filename, "r");
  if (fp == NULL) {
    return -1;
  }
  long utime, stime;
  fscanf(fp, "%*d %*s %*c %*d %*d %*d %*d %*d %*u %*u %*u %*u %*u %lu %lu",
         &utime, &stime);
  fclose(fp);
  return utime + stime;
}

char *ACTIVE_FG = "colour223,bold";
char *ACTIVE_MARKED_BG = "colour67";
char *ACTIVE_BG = "colour66";

char *BELL_BG = "colour167";

char *INACTIVE_FG = "colour223";
char *INACTIVE_BG = "colour239";
char *INACTIVE_MARKED_BG = "colour243";

int main(int argc, char *argv[]) {
  struct timespec start, end;

  char *pane_pid = argv[9];
  char *children_path;
  asprintf(&children_path, "/proc/%s/task/%s/children", pane_pid, pane_pid);
  FILE *children_fp = fopen(children_path, "r");
  int child;
  fscanf(children_fp, "%d", &child);
  fclose(children_fp);

  clock_gettime(CLOCK_REALTIME, &start);
  long cpu_start = get_cpu_usage(child);

  char *window_active = argv[1];
  char *window_index = argv[2];
  char *window_name = argv[3];
  char *window_marked_flag = argv[4];
  char *window_bell_flag = argv[5];
  char *window_last_flag = argv[6];
  char *window_zoomed_flag = argv[7];
  char *pane_in_mode = argv[8];

  char *bg;
  char *fg;

  char *bell = "";
  if (strcmp(window_active, "1") == 0) {
    fg = ACTIVE_FG;
    if (strcmp(window_marked_flag, "1") == 0) {
      bg = ACTIVE_MARKED_BG;
    } else {
      bg = ACTIVE_BG;
    }
  } else {
    fg = INACTIVE_FG;
    if (strcmp(window_bell_flag, "1") == 0) {
      bg = BELL_BG;
      bell = "!";
    } else if (strcmp(window_marked_flag, "1") == 0) {
      bg = INACTIVE_MARKED_BG;
    } else {
      bg = INACTIVE_BG;
    }
  }

  char *left;
  char *right;
  if (strcmp(window_zoomed_flag, "1") == 0) {
    left = "(";
    right = ")";
  } else if (strcmp(pane_in_mode, "1") == 0) {
    left = "[";
    right = "]";
  } else {
    left = " ";
    right = " ";
  }

  char *last;
  if (strcmp(window_last_flag, "1") == 0) {
    last = "-";
  } else {
    last = " ";
  }

  usleep(10000);

  long cpu_end = get_cpu_usage(child);
  clock_gettime(CLOCK_REALTIME, &end);
  double cpu = (double)(cpu_end - cpu_start) / sysconf(_SC_CLK_TCK);
  double elapsed =
      ((end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec)) /
      1000000000.0;
  double usage = cpu / elapsed;

  char *program;
  char *spacing;
  if (child != 0) {
    if (usage > 0.5) {
      program = "!";
    } else {
      program = ".";
    }
    spacing = "";
  } else {
    program = "";
    spacing = " ";
  }

  printf("#[bg=%s,fg=%s] %s%s%s%s%s%s%s%s", bg, fg, last,
         window_index, left, window_name, program, bell, right, spacing);

  return 0;
}

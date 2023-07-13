#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

// gcc window.c -o window; ./window $(tmux display -p "#{window_active}
// #{window_index} '#{window_name}' #{window_marked_flag} #{window_bell_flag}
// #{window_last_flag} #{window_zoomed_flag} #{pane_in_mode} #{pane_pid}")

char *ACTIVE_FG = "colour223,bold";
char *ACTIVE_MARKED_BG = "colour67";
char *ACTIVE_BG = "colour66";

char *BELL_BG = "colour167";

char *INACTIVE_FG = "colour223";
char *INACTIVE_BG = "colour239";
char *INACTIVE_MARKED_BG = "colour243";

long get_cpu_usage(int pid) {
  char *filename;
  asprintf(&filename, "/proc/%d/stat", pid);
  FILE *fp = fopen(filename, "r");
  long utime, stime;
  fscanf(fp, "%*d %*s %*c %*d %*d %*d %*d %*d %*u %*u %*u %*u %*u %lu %lu",
         &utime, &stime);
  fclose(fp);
  return utime + stime;
}

long get_total_cpu() {
  char *filename = "/proc/stat";
  FILE *fp = fopen(filename, "r");
  int user, nice, system, idle;
  fscanf(fp, "%*s %d %d %d %d", &user, &nice, &system, &idle);
  long total = user + nice + system + idle;
  fclose(fp);

  return total;
}

int get_child_pid(char *pane_pid, int *child_pid) {
  char *children_path;
  asprintf(&children_path, "/proc/%s/task/%s/children", pane_pid, pane_pid);
  FILE *children_fp = fopen(children_path, "r");
  int child = fscanf(children_fp, "%d", child_pid) == 1;
  fclose(children_fp);

  return child;
}

void get_colors(char **bg, char **fg, char *window_active,
                char *window_marked_flag, char *window_bell_flag) {
  if (strcmp(window_active, "1") == 0) {
    *fg = ACTIVE_FG;
    if (strcmp(window_marked_flag, "1") == 0) {
      *bg = ACTIVE_MARKED_BG;
    } else {
      *bg = ACTIVE_BG;
    }
  } else {
    *fg = INACTIVE_FG;
    if (strcmp(window_bell_flag, "1") == 0) {
      *bg = BELL_BG;
    } else if (strcmp(window_marked_flag, "1") == 0) {
      *bg = INACTIVE_MARKED_BG;
    } else {
      *bg = INACTIVE_BG;
    }
  }
}

void get_left_right(char **left, char **right, char *window_zoomed_flag, char *pane_in_mode) {
  if (strcmp(window_zoomed_flag, "1") == 0) {
    *left = "(";
    *right = ")";
  } else if (strcmp(pane_in_mode, "1") == 0) {
    *left = "[";
    *right = "]";
  } else {
    *left = " ";
    *right = " ";
  }
}

void get_last(char **last, char *window_last_flag) {
  if (strcmp(window_last_flag, "1") == 0) {
    *last = "-";
  } else {
    *last = " ";
  }
}

int main(int argc, char *argv[]) {
  char *pane_pid = argv[9];
  int child_pid;
  int child = get_child_pid(pane_pid, &child_pid);

  long total_cpu_start;
  long child_cpu_start;
  if (child) {
    total_cpu_start = get_total_cpu();
    child_cpu_start = get_cpu_usage(child_pid);
  }

  char *window_index = argv[1];
  char *window_name = argv[2];
  char *window_active_flag = argv[3];
  char *window_marked_flag = argv[4];
  char *window_bell_flag = argv[5];
  char *window_last_flag = argv[6];
  char *window_zoomed_flag = argv[7];
  char *pane_in_mode = argv[8];

  char *bg;
  char *fg;
  get_colors(&bg, &fg, window_active_flag, window_marked_flag, window_bell_flag);

  char *left;
  char *right;
  get_left_right(&left, &right, window_zoomed_flag, pane_in_mode);

  char *last;
  get_last(&last, window_last_flag);

  usleep(15000);

  float usage;
  if (child) {
    long child_cpu_end = get_cpu_usage(child_pid);
    long total_cpu_end = get_total_cpu();

    usage = sysconf(_SC_NPROCESSORS_ONLN) *
            (float)(child_cpu_end - child_cpu_start) /
            (float)(total_cpu_end - total_cpu_start);
  }

  char *program;
  char *spacing;
  if (child_pid != 0) {
    if (usage > 0.1) {
      program = "!";
    } else {
      program = ".";
    }
    spacing = "";
  } else {
    program = "";
    spacing = " ";
  }

  printf("#[bg=%s,fg=%s] %s%s%s%s%s%s%s", bg, fg, last, window_index, left,
         window_name, program, right, spacing);

  return 0;
}

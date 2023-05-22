#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>

// gcc window.c -o window; ./window $(tmux display -p "#{window_active}
// #{window_index} '#{window_name}' #{window_marked_flag} #{window_bell_flag}
// #{window_last_flag} #{window_zoomed_flag} #{pane_in_mode} #{pane_pid}")

char *SESSION_FG = "colour237,bold";
char *SESSION_BG = "colour172";

int main(int argc, char *argv[]) {
  char *session_group_size = argv[1];
  char *session_name = argv[2];

  char *style;
  if (strcmp(session_group_size, "1") != 0) {
    style = ",italics";
  } else {
    style = "";
  }

  printf("#[bg=%s,fg=%s%s]  %s  ", SESSION_BG, SESSION_FG, style, session_name);

  return 0;
}

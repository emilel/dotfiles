#include <stdio.h>
#include <string.h>

char *FOLDER_FG = "colour223";
char *FOLDER_BG = "colour132";

char *HOST_FG = "colour237,bold";
char *HOST_BG = "colour142";

char *TMUX_FG = "colour237,bold";
char *TMUX_BG = "colour166";

int main(int argc, char *argv[]) {
  char *pane_current_path = argv[1];
  char *user = argv[2];
  char *host = argv[3];

  char *directory = strrchr(pane_current_path, '/') + 1;

  char *path;
  int n_sessions = 0;
  FILE *fp = popen("tmux list-sessions -F ''", "r");
  while (fgets(path, sizeof(path), fp) != NULL) {
    n_sessions++;
  }

  printf("#[bg=%s,fg=%s]  %s  #[bg=%s,fg=%s]  %s@%s  #[bg=%s,fg=%s]  %d  ",
         FOLDER_BG, FOLDER_FG, directory, HOST_BG, HOST_FG, user, host, TMUX_BG,
         TMUX_FG, n_sessions);

  return 0;
}

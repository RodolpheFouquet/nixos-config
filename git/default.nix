{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Rodolphe Fouquet";
    userEmail = "rodolphe@unicowd.com";
    extraConfig = {
      core = {
        editor = "nvim";
        pager = "diff-so-fancy | less --tabs=4 -RFX";
      };
      color = {
        ui = true;
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoStash = true;
      };
      rerere = {
        enabled = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      branch = {
        autoSetupMerge = "always";
        autoSetupRebase = "always";
      };
      merge = {
        conflictStyle = "diff3";
      };
      diff = {
        algorithm = "patience";
        compactionHeuristic = true;
      };
      status = {
        showUntrackedFiles = "all";
      };
      log = {
        abbrevCommit = true;
        follow = true;
      };
      format = {
        pretty = "format:%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset";
      };
      interactive = {
        singleKey = true;
      };
      init = {
        defaultBranch = "master";
      };
    };
  };

  programs.fish.shellAliases = {
    g = "git";
    gs = "git status";
    ga = "git add";
    gap = "git add --patch";
    gaa = "git add --all";
    gc = "git commit";
    gcm = "git commit -m";
    gd = "git diff";
    gds = "git diff --staged";
    gl = "git log --graph";
    gp = "git push";
    gpl = "git pull";
  };
}
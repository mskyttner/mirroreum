#!/usr/bin/Rscript

library(dplyr)
library(readr)

accounts <- read_csv("accounts/credentials_history.csv")

usermigrate <- function(
  user, pass, base = "/home/rstudio/researchers", 
  home = file.path(base, user), skel = home) 
{
  useradd <- sprintf(paste0(
    "sudo useradd --create-home --shell /bin/bash ",
    "--base-dir %s ",
    "--home-dir %s ",
    "--skel %s ",
    "--password `openssl passwd -1 %s` %s"),
    base, home, skel, pass, user
  )
  
  update <- sprintf(
    "sudo cp -r /home/rstudio/skeleton/. %s && sudo chown -R %s:%s %s", 
    home, user, user, home
  )
  
  paste0(useradd, " \n ", update)
}


sh_migrate <- function(cmd) {
  paste0("#!/bin/bash
# execute this script as super user! 
# (ie chmod +x and sudo ./scriptname.sh)
", paste(collapse = "\n", cmd))
}

accounts %>% 
  mutate(sh = usermigrate(Login, Pass)) %>% 
  pull(sh) %>% 
  sh_migrate() %>% 
  write(file = "accounts/migrate.sh")

# NOTES for user migration

# To include /etc/passwd and /etc/shadow in an existing volume....
# create symbolic links in $HOME/accounts for /etc/passwd and /etc/shadow?
# sudo cp -s /etc/passwd /etc/shadow /home/rstudio/accounts


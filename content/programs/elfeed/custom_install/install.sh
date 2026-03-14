#!/bin/bash
# Install elfeed via Emacs package system
emacs --batch --eval "(progn
  (require 'package)
  (add-to-list 'package-archives '(\"melpa\" . \"https://melpa.org/packages/\") t)
  (package-initialize)
  (package-refresh-contents)
  (package-install 'elfeed)
  (message \"elfeed installed successfully\"))"

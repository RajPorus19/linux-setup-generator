#!/bin/bash
# Install telega.el via Emacs package system
emacs --batch --eval "(progn
  (require 'package)
  (add-to-list 'package-archives '(\"melpa\" . \"https://melpa.org/packages/\") t)
  (package-initialize)
  (package-refresh-contents)
  (package-install 'telega)
  (message \"telega installed. TDLib server will be compiled on first launch.\"))"

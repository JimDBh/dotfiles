;;; init.el --- Emacs main configuration file
;;; Commentary:
;;; Emacs config by Andrey Orst
;;; Main config is located in .emacs.d/config.org
;;; This file contains some speed hacks taken from Doom Emacs
;;; Code:

;; -*- lexical-binding: t; -*-

(defvar my--gc-cons-threshold gc-cons-threshold)
(defvar my--gc-cons-percentage gc-cons-percentage)
(defvar my--file-name-handler-alist file-name-handler-alist)

(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6
      message-log-max 16384
      auto-window-vscroll nil
      package-enable-at-startup nil
      file-name-handler-alist nil)

(add-hook 'after-init-hook (lambda ()
                             (setq gc-cons-threshold my--gc-cons-threshold
                                   gc-cons-percentage my--gc-cons-percentage
                                   file-name-handler-alist my--file-name-handler-alist)))

(setq package-enable-at-startup nil
      package--init-file-ensured t)

(setq inhibit-splash-screen t)

(setq initial-major-mode 'org-mode)

(setq initial-scratch-message "")

(ignore-errors
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (tooltip-mode -1)
  (fset 'menu-bar-open nil))

(setq-default frame-title-format '("%b — Emacs"))

(setq mode-line-in-non-selected-windows nil)

(setq column-number-mode t
      size-indication-mode 0)

(set-face-attribute 'default nil :font "Source Code Pro-10")

(setq-default indent-tabs-mode nil
              scroll-step 1
              scroll-conservatively 10000
              auto-window-vscroll nil
              scroll-margin 3)

(setq default-input-method 'russian-computer)

(savehist-mode 1)

(add-hook 'prog-mode-hook 'show-paren-mode)

(setq ring-bell-function 'ignore)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file :noerror)

(setq backup-by-copying t
      create-lockfiles nil
      backup-directory-alist '(("." . "~/.cache/emacs-backups"))
      auto-save-file-name-transforms '((".*" "~/.cache/emacs-backups" t)))

(fset 'yes-or-no-p 'y-or-n-p)

(add-hook 'after-init-hook (lambda () (setq echo-keystrokes 3)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defun my/ensure-installed (package)
  "Ensure that PACKAGE is installed."
  (when (not (package-installed-p package))
    (package-install package)))

(defun my/autokill-when-no-processes (&rest args)
  "Kill buffer and its window automatically when there's no processes left."
  (when (null (get-buffer-process (current-buffer)))
      (kill-buffer (current-buffer))
      (delete-window)))

(advice-add 'term-handle-exit :after #'my/autokill-when-no-processes)

(defun my/org-update-inline-images ()
  "Update inline images in Org-mode."
  (when org-inline-image-overlays
    (org-redisplay-inline-images)))

(defun my/move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(global-set-key (kbd "M-p") 'my/move-line-up)

(defun my/move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key (kbd "M-n") 'my/move-line-down)

(defun my/org-tangle-on-config-save ()
  "Tangle source code blocks when configuration file is saved."
  (when (string= buffer-file-name (file-truename "~/.emacs.d/config.org"))
    (org-babel-tangle)
    (byte-compile-file "~/.emacs.d/init.el")
    (load-file "~/.emacs.d/init.elc")))

(add-hook 'after-save-hook 'my/org-tangle-on-config-save)

(defun my/set-frame-dark (&optional frame)
  "Set FRAME titlebar colorscheme to dark variant."
  (with-selected-frame (or frame (selected-frame))
  (call-process-shell-command (concat "xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT \"dark\" -name \""
                                      (frame-parameter frame 'name)
                                      "\""))))

(defun my/disable-fylcheck-in-org-src-block ()
  "Disable checkdoc in emacs-lisp buffers."
  (setq-local flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

(defun my/escape ()
  "Quit in current context.

When there is an active minibuffer and we are not inside it close
it. When we are inside the minibuffer use the regular
`minibuffer-keyboard-quit' which quits any active region before
exiting. When there is no minibuffer `keyboard-quit' unless we
are defining or executing a macro."
  (interactive)
  (cond ((active-minibuffer-window)
         (if (minibufferp)
             (minibuffer-keyboard-quit)
           (abort-recursive-edit)))
        (t
         ;; ignore top level quits for macros
         (unless (or defining-kbd-macro executing-kbd-macro)
           (keyboard-quit)))))

(global-set-key [remap keyboard-quit] #'my/escape)

(defun my/ansi-term-toggle ()
  "Toggle ansi-term window on and off with the same command."
  (interactive)
  (defvar my--ansi-term-name "ansi-term-popup")
  (defvar my--window-name (concat "*" my--ansi-term-name "*"))
  (cond ((get-buffer-window my--window-name)
         (delete-window
          (get-buffer-window my--window-name)))
        (t (split-window-below)
           (other-window 1)
           (cond ((get-buffer my--window-name)
                  (switch-to-buffer my--window-name))
                 (t (ansi-term "bash" my--ansi-term-name))))))

(global-set-key "\C-t" 'my/ansi-term-toggle)

(defun my/select-line ()
  "Select the current line"
  (interactive)
  (end-of-line)
  (set-mark (line-beginning-position)))

(global-set-key (kbd "C-c x") 'my/select-line)

(require 'org)
(add-hook 'org-mode-hook (lambda()
                           (flyspell-mode)
                           (setq default-justification 'full
                                 org-startup-with-inline-images t
                                 org-startup-folded 'content
                                 org-hide-emphasis-markers t
                                 org-highlight-latex-and-related '(latex)
                                 revert-without-query '(".*\.pdf"))
                           (auto-fill-mode)))

(setq org-src-fontify-natively t)

(add-hook 'org-src-mode-hook 'my/disable-fylcheck-in-org-src-block)

(add-hook 'org-babel-after-execute-hook 'my/org-update-inline-images)

(setq org-preview-latex-image-directory ".ltximg/")

(define-key org-mode-map [backtab] nil)
(define-key org-mode-map [S-iso-lefttab] nil)
(define-key org-mode-map [C-tab] nil)
(define-key org-mode-map [C-tab] 'org-shifttab)

(require 'ox-latex)
(setq org-latex-listings 'minted)

(defvar minted-cache-dir
  (file-name-as-directory
   (expand-file-name ".minted/\\jombname"
                     temporary-file-directory)))

(add-to-list 'org-latex-packages-alist
             `(,(concat "cachedir=" minted-cache-dir)
               "minted" nil))

(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(eval-after-load 'org
  '(add-to-list 'org-latex-logfiles-extensions "tex"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((gnuplot . t)
   (scheme . t)))

(setq org-confirm-babel-evaluate nil)

(add-to-list 'org-latex-classes
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

(require 'ox-md nil t)

(defun my/flyspell-buffer-after-pdict-save (&rest _)
  (flyspell-buffer))

(advice-add 'ispell-pdict-save :after #'my/flyspell-buffer-after-pdict-save)

(add-hook 'emacs-lisp-mode-hook 'flycheck-mode)

(setq doc-view-resolution 192)

(my/ensure-installed 'use-package)
(require 'use-package)
(setq use-package-always-ensure t)

(use-package hydra
  :commands (hydra-default-pre
             hydra-keyboard-quit
             hydra--call-interactively-remap-maybe
             hydra-show-hint
             hydra-set-transient-map)
  :bind (("<f5>" . hydra-zoom/body))
  :config
  (defhydra hydra-zoom (:hint nil)
    "Scale text"
    ("+" text-scale-increase "in")
    ("-" text-scale-decrease "out")
    ("0" (text-scale-set 0) "reset")))

(use-package spacemacs-common
    :ensure spacemacs-theme
    :config (load-theme 'spacemacs-dark t)
      (let ((line (face-attribute 'mode-line :underline)))
        (set-face-attribute 'mode-line          nil :overline   line)
        (set-face-attribute 'mode-line-inactive nil :overline   line)
        (set-face-attribute 'mode-line-inactive nil :underline  line)
        (set-face-attribute 'mode-line          nil :box        nil)
        (set-face-attribute 'mode-line-inactive nil :box        nil)))

(set-face-attribute 'fringe nil :background nil)
(set-face-attribute 'line-number nil :background nil)
(set-face-attribute 'header-line nil :background "#222226")

(when window-system
  (my/set-frame-dark)
  (add-hook 'after-make-frame-functions 'my/set-frame-dark :after))

(use-package markdown-mode
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (defvar markdown-command "multimarkdown"))

(add-hook 'markdown-mode-hook
          '(lambda()
             (flyspell-mode)
             (setq fill-column 80
                   default-justification 'left)
             (auto-fill-mode)))

(use-package geiser
  :config
  (add-hook 'scheme-mode-hook 'geiser-mode)
  (advice-add 'geiser-repl-exit :after #'my/autokill-when-no-processes)
  :init
  (setq geiser-active-implementations '(guile)
        geiser-default-implementation 'guile))

(use-package parinfer
  :commands parinfer-mode
  :bind
  (("C-," . parinfer-toggle-mode))
  :init
  (progn
    (setq parinfer-extensions
          '(defaults
             pretty-parens
             smart-tab
             smart-yank))
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))

(use-package flx)

(use-package ivy
  :commands ivy-mode
  :init
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t)
  :bind (("C-x C-b" . ivy-switch-buffer)
         ("C-x b" . ivy-switch-buffer))
  :config
  (setq ivy-re-builders-alist '((t . ivy--regex-fuzzy))
        ivy-count-format ""
        ivy-display-style nil
        ivy-minibuffer-faces nil)
  (ivy-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-h f" . counsel-describe-function)
         ("C-h v" . counsel-describe-variable)
         ("C-h l" . counsel-find-library)))

(use-package flycheck)

(use-package company
  :bind (:map company-active-map
              ("TAB" . company-complete-common-or-cycle)
              ("<tab>" . company-complete-common-or-cycle)
              ("<S-Tab>" . company-select-previous)
              ("<backtab>" . company-select-previous))
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-require-match 'never
        company-minimum-prefix-length 3
        company-tooltip-align-annotations t
        company-frontends
        '(company-pseudo-tooltip-unless-just-one-frontend
          company-preview-frontend
          company-echo-metadata-frontend))
  :config
  (setq company-backends (remove 'company-clang company-backends)
        company-backends (remove 'company-xcode company-backends)
        company-backends (remove 'company-cmake company-backends)
        company-backends (remove 'company-gtags company-backends)))

(use-package undo-tree
  :commands global-undo-tree-mode
  :config
  (global-undo-tree-mode 1))

(use-package yasnippet)

(use-package projectile
  :commands projectile-mode
  :bind (("C-c p" . projectile-command-map))
  :init
  (projectile-mode +1)
  (setq projectile-svn-command "fd -L --type f --print0"
        projectile-generic-command "fd -L --type f --print0"
        projectile-completion-system 'ivy))

(use-package counsel-projectile
  :commands counsel-projectile-mode
  :config (counsel-projectile-mode))

(use-package gnuplot)

(use-package rust-mode
  :config (add-hook 'rust-mode-hook
                    '(lambda()
                       (racer-mode)
                       (yas-minor-mode)
                       (electric-pair-mode)
                       (setq company-tooltip-align-annotations t))))

(use-package racer
  :config (add-hook 'racer-mode-hook #'eldoc-mode))

(use-package toml-mode)

(use-package editorconfig
  :commands editorconfig-mode
  :config
  (editorconfig-mode 1))

(use-package magit)

(use-package vdiff
  :bind (:map vdiff-mode-map
              ("C-c" . vdiff-mode-prefix-map))
  :init (setq vdiff-lock-scrolling t
              vdiff-diff-algorithm 'diff
              vdiff-disable-folding nil
              vdiff-min-fold-size 4
              vdiff-subtraction-style 'full
              vdiff-subtraction-fill-char ?\ )
  :config
  (set-face-attribute 'vdiff-subtraction-face nil :background "#553333" :foreground "#cc99999")
  (set-face-attribute 'vdiff-addition-face nil :background "#335533" :foreground "#cceecc")
  (set-face-attribute 'vdiff-change-face nil :background "#293239" :foreground "#4f97d7")
  (add-hook 'vdiff-mode-hook #'outline-show-all))

(use-package vdiff-magit
  :commands (vdiff-magit-dwim vdiff-magit)
  :bind (:map magit-mode-map
              ("e" . 'vdiff-magit-dwim)
              ("E" . 'vdiff-magit))
  :init
  (setq vdiff-magit-stage-is-2way t)
  :config
  (transient-suffix-put 'magit-dispatch "e" :description "vdiff (dwim)")
  (transient-suffix-put 'magit-dispatch "e" :command 'vdiff-magit-dwim)
  (transient-suffix-put 'magit-dispatch "E" :description "vdiff")
  (transient-suffix-put 'magit-dispatch "E" :command 'vdiff-magit))

(use-package which-key
  :commands which-key-mode
  :init
  (which-key-mode))

(use-package multiple-cursors
  :bind (("C-S-<mouse-1>" . mc/add-cursor-on-click)
         ("C-c m" . hydra-mc/body))
  :config (defhydra hydra-mc (:color pink
                              :hint nil)
            "
^Select^               ^Discard^                   ^Move^
^──────^───────────────^───────^───────────────────^────^────────────
_M-s_ split lines      _M-SPC_ discard current     _&_ align
_s_   select regexp    _b_     discard blank lines _(_ cycle backward
_n_   select next      _d_     remove duplicated   _)_ cycle forward
_p_   select previous  _q_     exit                ^ ^
_C_   select next line"
            ("M-s" mc/edit-ends-of-lines)
            ("s" mc/mark-all-in-region-regexp)
            ("n" mc/mark-next-like-this-word)
            ("p" mc/mark-previous-like-this-word)
            ("&" mc/vertical-align-with-space)
            ("(" mc/cycle-backward)
            (")" mc/cycle-forward)
            ("M-SPC" mc/remove-current-cursor)
            ("b" mc/remove-cursors-on-blank-lines)
            ("d" mc/remove-duplicated-cursors)
            ("C" mc/mark-next-lines)
            ("q" mc/remove-duplicated-cursors :exit t)))

(use-package mc-extras
  :config
  (advice-add 'phi-search :after 'mc/remove-duplicated-cursors))

(use-package expand-region
  :commands (er/expand-region
             er/mark-paragraph
             er/mark-inside-pairs
             er/mark-outside-pairs
             er/mark-inside-quotes
             er/mark-outside-quotes
             er/contract-region)
  :bind (("C-c e" . hydra-er/body))
  :config (defhydra hydra-er (:hint nil)
            "
^Expand^          ^Mark^
^──────^──────────^────^─────────────────
_e_ expand region _(_ inside pairs
_-_ reduce region _)_ around pairs
^ ^               _q_ inside quotes
^ ^               _Q_ around quotes
^ ^               _p_ paragraph"
            ("e" er/expand-region :post hydra-er/body)
            ("-" er/contract-region :post hydra-er/body)
            ("p" er/mark-paragraph)
            ("(" er/mark-inside-pairs)
            (")" er/mark-outside-pairs)
            ("q" er/mark-inside-quotes)
            ("Q" er/mark-outside-quotes)))

(use-package phi-search
  :bind (("C-s" . phi-search)
         ("C-r" . phi-search-backward)))

(use-package eyebrowse
  :commands eyebrowse-mode
  :config
  (eyebrowse-mode t))

(when window-system
  (use-package moody
    :commands (moody-replace-mode-line-buffer-identification
               moody-replace-vc-mode)
    :init
    (setq-default x-underline-at-descent-line t)
    (moody-replace-mode-line-buffer-identification)
    (moody-replace-vc-mode)))

(use-package minions
  :commands minions-mode
  :init (minions-mode 1))

(provide 'init)
;;; init.el ends here

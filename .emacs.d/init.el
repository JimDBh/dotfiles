;; Common settings
(ignore-errors
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (tooltip-mode -1)
  (fset 'menu-bar-open nil))
(set-face-attribute 'default nil :font "Source Code Pro-10")
(set-face-attribute 'fringe nil :background nil)

(setq-default indent-tabs-mode nil
              scroll-step 1
              scroll-conservatively 10000
              auto-window-vscroll nil
              cursor-type 'bar)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file :noerror)

(defun ensure-installed (pkg)
  "Ensure that package is installed"
  (when (not (package-installed-p pkg))
    (package-install pkg)))

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(ensure-installed 'use-package)
(require 'use-package)

(ensure-installed 'spacemacs-theme)
(load-theme 'spacemacs-dark t nil)

(use-package helm :ensure t
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x C-b" . helm-buffers-list)
         ("C-x M-f" . helm-recentf)))

(use-package spaceline-config :ensure spaceline
  :config
  (spaceline-emacs-theme)
  (spaceline-helm-mode)
  :init
  (setq powerline-default-separator 'slant))

(use-package iedit :ensure t
  :bind
  ("C-;" . iedit-mode))

(use-package markdown-mode
  :ensure markdown-mode)

(use-package multiple-cursors
  :bind
  ("C-c >" . mc/mark-next-like-this)
  ("C-c <" . mc/mark-previous-like-this)
  ("C-c w" . mc/mark-next-word-like-this)
  ("C-c M-w" . mc/mark-previous-word-like-this))

(use-package company :ensure t
  :init
  (setq company-require-match 'never
        company-transformers 'nil
        company-minimum-prefix-length 2
        company-lsp-async t
        company-lsp-cache-candidates nil
        company-frontends
        '(company-pseudo-tooltip-unless-just-one-frontend
          company-preview-frontend
          company-echo-metadata-frontend))
  :config
  (setq company-backends (remove 'company-clang company-backends)
        company-backends (remove 'company-xcode company-backends)
        company-backends (remove 'company-gtags company-backends)
        company-backends (remove 'company-cmake company-backends))
  (add-hook 'after-init-hook 'global-company-mode)
  (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "S-TAB") 'company-select-previous)
  (define-key company-active-map (kbd "<backtab>") 'company-select-previous))

(use-package yasnippet :ensure t
  :config
  (add-hook 'prog-mode-hook 'yas-minor-mode))

(use-package yasnippet-snippets :ensure t)

(use-package company-lsp :ensure t
  :config
  (push '(company-lsp :with company-yasnippet) company-backends))

(use-package lsp-mode :ensure t)

(use-package nlinum :ensure t
  :config
  (global-nlinum-mode t)
  (set-face-attribute 'linum nil :background nil))

(use-package cquery :ensure t
  :init
  (setq cquery-executable "/usr/bin/cquery"
        cquery-cache-dir "~/.cache/cquery"
        cquery-sem-highlight-method 'font-lock)
  (add-hook 'c-mode-hook '(lambda() (lsp-cquery-enable))
            'c++-mode-hook '(lambda() (lsp-cquery-enable))))

;; C specific settings
(add-hook 'c-mode-common-hook
          '(lambda()
             (setq indent-tabs-mode t
                   c-basic-offset 4
                   tab-width 4)
             (lsp-cquery-enable)))


;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you (e.g. GPG configuration, email
;; clients, file templates and snippets). It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `variable-pitch' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 14 :weight 'normal)
      doom-variable-pitch-font (font-spec :family "FiraCode Nerd Font" :size 15))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tokyo-night)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;; - Setting file/directory variables (like `org-directory')
;; - Setting variables which explicitly tell you to set them before their
;;   package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;; - Setting doom variables (which start with 'doom-' or '+').

;; Basic editor settings (similar to nvim init.lua)
(setq-default
 ;; Indentation
 tab-width 2
 indent-tabs-mode nil)

;; Enable line numbers and sign column equivalent
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type t)

;; Clipboard settings
(setq select-enable-clipboard t)
(setq select-enable-primary t)

;; File type specific indentation (like nvim TSX/JSX settings)
(add-hook! '(js-mode-hook typescript-mode-hook web-mode-hook)
  (setq-local tab-width 2
              js-indent-level 2
              typescript-indent-level 2
              web-mode-markup-indent-offset 2
              web-mode-css-indent-offset 2
              web-mode-code-indent-offset 2))

;; Tokyo Night theme configuration
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

;; LSP configuration
(after! lsp-mode
  (setq lsp-signature-auto-activate nil
        lsp-signature-render-documentation t
        lsp-eldoc-render-all nil
        lsp-eldoc-hook nil)

  ;; Set Node.js path for LSP servers (similar to nvim copilot config)
  (setq lsp-clients-typescript-server-args '("--stdio")))

;; Treemacs configuration (equivalent to nvim-tree)
(after! treemacs
  (setq treemacs-width 30
        treemacs-show-cursor nil
        treemacs-show-hidden-files t
        treemacs-git-mode 'deferred))

;; Tree-sitter configuration
(after! tree-sitter
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

;; Modeline configuration (equivalent to lualine)
(after! doom-modeline
  (setq doom-modeline-height 25
        doom-modeline-bar-width 3
        doom-modeline-project-detection 'project
        doom-modeline-buffer-file-name-style 'relative-from-project
        doom-modeline-major-mode-icon t
        doom-modeline-major-mode-color-icon t
        doom-modeline-buffer-state-icon t
        doom-modeline-buffer-modification-icon t
        doom-modeline-time-icon t
        doom-modeline-time-live-icon t))

;; Corfu configuration (completion)
(after! corfu
  (setq corfu-cycle t
        corfu-auto t
        corfu-auto-delay 0.2
        corfu-auto-prefix 2
        corfu-popupinfo-delay 0.4))

;; Key bindings similar to nvim setup
(map! :leader
      (:prefix ("e" . "file tree")
       :desc "Toggle file tree" "e" #'treemacs
       :desc "Find file in tree" "f" #'treemacs-find-file))

;; Git integration (magit is already enabled)
(after! magit
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; Workspace configuration
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))

;; Evil mode configuration (vim-like bindings)
(after! evil
  (setq evil-want-fine-undo t
        evil-vsplit-window-right t
        evil-split-window-below t))

;; Auto-close brackets (similar to nvim-autopairs)
(after! smartparens
  (smartparens-global-mode 1))

;; Configure languages with LSP
(after! python
  (setq python-shell-interpreter "python3"))

;; Web mode configuration for JSX/TSX
(after! web-mode
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . web-mode))
  (setq web-mode-content-types-alist
        '(("jsx" . "\\.js[x]?\\'"))))

;; Ligatures (similar to having nerd font icons)
(after! ligatures
  (ligature-set-ligatures 'prog-mode '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
                                       ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
                                       "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
                                       "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
                                       "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
                                       "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
                                       "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
                                       "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
                                       "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
                                       "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%")))

;; Clipboard integration for cross-platform use (similar to nvim-osc52)
(after! clipetty
  (global-clipetty-mode)
  (map! :v "SPC z" #'clipetty-kill-ring-save))

;; GitHub Copilot Configuration
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word))
  :config
  (setq copilot-node-executable "/Users/tmorgan/.asdf/installs/nodejs/22.12.0/bin/node")
  ;; Enable Copilot for specific modes
  (add-to-list 'copilot-major-mode-alist '("python-mode" . t))
  (add-to-list 'copilot-major-mode-alist '("js-mode" . t))
  (add-to-list 'copilot-major-mode-alist '("typescript-mode" . t))
  (add-to-list 'copilot-major-mode-alist '("web-mode" . t)))

;; Enhanced Python Configuration
(after! python
  ;; Set Python interpreter
  (setq python-shell-interpreter "python3"
        python-shell-interpreter-args "-i")

  ;; LSP configuration for Python
  (setq lsp-pyright-venv-path "."
        lsp-pyright-auto-import-completions t
        lsp-pyright-auto-search-paths t))

;; Poetry integration for Python dependency management
(after! poetry
  (poetry-tracking-mode))

;; Pipenv integration
(after! pipenv
  (add-hook 'python-mode-hook #'pipenv-mode))

;; Black formatter for Python
(after! blacken
  (add-hook 'python-mode-hook 'blacken-mode))

;; ImportMagic for Python auto-imports
(after! importmagic
  (add-hook 'python-mode-hook 'importmagic-mode))

;; Enhanced JavaScript/TypeScript Configuration
(after! js2-mode
  ;; Better indentation
  (setq js2-basic-offset 2
        js-indent-level 2
        typescript-indent-level 2)

  ;; Enable syntax highlighting for JSX
  (setq js2-mode-show-parse-errors nil
        js2-mode-show-strict-warnings nil))

;; Prettier for JavaScript/TypeScript formatting
(after! prettier-js
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'web-mode-hook 'prettier-js-mode)
  (add-hook 'typescript-mode-hook 'prettier-js-mode)
  (setq prettier-js-args '("--single-quote" "--trailing-comma" "es5")))

;; Add node_modules to PATH for local packages
(after! add-node-modules-path
  (add-hook 'js2-mode-hook #'add-node-modules-path)
  (add-hook 'web-mode-hook #'add-node-modules-path)
  (add-hook 'typescript-mode-hook #'add-node-modules-path))

;; NPM mode for package management
(after! npm-mode
  (add-hook 'js2-mode-hook 'npm-mode)
  (add-hook 'typescript-mode-hook 'npm-mode))

;; JavaScript refactoring tools
(after! js2-refactor
  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (js2r-add-keybindings-with-prefix "C-c C-r"))

;; Enhanced LSP settings for JavaScript/TypeScript
(after! lsp-mode
  ;; TypeScript/JavaScript LSP settings
  (setq lsp-clients-typescript-preferences
        '(:includeCompletionsForModuleExports t
          :includeCompletionsWithInsertText t
          :includeCompletionsForImportStatements t))

  ;; Python LSP settings
  (setq lsp-pyright-multi-root nil
        lsp-pyright-use-library-code-for-types t)

  ;; General LSP optimizations
  (setq lsp-idle-delay 0.1
        lsp-file-watch-threshold 5000
        lsp-completion-provider :none)) ; Use Corfu instead

;; Tree-sitter enhanced syntax highlighting
(after! tree-sitter
  ;; Ensure tree-sitter is active for relevant modes
  (add-hook 'python-mode-hook #'tree-sitter-hl-mode)
  (add-hook 'js2-mode-hook #'tree-sitter-hl-mode)
  (add-hook 'typescript-mode-hook #'tree-sitter-hl-mode)
  (add-hook 'web-mode-hook #'tree-sitter-hl-mode))

;; Apheleia for code formatting
(after! apheleia
  (setf (alist-get 'python-mode apheleia-mode-alist) 'black)
  (setf (alist-get 'js2-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'typescript-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'web-mode apheleia-mode-alist) 'prettier))

;; Keybindings for language-specific features
(map! :localleader
      :map python-mode-map
      "f" #'blacken-buffer
      "i" #'importmagic-fix-imports
      "r" #'python-shell-send-region

      :map js2-mode-map
      "f" #'prettier-js
      "r" #'js2-refactor-hydra/body
      "n" #'npm-mode-npm-run

      :map typescript-mode-map
      "f" #'prettier-js
      "r" #'tide-refactor)
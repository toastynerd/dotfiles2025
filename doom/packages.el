;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)

;; GitHub Copilot equivalent for Emacs
(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))

;; OSC52 for clipboard integration (similar to nvim-osc52)
(package! clipetty)

;; Tokyo Night theme
(package! doom-themes)

;; Additional completion and formatting packages
(package! apheleia)  ; Code formatting (similar to prettier/formatting in nvim)

;; Git blame and advanced git features
(package! git-timemachine)

;; Enhanced search and navigation
(package! deadgrep)  ; Fast grep search
(package! wgrep)     ; Writable grep buffers

;; Language-specific enhancements
(package! typescript-mode)
(package! web-mode)
(package! ruby-mode)

;; Enhanced Python support
(package! poetry)              ; Python dependency management
(package! pipenv)             ; Python virtual environment management
(package! conda)              ; Conda environment support
(package! py-autopep8)        ; Python code formatting
(package! blacken)            ; Black formatter for Python
(package! importmagic)        ; Auto import management for Python

;; Enhanced JavaScript/TypeScript support
(package! prettier-js)        ; Prettier formatting
(package! add-node-modules-path) ; Add local node_modules to PATH
(package! npm-mode)           ; NPM integration
(package! js2-refactor)       ; JavaScript refactoring tools
(package! indium)             ; JavaScript development environment

;; Better terminal integration
(package! vterm)

;; Org-mode enhancements
(package! org-bullets)
(package! org-modern)
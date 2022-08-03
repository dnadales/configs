;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Damian Nadales"
      user-mail-address "damian.only@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

(setq doom-font                "Inconsolata-18"  ;; sudo apt-get install fonts-inconsolata
      doom-variable-pitch-font "Inconsolata-20")
;; Other fonts you might want to consider:
;; ;; (setq doom-font "JetBrains Mono-10") ;; https://www.jetbrains.com/lp/mono/#how-to-install


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;
;; For an overview of the themes see https://github.com/doomemacs/themes/tree/screenshots
(setq doom-theme 'doom-dark+)
;; (setq doom-theme 'doom-one-light)
;; Other light themes: doom-solarized-light


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/psys/")
(setq inbox-path (concat org-directory "inbox.org"))
(setq calendar-path (concat org-directory "calendar.org"))
(setq projects-path (concat org-directory "projects.org"))
(setq next-actions-path (concat org-directory "next-actions.org"))
(setq maybe-someday-path (concat org-directory "maybe-someday.org"))
(after! org
  (setq  org-agenda-files (list calendar-path next-actions-path)
         ;; This adds a ``CLOSED'' label to the TODO entry, which describes the
         ;; date and time in which the activity was marked as done.
         org-log-done t
         ;; My capture templates
         org-capture-templates
        '(("t" "New Task" entry (file inbox-path) "* TODO %?\n  %U\n  %i\n"))
         ;; See https://www.gnu.org/software/emacs/manual/html_node/org/Tracking-TODO-state-changes.html
         ;;
         ;; Meaning of symbols
         ;; @: leave a note
         ;; !: add a timestamp when entering that state
         ;;
         org-todo-keywords
         '((sequence "TODO(t!)" "WAITING(w@/!)" "STARTED(s!/!)" "DELEGATED(e@/!)" "|" "DONE(d!)" "CANCELED(c@/!)"))
         ;; Agenda view customizations
         org-agenda-prefix-format
         '((agenda . "%?-12t%-11s")
         (todo . " %i %-12:c")
         (tags . " %i %-12:c")
         (search . " %i %-12:c"))
         org-agenda-todo-keyword-format "·"
         org-agenda-skip-scheduled-if-done t
         org-enforce-todo-dependencies t
         org-hide-leading-stars t
         org-log-into-drawer t
         org-odd-levels-only t
         ;; Refile configuration
         org-refile-use-outline-path 'file ; Use the file path as of the
                                           ; refiling targets. This makes it
                                           ; possible to refile nodes to the
                                           ; top-level.
         org-outline-path-complete-in-steps nil
         org-refile-targets (quote ((projects-path :level . 1)
                                    (next-actions-path :level . 1)
                                    (calendar-path :level . 1)
                                    (maybe-someday-path :level . 1)))
         ;; Custom agenda commands
         org-agenda-custom-commands `(;; match those tagged with :inbox:, are not scheduled, are not DONE.
                                      ("u" "[u]nscheduled tasks" tags "-SCHEDULED={.+}/!+TODO|+STARTED|+WAITING"))


         org-modules '(org-habit)
         org-habit-show-habits t
         org-habit-graph-column 60
         ;; I'm disabling this temporarily since I'm getting a
         ;;
         ;;     Cached element has wrong parent
         ;;
         ;; error.
         org-element-use-cache nil

         ;; Leave my apostrophes alone.
         org-export-with-smart-quotes nil
         )
  ;; Org-babel supported languages
  (org-babel-do-load-languages
   'org-babel-load-languages '((haskell . t)
                               (dot . t))
   )
  )

;; For more org-roam configuration options see: https://github.com/jethrokuan/dots/blob/master/.doom.d/config.el
(use-package! org-roam
  :init
  (setq org-roam-v2-ack t)
  (map! :leader
        :prefix "n"
        :desc "org-roam" "l" #'org-roam-buffer-toggle
        :desc "org-roam-node-insert" "i" #'org-roam-node-insert
        :desc "org-roam-node-find" "f" #'org-roam-node-find
        :desc "org-roam-ref-find" "r" #'org-roam-ref-find
        :desc "org-roam-show-graph" "g" #'org-roam-show-graph
        :desc "org-roam-capture" "c" #'org-roam-capture)
  (setq org-roam-directory (file-truename "~/psys/roam/"))
  :config
  (org-roam-setup)
  )

(use-package! doom-modeline
  :config
  (setq doom-modeline-buffer-file-name-style 'buffer-name
        doom-modeline-major-mode-icon t))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(setq doom-modeline-buffer-file-name-style 'relative-to-project)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(map! :leader
      :prefix "w"
      :desc "windmove-left"  "n" #'windmove-left
      :desc "windmove-down"  "e" #'windmove-down
      :desc "windmove-right" "i" #'windmove-right
      :desc "windmove-up"    "u" #'windmove-up

      :desc "windmove-swap-states-left"  "N" #'windmove-swap-states-left
      :desc "windmove-swap-states-down"  "E" #'windmove-swap-states-down
      :desc "windmove-swap-states-right" "I" #'windmove-swap-states-right
      :desc "windmove-swap-states-up"    "U" #'windmove-swap-states-up

      :desc "Undo windows config"  "z" #'winner-undo
      :desc "Re-do windows config" "y" #'winner-redo
      )

(use-package! lsp-ui
  :config
  (setq lsp-ui-doc-enable nil))

(use-package! lsp-haskell
  :config
  (setq lsp-haskell-stylish-haskell-on t)
  (setq lsp-haskell-formatting-provider "stylish-haskell")
  (setq haskell-stylish-on-save t))

(use-package! pdf-view
  :hook (pdf-tools-enabled . pdf-view-midnight-minor-mode)
  :hook (pdf-tools-enabled . hide-mode-line-mode)
  :config
  (setq pdf-view-midnight-colors '("#ABB2BF" . "#282C35")))

(after! haskell-mode
  ;; Improve code navigation in Haskell buffers
  (add-hook 'haskell-mode-hook #'haskell-decl-scan-mode)
  (add-hook 'haskell-mode-hook #'haskell-indentation-mode))

(use-package! bug-reference
  :custom (bug-reference-bug-regexp (rx (group (group (| (: ?#)
                                                         (: "CAD-")))
                                               (group (+ digit)))))
  :config (defun my-jira-url () "No documentation for this one"
                  ;; input-output.atlassian.net/browse
                 (format "https://%s/%s%s"
                         (if (string-suffix-p "#" (match-string-no-properties 2))
                             "github.com/input-output-hk/ouroboros-network/pull"
                           "input-output.atlassian.net/browse")
                         (if (string-suffix-p "#" (match-string-no-properties 2))
                             ""
                           "CAD-")
                         (match-string-no-properties 3)))
          (setq bug-reference-url-format #'my-jira-url)
  :hook
    (org-mode . bug-reference-mode)
    (prog-mode . bug-reference-prog-mode))

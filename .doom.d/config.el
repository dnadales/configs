;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

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

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dark+)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/psys/")
(setq inbox-path (concat org-directory "inbox.org"))
(setq calendar-path (concat org-directory "calendar.org"))
(setq projects-path (concat org-directory "projects.org"))
(setq next-actions-path (concat org-directory "next-actions.org"))
(after! org
  (setq  org-agenda-files (list calendar-path)
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
                                 (calendar-path :level . 1)))
         ;; Custom agenda commands
         org-agenda-custom-commands `(;; match those tagged with :inbox:, are not scheduled, are not DONE.
                                       ("u" "[u]nscheduled tasks" tags "-SCHEDULED={.+}/!+TODO|+STARTED|+WAITING"))
         )
  ;; Org-babel supported languages
  (org-babel-do-load-languages
   'org-babel-load-languages '((haskell . t)
                               (dot . t))
   )
  )
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


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

;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Dimitris Milonopoulos"
      user-mail-address "dimitriosmilonopoulos@gmail.com")

;; Font config
(set-face-attribute 'default nil
  :font "FiraCode Nerd Font"
  :height 110
  :weight 'medium)
(set-face-attribute 'fixed-pitch nil
  :font "FiraCode Nerd Font"
  :height 110
  :weight 'medium)
;; Makes commented text and keywords italics.
;; This is working in emacsclient but not emacs.
;; Your font must have an italic face available.
(set-face-attribute 'font-lock-comment-face nil
  :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
  :slant 'italic)

;; Uncomment the following line if line spacing needs adjusting.
;; (setq-default line-spacing 0.12)

;; Needed if using emacsclient. Otherwise, your fonts will be smaller than expected.
(add-to-list 'default-frame-alist '(font . "FiraCode Nerd Font-11"))
;; changes certain keywords to symbols, such as lamda!
(setq global-prettify-symbols-mode t)
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(setq! doom-unicode-font (font-spec :family "FiraCode Nerd Font Mono" :height 110 ))

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-material)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

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
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(require 'tree-sitter)
(require 'tree-sitter-langs)
(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package lsp-pyright
  :ensure t
  :hook ((python-mode . (lambda () (require 'lsp-pyright)))
	   (python-mode . lsp-deferred))
  ;; these hooks can't go in the :hook section since lsp-restart-workspace
  ;; is not available if lsp isn't active

)
(after! git-gutter
  (setq git-gutter:update-interval 0.5))

;; Enable tree sitter globaly
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)


(require 'bind-key)
(bind-key* "C-k" 'lsp-ui-doc-show)


(require 'lsp-pyright)
(setq lsp-pyright-use-library-code-for-types t)
(setq lsp-pyright-diagnostic-mode "openFilesOnly")
(setq lsp-pyright-auto-search-paths nil)

(map! :leader
      (:prefix("e". "error")
      :desc "Go to next error" "n" #'flycheck-next-error
      :desc "Go to previous error" "p" #'flycheck-previous-error
      :desc "List errors" "l" #'flycheck-list-errors
      ))

(with-eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook 'flycheck-popup-tip-mode))


(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))


(setq doom-modeline-vcs-max-length 50)
(setq org-agenda-files '("~/Documents/Dropbox/org"))


;; Sneak mode for emacs
(evil-snipe-mode +1)
(evil-snipe-override-mode +1)
(setq evil-snipe-scope 'visible)
(add-hook 'magit-mode-hook 'turn-off-evil-snipe-override-mode)

;; Vterm config
(setq vterm-shell "/usr/bin/fish")


;; Neotree config
"Open NeoTree using the project root, using projectile, find-file-in-project,
or the current buffer directory."
(defun my-neotree-project-dir-toggle ()
  (interactive)
  (require 'neotree)
  (let* ((filepath (buffer-file-name))
         (project-dir
          (with-demoted-errors "neotree-project-dir-toggle error: %S"
              (cond
               ((featurep 'projectile)
                (projectile-project-root))
               ((featurep 'find-file-in-project)
                (ffip-project-root))
               (t ;; Fall back to version control root.
                (if filepath
                    (vc-call-backend
                     (vc-responsible-backend filepath) 'root filepath)
                  nil)))))
         (neo-smart-open t))

    (if (and (fboundp 'neo-global--window-exists-p)
             (neo-global--window-exists-p))
        (neotree-hide)
      (neotree-show)
      (when project-dir
        (neotree-dir project-dir))
      (when filepath
        (neotree-find filepath)))))
;; Set the neo-window-width to the current width of the
;; neotree window, to trick neotree into resetting the
;; width back to the actual window width.
;; Fixes: https://github.com/jaypei/emacs-neotree/issues/262
(eval-after-load "neotree"
  '(add-to-list 'window-size-change-functions
                (lambda (frame)
                  (let ((neo-window (neo-global--get-window)))
                    (unless (null neo-window)
                      (setq neo-window-width (window-width neo-window)))))))
(setq doom-themes-neotree-file-icons t)
(setq neo-window-fixed-size nil)

;; Open neotree
(map! :leader
      :desc "Show Neotree" "t e" #'my-neotree-project-dir-toggle)
(setq doom-themes-neotree-file-icons t)

;; select window
(map! :leader
      :desc "Select window on screen" "r" #'ace-select-window)
;; Open terminal
(map! :leader
      :desc "Open Vterm" "t t" #'+vterm/here)

(eval-after-load "neotree"
  '(add-to-list 'window-size-change-functions
                (lambda (frame)
                  (let ((neo-window (neo-global--get-window)))
                    (unless (null neo-window)
                      (setq neo-window-width (window-width neo-window)))))))


(custom-set-faces
  '(org-level-1 ((t (:inherit header-line :height 2.0))))
  '(org-level-2 ((t (:inherit header-line :height 1.7))))
  '(org-level-3 ((t (:inherit header-line :height 1.3)))))

(setq auto-window-vscroll nil)


;; Ivy settings
(advice-add 'ivy--highlight-fuzzy :around (lambda (orig-fun &rest args)
                                            (let* ((cols (split-string (car args) (char-to-string #x200B)))
                                                    (res (apply orig-fun (list (car cols)))))
                                              (mapconcat 'identity (cons res (cdr cols)) ""))))

(advice-add 'ivy-rich-normailze-width :around (lambda (orig-fun &rest args)
                                                (pcase args
                                                  (`(,str ,len ,left)
                                                    (apply orig-fun (list (concat str (char-to-string #x200B)) (1+ len) left))))))


;; Startup
(use-package! docstr
  :ensure t
  )

(setq docstr-python-style 'google)
(setq global-docstr-mode 't)
;; Themes
;; (use-package! 'everforest-hard-dark)
(use-package! base16-theme)
(use-package ivy-posframe
  :after ivy posframe
  :config
  (setq
   ivy-posframe-border-width 1))


;; Formatting
(set-formatter! 'black  "/home/dim/.config/nvim/binaries/blackd-client" :modes '(python-mode))
(setq fancy-splash-image "/home/dim/Downloads/output-onlinepngtools.png")
(setq lsp-headerline-breadcrumb-enable t)
(setq lsp-headerline-breadcrumb-segments '(project file symbols))
(setq lsp-headerline-breadcrumb-icons-enable t)
(set-face-underline 'lsp-headerline-breadcrumb-path-warning-face nil)

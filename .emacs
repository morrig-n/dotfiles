(package-initialize)

;;; Packages

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

(defvar rc/package-contents-refreshed nil)

(defun rc/package-refresh-contents-once ()
  (when (not rc/package-contents-refreshed)
    (setq rc/package-contents-refreshed t)
    (package-refresh-contents)))

(defun rc/require-one-package (package)
  (when (not (package-installed-p package))
    (rc/package-refresh-contents-once)
    (package-install package)))

(defun rc/require (&rest packages)
  (dolist (package packages)
    (rc/require-one-package package)))

(defun rc/require-theme (theme)
  (let ((theme-package (->> theme
			    (symbol-name)
			    (funcall (-flip #'concat) "-theme")
			    (intern))))
    (rc/require theme-package)
    (load-theme theme t)))

(rc/require 'dash)
(require 'dash)

(rc/require 'dash-functional)
(require 'dash-functional)

;;; Appearance

(require 'ansi-color)
(global-display-line-numbers-mode 1)

(defun get-default-font ()
  (cond
   ((eq system-type 'windows-nt) "Fira Code-14")
   ((eq system-type 'gnu/linux) "Iosevka-18")))

(add-to-list 'default-frame-alist `(font . (get-default-font)))
(set-frame-font (get-default-font))

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)

(rc/require-theme 'underwater)

(rc/require 'nyan-mode)
(nyan-mode 1)

(setq-default inhibit-splash-screen t
	      make-backup-files nil
	      tab-width 4
	      indent-tabls-mode nil
	      compilation-scroll-output t
	      visible-bell (equal system-type 'windows-nt))

;;; Ido

(rc/require 'smex 'ido-completing-read+)
(require 'ido-completing-read+)

(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;; Multiple Cursors

(rc/require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C->") 'mc/mark-all-like-this)
(global-set-key (kbd "C-#") 'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:") 'mc/skip-to-previous-like-this)

;;; Dired

(require 'dired-x)
(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))
(setq-default dired-dwim-target t)
(setq dired-listing-switches "-alh")

;;; Yasnippet

(rc/require 'yasnippet)
(require 'yasnippet)

(setq yas/triggers-in-field nil)
(setq yas-snipped-dirs '("~/.emacs.snippets/"))

(yas-global-mode 1)


;;; Company Mode

(rc/require 'company)
(require 'company)

(global-company-mode)

;;; Move Text

(rc/require 'move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

(defun rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(global-set-key (kbd "C-,") 'rc/duplicate-line)

;;; Svelte Mode

(rc/require 'svelte-mode)

(add-to-list 'auto-mode-alist '("\\.svelte\\'" . svelte-mode))

;;; Other Modes

(rc/require 'typescript-mode 'markdown-mode 'elixir-mode)

;;; Elcord

(rc/require 'elcord)
(require 'elcord)

(elcord-mode 1)

;;; Magit

(rc/require 'cl-lib)
(rc/require 'magit)

(setq magit-auto-revert-mode nil)

(global-set-key (kbd "C-c m s") 'magit-status)
(global-set-key (kbd "C-c m l") 'magit-log)

;;; Utility

(defun cd/emacs-startup-hook ()
  (cd "~"))

(add-hook 'emacs-startup-hook #'cd/emacs-startup-hook)

(defun kill-all-buffers ()
  (interactive)
  (dolist (cur (buffer-list))
    (kill-buffer cur)))

(defun close-current-buffer ()
  (interactive)
  (kill-buffer (buffer-name)))

(global-set-key (kbd "C-x K") 'kill-all-buffers)
(global-set-key (kbd "C-S-w") 'close-current-buffer)

(defun indent-whole-file ()
  (interactive)
  (indent-region (point-min) (point-max)))

(global-set-key (kbd "C-<tab>") 'indent-whole-file)

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(global-set-key (kbd "C-z") 'undo)


;;; Custom set variables

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(elixir-mode underwater-theme zenburn-theme melancholy-theme javascript-mode typescript-mode elcord svelte-mode move-text company yasnippet nyan-mode constant-theme multiple-cursors ido-completing-read+ smex dash-functional dash)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

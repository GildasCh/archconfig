; Basic configurations
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(blink-cursor-mode 0)
(toggle-scroll-bar 0)
(show-paren-mode 1)
(column-number-mode 1)
(setq mouse-yank-at-point t)
(setq-default show-trailing-whitespace t)
(ido-mode 1)
(setq-default tab-width 4)
(menu-bar-mode -99)

; Install required packages
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(setq package-list '(
					 material-theme
					 highlight-symbol
					 rainbow-delimiters
                     magit
					 go-mode
					 go-dlv
                     go-autocomplete
                     auto-complete
                     markdown-preview-eww
                     web-mode
                     yaml-mode
                     multiple-cursors
                     nyan-mode
					 ))
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

; Theme
(load-theme 'material t)
(add-to-list 'default-frame-alist '(font . "Fantasque Sans Mono-11:antialias=none"))

; Find File improvements
(ffap-bindings)

; Rainbow-delimiters-mode for all files
(add-hook 'find-file-hook 'rainbow-delimiters-mode)

; Magit
(global-set-key (kbd "C-x g") 'magit-status)

; Go
(require 'go-mode)
(add-to-list 'auto-mode-alist '("\\.go$" . go-mode))
(setenv "GOPATH" (concat (file-truename "~/") "dev/go/"))
(setenv "PATH"
        (concat (getenv "PATH") ":" (concat (getenv "GOPATH") "bin")))
(setq gofmt-command "goimports")
(set-default 'godef-command (concat (getenv "GOPATH") "bin/godef"))
(setq-default indent-tabs-mode nil)
(setq web-mode-code-indent-offset 2)
(setq yaml-mode-code-indent-offset 2)
(setq go-mode-code-indent-offset 2)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(require 'go-dlv)

; Docker
(setenv "DOCKER_HOST" "tcp://10.100.0.1:4243")

; Web
(require 'web-mode)
;(add-to-list 'auto-mode-alist '("\\.php*\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.twig\\'" . web-mode))
;(setq web-mode-code-indent-offset 2)
;(setq-default indent-tabs-mode nil)
(add-hook 'php-mode-hook 'my-php-mode-hook)
(defun my-php-mode-hook ()
  "My PHP mode configuration."
  (setq indent-tabs-mode nil
        tab-width 4
        c-basic-offset 4))

; Yaml
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

; Highlight symbol shortcuts
(require 'highlight-symbol)
(global-set-key (kbd "C-x <f3>") 'highlight-symbol-mode)
(global-set-key [(control f3)] 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)
(setq highlight-symbol-idle-delay 0)

; C indent
(defun c-indent-mozilla ()
  "Indent C according to Mozilla guidelines."
  (setq c-basic-offset 2 tab-width 8 indent-tabs-mode nil)
  (c-set-offset 'arglist-intro '++))
(setq c-mode-hook '(c-indent-mozilla))

; Auto-complete
(ac-config-default)

; Tramp config
(require 'tramp)
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)
(setq tramp-default-proxies-alist
   (quote
    (((regexp-quote
       (system-name))
      nil nil)
     (nil "\\`root\\'" "/ssh:%h:")
     (nil ".+" "/sudo:%h:"))))

; Shell config
(add-hook
 'shell-mode-hook
 (lambda ()
   ;; Load history from remote hosts (it is saved
   ;; by setting HISTFILE in the shell below)
   (let* ((remote-home (file-remote-p default-directory))
          (comint-input-ring-file-name
           (concat (or remote-home "~/") ".bash_history_tramp")))
     (comint-read-input-ring t))
   ;; Generic settings; use ~/.emacs.d/init_bash.sh
   ;; for custom configuration
   (comint-send-string
    (get-buffer-process (current-buffer))
    "export HISTFILE=~/.bash_history_tramp\nexport PAGER=cat\n")
   ;; Remove "syntax highlighting"
   ; (setq font-lock-defaults '(nil t))
   ))
(add-to-list 'display-buffer-alist
     '("^\\*shell\\*$" . (display-buffer-same-window)))
(add-hook 'term-mode-hook (lambda()
                            (setq yas-dont-activate t)))

; Org mode config
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-agenda-files (list "~/work.org"))

; Browser
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "vivaldi-stable")

; Nyancat !
(nyan-mode)
(nyan-start-animation)

; Ansi colors ??
(setq system-uses-terminfo nil)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (rainbow-delimiters material-theme highlight-symbol))))
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(user-full-name "Full Name")
 '(user-mail-address "my.mail@mail.com")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

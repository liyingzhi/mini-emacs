(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq frame-inhibit-implied-resize t)
;; 增加IO性能
(setq read-process-output-max (* 1024 1024 10))
(setq gc-cons-threshold most-positive-fixnum)
(find-function-setup-keys)

(let ((file-name-handler-alist nil))
  (add-to-list 'load-path
               (expand-file-name
                (concat user-emacs-directory "lisp")))
  ;; (setq toggle-debug-on-error t)
  (require 'init-utils)

  (setq custom-file (locate-user-emacs-file "custom.el"))
  
  (require 'init-package)
  (require 'init-const)
  (when sys/macp
    (add-to-list 'default-frame-alist '(undecorated-round . t)))
  (require 'init-startup)
  (require 'init-font))

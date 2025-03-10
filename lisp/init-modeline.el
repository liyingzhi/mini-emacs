;;; init-modeline.el --- init modeline               -*- lexical-binding: t; -*-

;; Copyright (C) 2025  lizqwer scott

;; Author: lizqwer scott <lizqwerscott@gmail.com>
;; Keywords: lisp

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(defface modeline-face-default '((t)) "")
(defface modeline-face-strong '((t)) "")
(defface modeline-face-faded '((t)) "")
(defface modeline-face-critical '((t)) "")

(defun modeline-set-face (name &optional foreground background weight)
  "Set NAME and NAME-i faces with given FOREGROUND, BACKGROUND and WEIGHT"

  (apply #'set-face-attribute `(,name nil
                                      ,@(when foreground `(:foreground ,foreground))
                                      ,@(when background `(:background ,background))
                                      ,@(when weight `(:weight ,weight)))))

(modeline-set-face 'modeline-face-default "#ECEFF4" "#2E3440") ;; Snow Storm 3
(modeline-set-face 'modeline-face-strong "#ECEFF4" nil 'regular) ;; Polar Night 0
(modeline-set-face 'modeline-face-faded "#b6a0ff") ;;
(modeline-set-face 'modeline-face-critical "#EBCB8B") ;; Aurora 2

;; from doom-modeline
(defsubst modeline-encoding ()
  "Encoding"
  (let ((sep (propertize " " 'face 'mode-line))
        (face 'modeline-face-strong)
        (mouse-face 'modeline-face-faded))
    (concat
     sep

     ;; eol type
     (let ((eol (coding-system-eol-type buffer-file-coding-system)))
       (propertize
        (pcase eol
          (0 "LF ")
          (1 "CRLF ")
          (2 "CR ")
          (_ ""))
        'face face
        'mouse-face mouse-face
        'help-echo (format "End-of-line style: %s\nmouse-1: Cycle"
                           (pcase eol
                             (0 "Unix-style LF")
                             (1 "DOS-style CRLF")
                             (2 "Mac-style CR")
                             (_ "Undecided")))
        'local-map (let ((map (make-sparse-keymap)))
                     (define-key map [mode-line mouse-1] 'mode-line-change-eol)
                     map)))

     ;; coding system
     (let* ((sys (coding-system-plist buffer-file-coding-system))
            (cat (plist-get sys :category))
            (sym (if (memq cat
                           '(coding-category-undecided coding-category-utf-8))
                     'utf-8
                   (plist-get sys :name))))
       (propertize
        (upcase (symbol-name sym))
        'face face
        'mouse-face mouse-face
        'help-echo 'mode-line-mule-info-help-echo
        'local-map mode-line-coding-system-map))
     sep)))

(setq-default mode-line-format
              '(:eval
                (let ((meow-mode-status (cond ((meow-normal-mode-p) "N")
                                              ((meow-motion-mode-p) "M")
                                              ((meow-keypad-mode-p) "K")
                                              ((meow-insert-mode-p) "I")
                                              (t " ")))
                      (prefix (cond (buffer-read-only     '("Read " . modeline-face-critical))
                                    ((buffer-modified-p)  '("" . modeline-face-critical))
                                    (t                    '("" . modeline-face-strong))))
                      (buffer-name-face (cond (buffer-read-only     'modeline-face-strong)
                                              ((buffer-modified-p)  'modeline-face-critical)
                                              (t                    'modeline-face-strong)))
                      (mode (concat " " (cond ((consp mode-name) (car mode-name))
                                              ((stringp mode-name) mode-name)
                                              (t "unknow"))
                                    " "))
                      (coords (format-mode-line "  L%l:C%c"))
                      (buffer-encoding (modeline-encoding)))
                  (list
                   (propertize (format "  %s  " meow-mode-status) 'face 'modeline-face-faded)
                   (propertize (car prefix) 'face (cdr prefix))
                   (propertize (format-mode-line "%b") 'face buffer-name-face)
                   (propertize coords 'face 'modeline-face-strong)
                   (propertize " " 'display `(space :align-to (- right ,(length mode) ,(length buffer-encoding))))
                   buffer-encoding
                   (propertize mode 'face 'modeline-face-faded)))))

(provide 'init-modeline)
;;; init-modeline.el ends here

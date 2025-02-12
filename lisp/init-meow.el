(require 'meow)
(setq meow-esc-delay 0.001)
(setq meow-keypad-leader-dispatch "C-c")
(setq meow-mode-state-list
      '((fundamental-mode . normal)
        (text-mode . normal)
        (prog-mode . normal)
        (conf-mode . normal)
        (elfeed-show-mode . normal)
        (helpful-mode . normal)
        (cargo-process-mode . normal)
        (compilation-mode . normal)
        (messages-buffer-mode . normal)
        (eww-mode . normal)
        (color-rg-mode . insert)
        (lsp-bridge-ref-mode . insert)
        (vterm-mode . insert)
        (Info-mode-hook . motion)))
(setq meow-use-clipboard t)
(setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)

(meow-thing-register 'url 'url 'url)

(add-to-list 'meow-char-thing-table
             '(?u . url))

(defun kill-now-buffer ()
  "Close the current buffer."
  (interactive)
  (kill-buffer (current-buffer))
  (delete-window))

(defun my/meow-quit ()
  (interactive)
  (if (derived-mode-p 'dired-mode)
      (kill-now-buffer)
    (if (delete-window)
        (message "finish"))))

(defun meow-setup ()
  ;; (meow-motion-overwrite-define-key
  ;;  '("j" . meow-next)
  ;;  '("k" . meow-prev)
  ;;  '("h" . meow-left)
  ;;  '("l" . meow-right)
  ;;  '("o" . meow-block)
  ;;  '("x" . meow-line)
  ;;  '("W" . meow-mark-symbol)
  ;;  '("w" . meow-mark-word)
  ;;  '("C-j" . (lambda ()
  ;;              (interactive)
  ;;              (dotimes (i 2)
  ;;   	         (call-interactively 'meow-next))))
  ;;  '("C-k" . (lambda ()
  ;;              (interactive)
  ;;              (dotimes (i 2)
  ;;   	         (call-interactively 'meow-prev))))
  ;;  '("<escape>" . ignore))

  (meow-leader-define-key
   ;; Use SPC (0-9) for digit arguments.
   ;; '("1" . meow-digit-argument)
   ;; '("2" . meow-digit-argument)
   ;; '("3" . meow-digit-argument)
   ;; '("4" . meow-digit-argument)
   ;; '("5" . meow-digit-argument)
   ;; '("6" . meow-digit-argument)
   ;; '("7" . meow-digit-argument)
   ;; '("8" . meow-digit-argument)
   ;; '("9" . meow-digit-argument)
   ;; '("0" . meow-digit-argument)
   ;; '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))

  (meow-leader-define-key
   '("1" . delete-other-windows)
   '("2" . split-window-below)
   '("3" . split-window-horizontally)
   '("0" . delete-window))

  (meow-leader-define-key
   '("ff" . find-file)
   '("fF" . find-file-other-window)
   '("fh" . (lambda ()
              (interactive)
              (ido-find-file-in-dir "~/"))))

  (meow-leader-define-key
   '("bb" . switch-to-buffer)
   '("bB" . switch-to-buffer-other-window)
   '("bk" . kill-buffer-and-window)
   '("br" . revert-buffer))

  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("C" . comment-or-uncomment-region)
   '("s" . meow-delete)
   '("S" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   ;; '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   ;; '("N" . lizqwer/mark-line-comment)
   '("N" . mark-next-comment)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("P" . meow-yank-pop)
   '("q" . my/meow-quit)
   ;;   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("d" . meow-kill)
   '("D" . meow-kill-append)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   ;; '("v" . meow-visit)
   '("v" . meow-cancel-selection)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   ;; '("X" . meow-goto-line)
   '("y" . meow-save)
   ;; '("Y" . meow-sync-grab)
   '("Y" . meow-clipboard-save)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore))

  (meow-normal-define-key
   '("gr" . xref-find-references)
   '("gd" . xref-find-definitions)
   '("gD" . xref-find-definitions-other-window)
   '("C-o" . xref-go-back))

  (meow-normal-define-key
   '("C-;" . grugru)
   '("C-y" . meow-clipboard-yank)
   '("Q" . kill-now-buffer)
   '("?" . helpful-at-point)
   '("gf" . find-file-at-point)
   '("gp" . goto-percent)))

(meow-setup)
(meow-global-mode 1)

(provide 'init-meow)

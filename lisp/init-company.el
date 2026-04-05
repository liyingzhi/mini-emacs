(require 'company)

(use-package company
  :diminish (company-mode " Cmp.")
  :defines (company-dabbrev-ignore-case company-dabbrev-downcase)
  :hook (after-init . global-company-mode)
  :config
  (setq company-dabbrev-code-everywhere t
        company-dabbrev-code-modes t
        company-dabbrev-code-other-buffers 'all
        company-dabbrev-downcase nil
        company-dabbrev-ignore-case t
        company-dabbrev-other-buffers 'all
        company-require-match nil
        company-minimum-prefix-length 1
        company-show-numbers t
        company-tooltip-limit 20
        company-idle-delay 0
        company-echo-delay 0
        company-tooltip-offset-display 'scrollbar
        ;; company-begin-commands '(self-insert-command)
        ))

(defun +complete ()
  "TAB complete."
  (interactive)
  (when (meow-insert-mode-p)
    (or (yas-expand)
        (company-complete))))


(defun set-company-tab ()
  (define-key company-active-map [tab] '+complete)
  (define-key company-active-map (kbd "TAB") '+complete))

(set-company-tab)

(setq company-frontends
      '(company-pseudo-tooltip-unless-just-one-frontend
        company-preview-frontend))

(defun advice-only-show-tooltip-when-invoked (orig-fun command)
  "原始的 company-pseudo-tooltip-unless-just-one-frontend-with-delay, 它一直会显示
candidates tooltip, 除非只有一个候选结果时，此时，它会不显示, 这个 advice 则是让其
完全不显示, 但是同时仍旧保持 inline 提示, 类似于 auto-complete 当中, 设定
ac-auto-show-menu 为 nil 的情形, 这种模式比较适合在 yasnippet 正在 expanding 时使用。"
  (when (company-explicit-action-p)
    (apply orig-fun command)))

(defun advice-always-trigger-yas (orig-fun &rest command)
  (interactive)
  (unless (ignore-errors (yas-expand))
    (apply orig-fun command)))

(with-eval-after-load 'yasnippet
  (defun yas/disable-company-tooltip ()
    (interactive)
    (advice-add #'company-pseudo-tooltip-unless-just-one-frontend
                :around #'advice-only-show-tooltip-when-invoked)
    (define-key company-active-map [tab] 'yas-next-field-or-maybe-expand)
    (define-key company-active-map (kbd "TAB") 'yas-next-field-or-maybe-expand))
  (defun yas/restore-company-tooltip ()
    (interactive)
    (advice-remove #'company-pseudo-tooltip-unless-just-one-frontend
                   #'advice-only-show-tooltip-when-invoked)
    (set-company-tab))
  (add-hook 'yas-before-expand-snippet-hook 'yas/disable-company-tooltip)
  (add-hook 'yas-after-exit-snippet-hook 'yas/restore-company-tooltip)

  ;; 这个可以确保，如果当前 key 是一个 snippet, 则一定展开 snippet,
  ;; 而忽略掉正常的 company 完成。
  (advice-add #'company-select-next-if-tooltip-visible-or-complete-selection
              :around #'advice-always-trigger-yas)
  (advice-add #'company-complete-common
              :around #'advice-always-trigger-yas)
  (advice-add #'company-complete-common-or-cycle
              :around #'advice-always-trigger-yas))

                                        ;(setq company-auto-commit t)
;; 32 空格, 41 右圆括号, 46 是 dot 字符
;; 这里我们移除空格，添加逗号(44), 分号(59)
;; 注意： C-x = 用来检测光标下字符的数字，(insert 数字) 用来测试数字对应的字符。
                                        ;(setq company-auto-commit-chars '(41 46 44 59))

;; (setopt company-backends
;;         '(company-abbrev company-yasnippet company-dabbrev company-files company-capf company-elisp company-keywords))

(require 'cape)

(advice-add 'comint-completion-at-point :around #'cape-wrap-nonexclusive)
(advice-add 'pcomplete-completions-at-point :around #'cape-wrap-nonexclusive)


(add-list-to-list 'completion-at-point-functions
                  '(cape-elisp-block
                    cape-keyword))

(defun my/org-capf ()
  "Set up `completion-at-point' functions for Org mode.

This function configures a custom `completion-at-point' setup for Org mode
buffers, providing:
- File path completion (`cape-file')
- Shell command completion (`pcomplete-completions-at-point')
- Elisp block completion (`cape-elisp-block')
- Super completion combining dabbrev and dictionary completion"
  (setq-local completion-at-point-functions
              '(pcomplete-completions-at-point
                cape-elisp-block
                cape-dabbrev)))

(add-hook 'org-mode-hook #'my/org-capf)

;; (setopt company-backends `(company-files
;;                            company-capf))

(setopt company-backends `(company-semantic
                           company-files
                           (company-dabbrev-code
                            company-keywords)
                           company-dabbrev))

(provide 'init-company)

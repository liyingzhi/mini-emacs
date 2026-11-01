;;; init-font.el --- font                            -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defconst user/default-mac-font-size 230
  "The default font size in mac.")

(defconst user/default-win-font-size 110
  "The default font size in windows.")

(defconst user/default-linux-font-size 190
  "The default font size in linux.")

(defconst user/fallback-fonts
  '("MonoLisa Lucius" "Jetbrains Mono" "Iosevka" "Source Code Pro" "Cascadia Code"
    "Fira Code" "SF Mono" "Hack" "Menlo" "Monaco" "DejaVu Sans Mono" "Consolas")
  "Monospace fonts to try in order.")

(defconst user/fallback-zh-fonts
  '("LXGW WenKai Mono" "LXGW Neo XiHei Screen Full" "LXGW WenKai" "LXGW Neo Xihei"
    "WenQuanYi Zen Hei" "PingFang SC" "Microsoft Yahei" "STFangsong")
  "Zh fonts to try in order.")

(defun font-installed-p (font-name)
  "Check if font with FONT-NAME is available."
  (find-font (font-spec :name font-name)))

(defun setup-fonts (&optional font-size)
  "Setup fonts.
FONT-SIZE is the default font size."
  (when (display-graphic-p)
    ;; Set default font
    (cl-loop for font in user/fallback-fonts
             when (font-installed-p font)
             return (set-face-attribute 'default nil
                                        :family font
                                        :height (if font-size
                                                    font-size
                                                  user/font-size)))
    ;; Set mode-line font
    ;; (cl-loop for font in '("Menlo" "SF Pro Display" "Helvetica")
    ;;          when (font-installed-p font)
    ;;          return (progn
    ;;                   (set-face-attribute 'mode-line nil :family font :height 120)
    ;;                   (when (facep 'mode-line-active)
    ;;                     (set-face-attribute 'mode-line-active nil :family font :height 120))
    ;;                   (set-face-attribute 'mode-line-inactive nil :family font :height 120)))

    ;; Specify font for all unicode characters
    (cl-loop for font in '("Symbols Nerd Font Mono" "Segoe UI Symbol" "Symbola" "Symbol")
             when (font-installed-p font)
             return (if (< emacs-major-version 27)
                        (set-fontset-font "fontset-default" 'unicode font nil 'prepend)
                      (set-fontset-font t 'symbol (font-spec :family font) nil 'prepend)))

    ;; Emoji
    (cl-loop for font in '("Noto Color Emoji" "Apple Color Emoji" "Segoe UI Emoji")
             when (font-installed-p font)
             return (cond
                     ((< emacs-major-version 27)
                      (set-fontset-font "fontset-default" 'unicode font nil 'prepend))
                     ((< emacs-major-version 28)
                      (set-fontset-font t 'symbol (font-spec :family font) nil 'prepend))
                     (t
                      (set-fontset-font t 'emoji (font-spec :family font) nil 'prepend))))

    ;; Specify font for Chinese characters
    (cl-loop for font in user/fallback-zh-fonts
             when (font-installed-p font)
             return (progn
                      ;; (setq face-font-rescale-alist `((,font . 1.2)))
                      (set-fontset-font t 'han (font-spec :family font))))))

(defun my/font-set-rescale (font scale)
  "Set the rescale factor for FONT to SCALE in `face-font-rescale-alist'.
If an entry for FONT already exists, update it in place; otherwise
push a new (FONT . SCALE) entry onto the alist."
  (let ((entry (assoc font face-font-rescale-alist)))
    (if entry
        (setcdr entry scale)
      (push `(,font . ,scale) face-font-rescale-alist))))

(defun my/font-measure-rescale (char1 char2)
  "Return the rescale factor of CHAR1 relative to CHAR2.
Measure the string pixel-width ratio of CHAR1 to CHAR2 at scale 1;
the factor 2.0 accounts for CJK characters being double-width
relative to Latin characters.

For example, (my/font-measure-rescale \"h\" \"汉\") returns 1.0 when
the font has the correct 1:2 Latin-to-CJK width ratio."
  (/ (* 2.0 (string-pixel-width char1))
     (string-pixel-width char2)))

(defun my/setup-zh-font-rescale ()
  "Set font rescale factors for the first setup Chinese font.
Iterate over `user/favourite-zh-fonts' followed by `user/fallback-zh-fonts';
for the first font that is installed, set the rescale for Latin glyphs to 1
and the CJK rescale to the factor measured by `my/font-measure-rescale'."
  (cl-loop for font in user/fallback-zh-fonts
           when (font-installed-p font)
           return (progn
                    (my/font-set-rescale font 1)
                    (set-fontset-font t 'han (font-spec :family font))
                    (my/font-set-rescale font (my/font-measure-rescale "h" "汉"))
                    (set-fontset-font t 'han (font-spec :family font)))))

;;; setup default font
(add-hook 'window-setup-hook #'setup-fonts)
(add-hook 'window-setup-hook #'my/setup-zh-font-rescale 99)

(add-hook 'server-after-make-frame-hook #'setup-fonts)
(add-hook 'server-after-make-frame-hook #'my/setup-zh-font-rescale 99)

(defun set-font-size (symbol value)
  "Set font SYMBOL VALUE."
  (set-default-toplevel-value symbol value)
  (setup-fonts value))

(defcustom user/font-size (cond (sys/macp user/default-mac-font-size)
                                (sys/win32p user/default-win-font-size)
                                (t user/default-linux-font-size))
  "The font size."
  :group 'user
  :type 'number
  :set #'set-font-size)

(provide 'init-font)
;;; init-font.el ends here

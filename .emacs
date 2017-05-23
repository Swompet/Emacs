4
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(c++-mode-hook (quote (glasses-mode)))
 '(custom-enabled-themes nil)
 '(package-selected-packages
   (quote
    (highlight-chars edit-server magit cmake-ide yasnippet helm auto-complete)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Terminus" :foundry "raster" :slant normal :weight normal :height 120 :width normal))))
 '(font-lock-comment-face ((t (:foreground "Firebrick" :weight extra-bold :height 1.009))))
 '(font-lock-function-name-face ((t (:foreground "Blue1" :height 1.045))))
 '(font-lock-keyword-face ((t (:foreground "Purple" :weight extra-bold))))
 '(font-lock-type-face ((t (:foreground "ForestGreen" :weight ultra-bold :height 1.03)))))


(require 'package)
; add MELPA to repository list
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

(package-initialize)
(require 'auto-complete)


;do default config for auto-complete

(require 'auto-complete-config)
(ac-config-default)


(require 'yasnippet)
(yas-global-mode 1)

; turn on Semantic
(semantic-mode 1)
(defun my:add-semantic-to-autocomplete() 
  (add-to-list 'ac-sources 'ac-source-semantic)
)
(add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)
; turn on ede mode 
(global-ede-mode 1)

(setq w32-pipe-read-delay 0)


(require 'helm)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x r b") 'helm-bookmarks)
(global-set-key [f6] 'helm-google-suggest)


(setq ring-bell-function 'ignore)


(global-set-key [f4] 'semantic-ia-fast-jump)
(global-set-key [f5] 'cmake-ide-compile)
(global-set-key [f12] 'other-window)
(global-set-key [f11] 'gdb)

(setq auto-save-default nil)
(setq backup-directory-alist `(("." . "~/.saves")))

(global-set-key [f8] 'edit-server-done)
(add-to-list 'load-path "c:/Users/Simon Bohnen/AppData/Roaming/.emacs.d/lisp
")
(require 'edit-server)
(edit-server-start)

;;;;;;;;;;;;;;;;;;;;;ALEXANDER BECHER;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; use spaces as glasses separator, and replace underscores by spaces
;; (or maybe show them in the shadow face)

;; Extensions to glasses mode
;;
;; 1. Put a space in front of an opening parenthesis even if it is
;; preceded by a number, as in, e.g., f2(): Add 0-9 in the character
;; class of the regexp in glasses-make-readable.
;;
;; 2. Put a space behind each comma.
;;
;; 3. Display ASCII arrows -> as proper right arrows U+2192. However,
;; a simple (put ... 'evaporate t) is not enough, as the overlay
;; covers two characters. Luckily, the JIT function deletes all
;; overlays anyway.
;;
;;  * TODO: speed up! maybe use font-lock-add-keywords
;;  * TODO: Integrate ab/glasses-set-overlay-properties into
;;    ab/glasses-overlays-symbols.
;;  * TODO: <<=
;;  * TODO: Enforce spaces around operators and after semicolons:
;;    for(i=1;i<=n;i++) -> for (i = 1; i <= n; i++) // "\\(\\sw\\|\\s_\\)"
;;  * TODO: Special cases: {m_,}p{machine,core,model,data,block}
;;  * TODO: We could use font-lock-add-keywords like hi-lock-mode.
;;  * TODO: Consider not replacing arrows and periods in
;;    font-lock-string-face
(defun ab/glasses-set-overlay-properties ()
  "Set properties of ab/glasses overlays.
Consider current setting of user variables."
  ;; ADD NEW OVERLAYS ALSO TO `ab/glasses-overlay-p'!
  (put 'ab/glasses 'evaporate t)
  (put 'ab/glasses-comma 'after-string " ")
  (put 'ab/glasses-arrow 'display " \u2192 ")
  (put 'ab/glasses-arrow 'face 'variable-pitch)
  (put 'ab/glasses-period 'display " \u00b7 ") ;U+2022 bullet or U+00B7 midpoint
  (put 'ab/glasses-period 'face 'variable-pitch)
  ;; (put 'ab/glasses-prefix 'invisible t)
  (put 'ab/glasses-prefix 'display "\u00b4") ;U+00B4 acute accent
  (put 'ab/glasses-prefix 'face 'variable-pitch)
  (put 'ab/glasses-prefix-visible 'display "_")
  (put 'ab/glasses-quote-double-open 'display "\u201C")
  (put 'ab/glasses-quote-double-close 'display "\u201D")
  (put 'ab/glasses-quote-single-open 'display "\u2018")
  (put 'ab/glasses-quote-single-close 'display "\u2019")
  (put 'ab/glasses-not-equal 'display "\u2260")
  (put 'ab/glasses-less-than-or-equal 'display "\u2264")
  (put 'ab/glasses-greater-than-or-equal 'display "\u2265")
  (put 'ab/glasses-guillemet-left 'display "\u00ab")
  (put 'ab/glasses-guillemet-right 'display "\u00bb")
  (put 'ab/glasses-indent-space 'before-string " ")
  )
(ab/glasses-set-overlay-properties)
(defvar ab/glasses-overlays-symbols
  '(;; Ensure commas are followed by a space.
    ("\\(,\\)\\(\\S-\\)" ab/glasses-comma 1)
    ;; Display the ASCII arrow -> as proper right arrow U+2192 with spaces around it.
    (" ?-> ?" ab/glasses-arrow)
    ;; Display the C element access operator, period, as midpoint with
    ;; spaces around it (but not in floating point constants).
    ("\\(\\sw\\|\\s_\\|\\s)\\)\\(\\.\\)\\([[:alpha:]]\\|\\s_\\|\\s(\\)" ab/glasses-period 2 2)
    ("!=" ab/glasses-not-equal)
    ("\\(<=\\)\\([^=]\\|$\\)" ab/glasses-less-than-or-equal 1)
    (">=" ab/glasses-greater-than-or-equal)
    ("\\(^\\|[^<]\\)\\(<<\\)\\($\\|[^<]\\)" ab/glasses-guillemet-left 2)
    ("\\(^\\|[^>]\\)\\(>>\\)\\($\\|[^>]\\)" ab/glasses-guillemet-right 2))
  "A list of (REGEXP CATEGORY &optional SUBEXPR).
Makes an overlay with category CATEGORY with the range of
sub-expression SUBEXPR (default 0) for each occurrence of
REGEXP.")
(defun ab/glasses-overlay-p (overlay)
  "Return whether OVERLAY is an overlay of ab/glasses mode."
  (memq (overlay-get overlay 'category)
	'(ab/glasses ab/glasses-comma ab/glasses-arrow ab/glasses-period
		     ab/glasses-prefix ab/glasses-prefix-visible
		     ab/glasses-quote-double-open
		     ab/glasses-quote-double-close
		     ab/glasses-quote-single-open
		     ab/glasses-quote-single-close
		     ab/glasses-not-equal
		     ab/glasses-greater-than-or-equal
		     ab/glasses-less-than-or-equal
		     ab/glasses-guillemet-left
		     ab/glasses-guillemet-right
		     ab/glasses-indent-space
		     )))
(defun ab/glasses-make-overlay (beg end &optional category)
  ;; The 'front-advance part is important to get sane cursor movement
  ;; when editing in the vicinity of invisible overlays.
  (let ((o (make-overlay beg end nil 'front-advance)))
    (overlay-put o 'category (or category 'ab/glasses))
    (overlay-put o 'evaporate t)
    ;(message "overlay from %d to %d of category %s" beg end category)
    o))
(defun ab/glasses-make-readable-helper (beg end regexp &optional category subexpr endchar)
  "Mark matches in region between BEG and END with a glasses overlay.
If SUBEXPR is given, it specifies the parenthesized
sub-expression that is marked with the overlay.
If specified, ENDCHAR moves point to the end of the sub-expression."
  (goto-char beg)
  (let ((n (or subexpr 0)))
    (while (re-search-forward regexp end t)
      (ab/glasses-make-overlay (match-beginning n) (match-end n) category)
      (if endchar (goto-char (match-end endchar))))))
(defun ab/glasses-make-readable-symbols (beg end)
  "Makes the substitutions defined in `ab/glasses-overlays-symbols'."
  (mapc (lambda (def)
	  (apply 'ab/glasses-make-readable-helper beg end def))
	ab/glasses-overlays-symbols)
  (goto-char beg)
  (while (re-search-forward "^ +" end t)
    ;(message "found indentation blanks from %d to %d" (match-beginning 0) (match-end 0))
    (goto-char (match-beginning 0))
    (let ((limit (match-end 0)))
      (while (< (point) limit)
	(ab/glasses-make-overlay (point) (1+ (point)) 'ab/glasses-indent-space)
	(ignore-errors (forward-char))))))
(defvar ab/glasses-hungarian-prefixes
  '("b" "ch" "d" "e" "f" "h" "i" "l" "lpsz" "n" "o"
    "p" "pb" "pc" "pd" "pf" "ph" "pl" "psz" "pt" "pv"
    "r" "rb" "rn" "rs" "rstr" "rsz" "rv"
    "s" "sl" "str" "sz" "t" "u" "v")
  "Make these prefixes invisible when followed by an uppercase letter.
For instance, nIndex becomes Index.")
(defvar ab/glasses-hungarian-param-prefixes '("i_" "io_" "o_")
  "List of parameter prefixes used in hungarian notation.
`ab/glasses-make-readable-hungarian' displays them in the face
`ab/glasses-prefix', which defaults to being invisible.")
(defvar ab/glasses-hungarian-member-prefixes '("m_")
  "List of member prefixes used in hungarian notation.
`ab/glasses-make-readable-hungarian' hides these completely if
preceded by an arrow or dot operator, and otherwise replaces them
by `ab/glasses-hungarian-member-prefix'.") ;TODO stimmt nicht, gibt's nicht
(defvar ab/glasses-hungarian-skip (append ab/glasses-hungarian-param-prefixes ab/glasses-hungarian-member-prefixes)
  "Also look for hungarian prefixes after skipping these strings.
For instance, m_bFlag becomes m_Flag.")
(defun ab/glasses-make-readable-hungarian (beg end)
  "Remove prefixes used by hungarian notation."
  ;; We delete any ordinary glasses overlay, so we proceed by hand
  ;; instead of using ab/glasses-make-readable-helper.
  (goto-char beg)
  (while (re-search-forward
	  (concat "\\_<" (regexp-opt ab/glasses-hungarian-skip t) "?"
		  (regexp-opt ab/glasses-hungarian-prefixes t) "[[:upper:]]")
	  end t)
    (unless (eq (get-char-property (match-end 2) 'face) 'font-lock-string-face)
     (ab/glasses-make-overlay (match-beginning 2) (match-end 2) 'ab/glasses-prefix)
     (dolist (o (overlays-at (match-end 2)))
       (when (eq (overlay-get o 'category) 'glasses)
	 (delete-overlay o)))))
  (goto-char beg)
  (while (re-search-forward
	  (concat "\\_<" (regexp-opt ab/glasses-hungarian-member-prefixes t))
	  end t)
    (let* ((from (match-beginning 1))
	   (to (match-end 1))
	   (category (progn
		       (save-excursion
			 (goto-char from)
			 (if (looking-back "\\(\\.\\|->\\|::\\)")
			     'ab/glasses-prefix
			   'ab/glasses-prefix-visible)))))
      (ab/glasses-make-overlay from to category)))
  (ab/glasses-make-readable-helper 
   beg end (concat "\\_<" (regexp-opt ab/glasses-hungarian-param-prefixes t))
   'ab/glasses-prefix 1))
(defun ab/glasses-opening-quote-p (pos)
  "Determine whether the quote at the given position is an opening quote.
Checks if the syntax parser state reports being inside a string
one position past the quote."
  (save-restriction
    (widen)
    (let ((parser-state (syntax-ppss (1+ pos))))
      (nth 3 parser-state))))
(defun ab/glasses-quote-category (pos str)
  "Return the overlay category for the quote STR at position POS."
  (let ((open (ab/glasses-opening-quote-p pos)))
    (cond ((not (eq (get-text-property pos 'face) font-lock-string-face))
	   nil)
	  ((string= str "\"")
	   (if open
	       'ab/glasses-quote-double-open
	     'ab/glasses-quote-double-close))
	  ((string= str "'")
	   (if open
	       'ab/glasses-quote-single-open
	     'ab/glasses-quote-single-close)))))
(defun ab/glasses-make-readable-quotes (beg end)
  "Display quotes as typographic quotes."
  (goto-char beg)
  (while (re-search-forward "['\"]" end t)
    (let ((category
	   (ab/glasses-quote-category
	    (match-beginning 0) (match-string 0))))
      (if category
	  (ab/glasses-make-overlay (match-beginning 0) (match-end 0) category)))))
(defun ab/glasses-make-readable (beg end)
  "Extensions to `glasses-make-readable' to be called from inside it."
  (let ((case-fold-search nil))
    (save-excursion
      (ab/glasses-make-readable-symbols beg end)
      (ab/glasses-make-readable-hungarian beg end)
      (ab/glasses-make-readable-quotes beg end)
      )))
(defun ab/glasses-make-unreadable (beg end)
  "Cancels the effects of `ab/glasses-make-readable'.
Removes the overlays inserted by `ab/glasses-make-readable'."
  (dolist (o (overlays-in beg end))
    (when (ab/glasses-overlay-p o)
      (delete-overlay o))))
;; (defun ab/glasses-change-hook (beg end)
;;   (ab/glasses-make-unreadable beg end)
;;   (ab/glasses-make-readable beg end))
;; (define-minor-mode ab/glasses-mode "AB's extensions to `glasses-mode'."
;;   ""
;;   (if ab/glasses-mode
;;       ;; append to be called after glasses-mode
;;       (add-hook 'jit-lock-functions 'ab/glasses-change-hook t t)
;;     (remove-hook 'jit-lock-functions 'ab/glasses-change-hook t)))
;; Grmpf. Why does it not work?
(defadvice glasses-make-readable (after ab/glasses-make-readable (beg end))
  "AB's extensions to glasses-mode"
  (ab/glasses-make-readable beg end))
(defadvice glasses-make-unreadable (after ab/glasses-make-unreadable (beg end))
  "AB's extensions to glasses-mode"
  (ab/glasses-make-unreadable beg end))
(defadvice c-indent-region (around ab/glasses (start end))
  "AB's extensions to glasses-mode confuse the indentation of cc-mode.
Temporarily turn them off during indentation.

The reason is that an invisible overlay at the start of the
line (after indentation) makes c-get-syntactic-indentation think
that the line starts at column 0."
  (ab/glasses-make-unreadable start end)
  ad-do-it
  (ab/glasses-make-readable start end))
;;;;;;;;;;;;;;;;;;;;;ALEXANDER BECHER;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



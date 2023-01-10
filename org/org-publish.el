;; Publish Org document

(setq script-directory (file-name-directory (expand-file-name (or load-file-name (buffer-file-name)))))
(add-to-list 'load-path (expand-file-name "./htmlize" script-directory))

(require 'org)
(require 'htmlize)

(setq org-src-fontify-natively t
      org-src-window-setup 'current-window
      org-src-strip-leading-and-trailing-blank-lines nil
      org-src-preserve-indentation t
      org-src-tab-acts-natively t
      )
;;(setq org-element-use-cache nil)

(defvar shell-session-mode-font-lock-keywords
  '(("^ *\\([^$#%\t\r\n]*\\([$#]\\)\\)\\(\n\\| \\)" 1 font-lock-function-name-face)
    ("[ \t]\\([+-][^ \t\n]+\\)" 1 font-lock-comment-face))
  "Highlight bash shell session for `org-mode'.")

(defvar dos-session-mode-font-lock-keywords
  '(("^ *\\([A-Z]:[^]\t\r\n<>'\"/[]+>\\)\\(\n\\| *\\)" 1 font-lock-function-name-face)
    ("^[ \t]\\([+-/][^ \t\n\\[\\];'\"<>]+\\)" 1 font-lock-comment-face))
  "Highlight windows command prompt session for `org-mode'.")

(define-derived-mode shell-session-mode text-mode "Shell-session"
  "Major mode for shell session for `org-mode'."
  (setq font-lock-defaults '(shell-session-mode-font-lock-keywords t)))

(define-derived-mode dos-session-mode text-mode "DOS"
  "Major mode for DOS prompt session for `org-mode'."
  (setq font-lock-defaults '(dos-session-mode-font-lock-keywords t)))

(setq org-publish-project-alist
      '(
	("project"
	 :components
	 ("project-org"
	  "project-static"
	  "project-theme"
	  ))
	("project-org"
	 :publishing-function org-html-publish-to-html
	 :base-directory "./"
	 :recursive nil
	 :publishing-directory "./build"
	 :section-numbers nil
	 :table-of-contents nil)
	("project-static"
	 :publishing-function org-publish-attachment
	 :base-directory "./static"
	 :recursive t
	 :publishing-directory "./build"
	 :base-extension any)
	("project-theme"
	 :publishing-function org-publish-attachment
	 :base-directory "./themes/current/static"
	 :recursive t
	 :publishing-directory "./build"
	 :base-extension any)
	))

(let ((default-directory script-directory))
  (org-publish-project "project" t))

(message "出力を完了しました。このウィンドウを閉じて下さい。")

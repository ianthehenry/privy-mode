;; -*- lexical-binding: t; -*-

(defgroup privy nil
  "A mode for the Ivy language and the Privy preprocessor"
  :group 'languages)

(defvar privy-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?# "<" table)
    (modify-syntax-entry ?\n ">" table)
    (modify-syntax-entry ?` "\"" table)
    (modify-syntax-entry ?' "\"" table)
    table))

(defconst privy-symbol '(one-or-more (or (syntax word) (syntax symbol))))

(defconst privy-binding-pattern
  (rx-to-string `(sequence (group ,privy-symbol) "="))
  "The regex to identify variable declarations.")

(defconst privy-unary-op-declaration-pattern
  (rx-to-string `(sequence "op"
    (1+ space) (group ,privy-symbol)
    (1+ space) ,privy-symbol 
    (0+ space) "="))
  "The regex to identify unary ops.")

(defconst privy-binary-op-declaration-pattern
  (rx-to-string `(sequence "op"
    (1+ space) ,privy-symbol
    (1+ space) (group ,privy-symbol)
    (1+ space) ,privy-symbol
    (0+ space) "="))
  "The regex to identify binary ops.")

(defconst privy-error-pattern
  (rx-to-string `(sequence bol "#!" (0+ nonl) eol)))

(defcustom privy-special-forms '("op")
  "List of Ivy special forms."
  :type '(repeat string)
  :group 'privy)

(defcustom privy-builtins
  '(
    ; unary
    "?"
    "ceil"
    "floor"
    "rho"
    "not"
    "abs"
    "iota"
    "**"
    "-"
    "+"
    "sgn"
    "/"
    ","
    "log"
    "rot"
    "flip"
    "up"
    "down"
    "ivy"
    "text"
    "transp"
    "!"
    "^"
    "sqrt"
    "sin"
    "cos"
    "tan"
    "asin"
    "acos"
    "atan"
    "sinh"
    "cosh"
    "tanh"
    "asinh"
    "acosh"
    "atanh"
    "j"
    "real"
    "imag"
    "phase"

    ; binary
    "+"
    "-"
    "*"
    "/"
    "div"
    "idiv"
    "**"
    "sin"
    "cos"
    "tan"
    "?"
    "in"
    "max"
    "min"
    "rho"
    "take"
    "drop"
    "decode"
    "encode"
    "mod"
    "imod"
    ","
    "fill"
    "sel"
    "iota"
    "rot"
    "flip"
    "log"
    "text"
    "transp"
    "!"
    "<="
    "=="
    ">="
    "<<"
    ">>"
    "<"
    ">"
    "!="
    "or"
    "and"
    "nor"
    "nand"
    "xor"
    "&"
    "|"
    "^"
    "j"

    ; type conversions
    "code"
    "char"
    "float"
    )
  "List of Ivy special forms."
  :type '(repeat string)
  :group 'privy)

(defconst privy-special-form-pattern
  (let ((builtins (cons 'or privy-builtins)))
    (rx-to-string `(sequence symbol-start (group ,builtins) symbol-end)))
  "The regex to identify Ivy builtins.")

(defconst privy-highlights
  `((,privy-special-form-pattern . (1 font-lock-keyword-face))
    (,privy-unary-op-declaration-pattern . (1 font-lock-function-name-face))
    (,privy-binary-op-declaration-pattern . (1 font-lock-function-name-face))
    (,privy-binding-pattern . (1 font-lock-variable-name-face))
    (,privy-special-form-pattern . (1 font-lock-variable-name-face))
    (,privy-error-pattern . (1 font-lock-warning-face))
    ))

;;;###autoload
(define-derived-mode privy-mode prog-mode "privy"
  "Major mode for the Ivy language and the Privy preprocessor"
  :syntax-table privy-mode-syntax-table
  (setq-local font-lock-defaults '(privy-highlights))
  (setq-local comment-start "#")
  (setq-local comment-start-skip "#+ *")
  (setq-local comment-use-syntax t)
  (setq-local comment-end ""))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.ivy\\'" . privy-mode))

(provide 'privy-mode)

(require 'helm)

(defun show-path (path)
  (if (file-directory-p path)
      (mapcar* #'cons (mapcar #'f-filename (f-entries path))(f-entries path))
    (if (file-exists-p path) (s-split "\n" (f-read-text path)) ())))

(defun helm-pass-source-sentences (path)
  (helm-build-sync-source "Searching phrase bank"
    :candidates (show-path path)
    :action '(("Insert phrase or enter directory" .
               (lambda (candidate)
                 (if (file-directory-p candidate)
                     (helm-ffrfd candidate)
                   (if (file-exists-p candidate)
                       (helm-ffrfd candidate)
                     (insert candidate)))))
              ("Yank absolute path or phrase" . kill-new))))

(defun helm-ffrfd (path)
  "Helm interface for mail content"
  (interactive)
  (helm :sources (helm-pass-source-sentences path)
        :buffer  "*Email sentences"))


(defun helm-pass-source-sentences-d (path)
  (helm-build-sync-source "Searching phrase bank"
    :candidates (show-path path)
    :action '(("Insert phrase or enter directory" .
               (lambda (candidate)
                 (if (file-directory-p candidate)
                     (helm-ffrfdd candidate)
                   (if (file-exists-p candidate)
                       (with-current-buffer
                           (find-file candidate)
                         (goto-char (point-min)))
                     ())))))))

(defun helm-ffrfdd (path)
  "Helm interface for mail content"
  (interactive)
  (helm :sources (helm-pass-source-sentences-d path)
        :buffer  "*Go to target"))

(provide 'corpus)

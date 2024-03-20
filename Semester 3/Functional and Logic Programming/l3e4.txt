(defun produs-rec (element)
    (cond
      ((numberp element) element)
      ((atom element) 1)
      ((listp element) (apply #'* (mapcar #'produs-rec element)))))

(defun produs(lst)

  (apply #'* (mapcar #'produs-rec lst)))

  
(print (produs '(1 2 3 (4 5 6 (7)))))
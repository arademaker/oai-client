;;  Author: Alexandre Rademaker

(asdf:defsystem #:oai-client
  :serial t
  :depends-on (#:cxml #:drakma #:xuriella)
  :components ((:file "packages") 
	       (:file "oai-client" :depends-on ("packages"))))


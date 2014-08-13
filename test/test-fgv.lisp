
(ql:quickload :oai-client)

(in-package :oai-client)

(defvar *pkg-dir* (pathname-directory (asdf:system-definition-pathname (asdf:find-system :oai-client))))
(defvar *xsl-dir* (append *pkg-dir* (list "xsl")))
(defparameter *server* "http://bibliotecadigital.fgv.br/oai/request")


(defparameter *sets* (mapcar (lambda (n) (format nil "hdl_10438_~a" n))
			     '(2692 1758 8686 10191 8139 2203 2204 2205 2198 2202 
			       2200 2201 8295 8471 3257 3258 3256 10931 1755 1756 
			       7679 1754 8871 11122 3 4 6 8581 8873 8875)))

;; save the xml files in the current directory. Future versions will
;; allow define the directory to save the files.
(mapcar (lambda (s) (list-records s :baseuri *server*)) 
	*sets*)

;; just to remind me how to use xuriella 
(xuriella:apply-stylesheet (make-pathname :directory *xsl-dir* :name #P"mets2rdf.xsl") 
			   #P"hdl_10438_1754_0.xml" 
			   :output #P"hdl_10438_1754_0.rdf")


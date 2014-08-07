;; Author: Alexandre Rademaker

(in-package :oai-client)

(defun save-request (uri filename parameters)
  (with-open-file (out filename :direction :output :if-exists :supersede)
    (let* ((in (drakma:http-request uri :parameters parameters))
	   (source (cxml:make-source in)))
      (format out "~a" in)
      (if (klacks:find-element source "resumptionToken")
	  (nth 2 (klacks:serialize-element source (cxml-xmls:make-xmls-builder)))))))


(defun list-records (set &key (metadata "mets") (baseuri nil) (prefix set))
  (do* ((counter 0 (1+ counter))
	(filename (format nil "~a_~a.xml" prefix counter) 
		  (format nil "~a_~a.xml" prefix counter))
	(parameters `(("verb" . "ListRecords")
		      ("set" . ,set)
		      ("metadataPrefix" . ,metadata))
		    `(("verb" . "ListRecords")
		      ("resumptionToken" . ,response)))
	(response (save-request baseuri filename parameters)
		  (save-request baseuri filename parameters)))
       ((null response))))



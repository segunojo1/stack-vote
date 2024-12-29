(define-trait loggable
  (
    (log-event (event_name (buff 60)) (data (buff 200)))
  ))

(define-public (log-event (event_name (buff 60)) (data (buff 200)))
  (begin
    (print (tuple (event event_name) (details data)))
    (ok "Event logged!")
  ))

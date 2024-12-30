(define-map votes
  { voter: principal }
  { count: uint })

(define-data-var voting-start uint u0)
(define-data-var voting-end uint u0)

;; Public function to set voting start and end block heights
(define-public (set-voting-period (start uint) (end uint))
  (begin
    (asserts! (>= end start) (err u100)) ;; Ensure end block is after start block
    (var-set voting-start start)
    (var-set voting-end end)
    (ok "Voting period set successfully!")
  ))

;; Function to check the election status
(define-read-only (election-status)
  (let ((start (var-get voting-start))
        (end (var-get voting-end)))
    (if (< block-height start)
      (ok "Not Started")
      (if (<= block-height end)
        (ok "In Progress")
        (ok "Ended")))))

;; Function to get the total number of votes cast
(define-read-only (get-total-votes)
  (fold votes
        (fn (key { voter: principal } acc uint) (+ acc u1))
        u0))

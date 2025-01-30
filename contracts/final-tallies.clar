(define-map final-tallies
  { tally_id: uint }
  { victor: (buff 60), total_votes: uint })

;; Function to log the final result of an election
(define-public (declare-victor (tally_id uint) (victor (buff 60)) (total_votes uint))
  (begin
    (asserts! (is-none (map-get? final-tallies { tally_id: tally_id })) (err u600)) ;; Ensure result isn't already recorded
    (map-set final-tallies { tally_id: tally_id } { victor: victor, total_votes: total_votes })
    (ok "Final tally recorded successfully.")
  ))

;; Function to retrieve the victor of a completed election
(define-read-only (fetch-victor (tally_id uint))
  (map-get? final-tallies { tally_id: tally_id }))

;; Function to check if a final tally has been recorded
(define-read-only (tally-exists? (tally_id uint))
  (is-some (map-get? final-tallies { tally_id: tally_id })))

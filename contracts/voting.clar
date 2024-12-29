(define-map votes
  { voter: principal }
  { candidate_id: uint })

(define-data-var voting-start uint u0)
(define-data-var voting-end uint u0)

(define-public (set-voting-period (start uint) (end uint))
  (begin
    (asserts! (is-eq tx-sender admin) (err u401)) ;; Only admin
    (asserts! (< start end) (err u400)) ;; Start must be before end
    (var-set voting-start start)
    (var-set voting-end end)
    (ok "Voting period set successfully!")
  ))

(define-public (vote (candidate_id uint))
  (begin
    (asserts! (>= block-height (var-get voting-start)) (err u403)) ;; Voting not started
    (asserts! (<= block-height (var-get voting-end)) (err u403)) ;; Voting ended
    (asserts! (is-none (map-get votes { voter: tx-sender })) (err u409)) ;; One vote per user
    (let ((candidate (map-get candidates { id: candidate_id })))
      (asserts! (is-some candidate) (err u404)) ;; Candidate must exist
      (map-set votes { voter: tx-sender } { candidate_id: candidate_id })
      (map-update candidates
        { id: candidate_id }
        (fn (data { name: (buff 60), vote_count: uint }) 
          { name: (get name data), vote_count: (+ (get vote_count data) u1) }))
      (ok "Vote cast successfully!")
    )))

(define-read-only (get-votes (candidate_id uint))
  (let ((candidate (map-get candidates { id: candidate_id })))
    (if (is-some candidate)
      (ok (get vote_count (unwrap! candidate (err u404))))
      (err u404)
    )))

(define-read-only (get-results)
  (map-fold candidates (fn (id uint) (data { name: (buff 60), vote_count: uint }) (tuple (id id) (vote_count (get vote_count data))))
             []))

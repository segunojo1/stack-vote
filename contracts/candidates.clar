(define-map candidates
  { id: uint }
  { name: (buff 60), vote_count: uint })

(define-constant admin 'ST1234567890ABCDEFG)

(define-public (add-candidate (id uint) (name (buff 60)))
  (begin
    (asserts! (is-eq tx-sender admin) (err u401)) ;; Only admin
    (asserts! (isnone (map-get candidates { id: id })) (err u409)) ;; Candidate ID must be unique
    (map-set candidates { id: id } { name: name, vote_count: u0 })
    (ok "Candidate added successfully!")
  ))

(define-public (remove-candidate (id uint))
  (begin
    (asserts! (is-eq tx-sender admin) (err u401)) ;; Only admin
    (asserts! (is-some (map-get candidates { id: id })) (err u404)) ;; Candidate must exist
    (map-delete candidates { id: id })
    (ok "Candidate removed successfully!")
  ))

(define-read-only (get-candidate (id uint))
  (map-get candidates { id: id }))

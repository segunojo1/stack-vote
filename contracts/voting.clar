(define-map votes
{voter: (buff 60)}
{count: uint})

;;my new voting function
(define-public (placevote (voter (buff 60)))
  (begin
    (if (isnone (map-get votes {voter: voter}))
      (map-set votes {voter: voter} {count: u1})
      (map-update votes 
                  {voter: voter}
                  (fn (current {count: uint}) {count: (+current.count u1)})))
      (ok "Vote casted successfully!!! :)")))

(define-read-only (get-votes (voter (buff 60)))
  (default-to u0 (get count (map-get votes { voter: voter }))))
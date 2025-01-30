(define-map battle-grounds
  { arena_id: uint }
  { title: (buff 70), start_round: uint, end_round: uint })

(define-public (set-arena (arena_id uint) (title (buff 70)) (start_round uint) (end_round uint))
  (begin
    (asserts! (is-eq (map-get? bigBosses { handle: tx-sender }) (some { supreme: true })) (err u300))
    (asserts! (is-none (map-get? battle-grounds { arena_id: arena_id })) (err u301))
    (asserts! (>= end_round start_round) (err u302))
    (map-set battle-grounds { arena_id: arena_id } { title: title, start_round: start_round, end_round: end_round })
    (ok "New battle arena has been summoned!")
  ))

(define-read-only (inspect-arena (arena_id uint))
  (map-get? battle-grounds { arena_id: arena_id }))

(define-read-only (arena-status (arena_id uint))
  (let ((arena (map-get? battle-grounds { arena_id: arena_id })))
    (match arena
      some (let ((start (get start_round arena))
                 (end (get end_round arena)))
             (if (< block-height start)
                 (ok "The gates are closed.")
                 (if (<= block-height end)
                     (ok "Battle is ongoing!")
                     (ok "The dust has settled."))))
      none (err u303))))

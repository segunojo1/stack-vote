(define-map admins
  { address: principal }
  { is_admin: bool })

(define-public (add-admin (new_admin principal))
  (begin
    (asserts! (is-eq (map-get admins { address: tx-sender }) { is_admin: true }) (err u401))
    (map-set admins { address: new_admin } { is_admin: true })
    (ok "Admin added successfully!")
  ))

(define-public (remove-admin (admin_to_remove principal))
  (begin
    (asserts! (is-eq (map-get admins { address: tx-sender }) { is_admin: true }) (err u401))
    (asserts! (is-eq tx-sender admin_to_remove) (err u403)) ;; Cannot remove self
    (map-delete admins { address: admin_to_remove })
    (ok "Admin removed successfully!")
  ))

(define-read-only (is-admin (address principal))
  (is-eq (map-get admins { address: address }) { is_admin: true }))

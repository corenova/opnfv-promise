module.exports = (input, resolve, reject) ->
  # 1. find the reservation
  reservation = @find 'ResourceReservation', input['reservation-id']
  unless reservation?
    return resolve result: 'error', message: 'no reservation found for specified identifier'

  # 2. destroy all traces of this reservation
  reservation.destroy()
  .then =>
    (@access 'promise.reservations').remove reservation.id
    resolve result: 'ok', message: 'reservation canceled'
  .catch (e) -> resolve result: 'error', message: e

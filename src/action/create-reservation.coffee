module.exports = (input, resolve, reject) ->
  # 1. create the reservation record (empty)
  reservation = @create 'ResourceReservation'
  reservations = @get '/promise/reservations'

  # 2. update the record with requested input
  reservation.update input
  .then (res) ->
    # 3. save the record and add to list
    res.save()
    .then ->
      reservations.push res
      resolve
        result: 'ok'
        message: 'reservation request accepted'
        'reservation-id': res.id
    .catch (err) ->
      resolve result: 'error', message: err
  .catch (err) ->
    resolve result: 'conflict', message: err

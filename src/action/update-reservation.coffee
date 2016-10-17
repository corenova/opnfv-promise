#
# Author: Peter K. Lee (peter@corenova.com)
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

module.exports = (input, resolve, reject) ->
  # TODO: we shouldn't need this... need to check why leaf mandatory: true not being enforced
  unless input['reservation-id']?
    return resolve result: 'error', message: "must provide 'reservation-id' parameter"

  # 1. find the reservation
  reservation = @find 'ResourceReservation', input['reservation-id']
  unless reservation?
    return resolve result: 'error', message: 'no reservation found for specified identifier'

  # 2. update the record with requested input
  reservation.update input
  .then (res) ->
    # 3. save the updated record
    res.save()
    .then ->
      resolve result: 'ok', message: 'reservation update successful'
    .catch (err) ->
      resolve result: 'error', message: err
  .catch (err) ->
    resolve result: 'conflict', message: err

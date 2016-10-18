module.exports = (input, resolve, reject) ->
  # validate that request contains sufficient data
  for k, v of input.capacity when v? and !!v
    hasCapacity = true
  if (not hasCapacity) and input.elements.length is 0
    return reject "unable to validate reservation record without anything being reserved"
  # time range verifications
  now = new Date
  start = (new Date input.start) if input.start?
  end   = (new Date input.end)   if input.end?
  # if start? and start < now
  #   return reject "requested start time #{input.start} cannot be in the past"
  if end? and end < now
    return reject "requested end time #{input.end} cannot be in the past"
  if start? and end? and start > end
    retun reject "requested start time must be earlier than end time"
  resolve this
  

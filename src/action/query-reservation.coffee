module.exports = (input, resolve, reject) ->
  input.capacity = 'reserved'
  @['query-capacity'] input
  .then (res) -> resolve res
  .catch (e)  -> reject e

window.addEventListener('message', function (event) {
  var data = event.data
  if (data.action == 'open') {
    refreshProgress(data.data.percent)
    $('#container').css('display', 'flex')
    $('#helper').html(data.data.text)
  } else if (data.action == 'refresh') {
    refreshProgress(data.data)
  } else if (data.action == 'close') {
    $('#container').css('display', 'none')
  }
})

function refreshProgress(percent) {
  $('#progress').css('width', `${percent}%`)
}

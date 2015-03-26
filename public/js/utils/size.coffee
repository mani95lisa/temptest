bytesToSize = (bytes)->
  sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB']
  return '0' if bytes == 0
  i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)))
  return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i]
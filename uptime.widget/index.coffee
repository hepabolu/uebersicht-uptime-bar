
command: "uptime"

# reduce the refresh frequency to minimise delay in the update (when the refresh doesn't occur at exactly the same moment)
refreshFrequency: 30 * 1000

# Set to true if you want to always see days, hours and minutes
# Set to false if you don't want to see the parts that are zero

showAllParts: false

style: """
  // Align contents left or right
  widget-align = left

  // Position this where you want
  top 170px
  right 250px

  // Statistics text settings
  color #fff
  font-family Helvetica Neue
  background rgba(#000, .5)
  padding 10px 10px 15px
  border-radius 5px

  .container
    width: 300px
    text-align: widget-align
    position: relative
    clear: both

  .widget-title
    text-align: widget-align

  .stats-container
    margin-bottom 5px
    border-collapse collapse

  td
    font-size: 14px
    font-weight: 300
    color: rgba(#fff, .9)
    text-shadow: 0 1px 0px rgba(#000, .7)
    text-align: widget-align

  .widget-title
    font-size 10px
    text-transform uppercase
    font-weight bold

  .label
    font-size 8px
    text-transform uppercase
    font-weight bold
"""

render: (output) -> """
<div class="container">
    <div class="widget-title">Uptime</div>
      <table class="stats-container" width="100%">
        <tr>
          <td class="stat"><span id ="uptime"></span></td>
        </tr>
      </table>
  </div>
</div>
"""

calcUptime: (output) ->
  uptime = output.substring output.indexOf('up') + 2, output.length
  uptime = uptime.split(",")

  if uptime[0].indexOf('day') == -1
    days = 0
    uptime[1] = uptime[0]
  else
    days = uptime[0]

  uptime[1].trim
  if uptime[1].indexOf('hr') > 0
    time = uptime[1].split(' ')
    hours = time[1]
    minutes = 0
  else
    if uptime[1].indexOf('min') > 0
      time = uptime[1].split(' ')
      hours = 0
      minutes = time[1]
    else
      if uptime[1].indexOf('sec') > -1
        hours = 0
        minutes = 0
      else
        time = uptime[1].split(":")
        hours = time[0]
        minutes = time[1]

  # return      
  days: days
  hours: hours
  minutes: minutes

update: (output, domEl) ->
  @$domEl = $(domEl)

  uptime = @calcUptime output
  days = uptime.days
  hours = uptime.hours
  minutes = uptime.minutes

  if @showAllParts
    if days == 0
      days = days + ' days '
    else
      days = days + ' '
    hours = hours + 'h '
    minutes = minutes + 'min'
  else
    if days == 0
      days = ''
    else
      days = days + ' '
    if hours == 0
      hours = ''
    else
      hours = hours + 'h '
    if minutes == 0
      minutes = ''
    else
      minutes = minutes + 'min'

  @$domEl.find('#uptime').text days + hours + minutes

class Tank < Qt::Widget
  attr_reader :x, :y

  def minimumSizeHint
    @thisMinSize = Qt::Size.new(@width,@height)
  end

  def sizeHint
    @thisSize = Qt::Size.new(@width,@height)
  end

  def initialize(parent=nil, x=0, y=0, ms=5, l=0, r=0)
    super(parent)

    @timeStepMs = ms
    @currentAngle = 0
    @currentSpeed = 0
    @maxFeetPerSecond = 5

    @pixelsPerFoot = 0.2
    @field = parent

    @x = x
    @y = y

    @lTrackSpeed = l
    @rTrackSpeed = r

    #puts "Init tank x,y #{@x},#{@y} L/R #{@lTrackSpeed}/#{@rTrackSpeed}"

    @width = 30; @height = 34;

    @pixmap = Qt::Pixmap.new("tank.png")
    @rect = Qt::Rect.new(-(@width/2),-(@height/2),@width,@height)
  end

  def currentAngle=(val)
    @currentAngle = val
    #puts "Angle is now #{@currentAngle}"
  end

  def lTrackSpeed=(val)
    @lTrackSpeed = val
    #puts "LSpeed is now #{@lTrackSpeed}"
  end

  def rTrackSpeed=(val)
    @rTrackSpeed = val
    #puts "RSpeed is now #{@rTrackSpeed}"
  end

  def turn(degrees)
    new_angle = @currentAngle + degrees

    if new_angle > 360
      new_angle = new_angle - 360
    elsif new_angle < -360
      new_angle = new_angle + 360
    end
    @currentAngle = new_angle
    #puts "New Angle #{@currentAngle}"
  end

  def move
    # The center of the tank  will probably be moving by the
    # average speed  of the  right and  left tracks.  At the
    # same time, the tank  will be rotating clockwise around
    # it's  center by  ([left track  speed] *  -[right track
    # speed]) / [width].

    # distance this tick = feet per time frame
    tick_size = (@timeStepMs.to_f/1000)
    #puts "Time Step #{tick_size} of a second"

    delta_speed = @lTrackSpeed.to_f - @rTrackSpeed.to_f
    delta_speed_percent = delta_speed * @maxFeetPerSecond
    real_delta_speed = delta_speed_percent * @pixelsPerFoot

    angle_delta = real_delta_speed / @width
    angle_delta *= (tick_size * 60)

    #puts "Turning by #{angle_delta} degrees"

    turn(angle_delta)

    speed_percent = ((@lTrackSpeed + @rTrackSpeed).to_f / 2).to_f/100

    #puts "Average speed #{speed_percent*100}%"

    real_distance = @maxFeetPerSecond.to_f * speed_percent.to_f
    #puts "Real Distance: #{real_distance} feet per second"

    pixel_distance = @pixelsPerFoot.to_f * real_distance.to_f
    #puts "Pixel Distance: #{pixel_distance} pixels per second"

    tick_distance = pixel_distance.to_f * tick_size.to_f
    #puts "Tick Distance: #{tick_distance} pixels"

    @x += Math.cos(@currentAngle*Math::PI/180).to_f * pixel_distance.to_f
    @y += Math.sin(@currentAngle*Math::PI/180).to_f * pixel_distance.to_f
    #puts "New X,Y #{@x},#{@y}"
  end

  def drawMe(painter)
    painter.translate(@x,@y)
    painter.rotate(@currentAngle)
    painter.drawPixmap(@rect, @pixmap)
  end
end

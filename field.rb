class MineField < Qt::Widget
  attr_reader :painter

  slots 'moveTank()', 'beginSweeping()', 'stopSweeping()', 'newGame()'

  def minimumSizeHint
    @thisMinSize ||= Qt::Size.new(@canvasWidth,@canvasHeight)
  end

  def sizeHint
    @thisSize ||= Qt::Size.new(@canvasWidth,@canvasHeight)
  end

  def initialize(parent=nil)
    super

    @numObstacles = 10
    @numSweepers  = 5
    @canvasWidth  = 1000
    @canvasHeight = 600
    @timeStepMs   = 5
    @currentAngle = 0
    @lTrackSpeed  = 0
    @rTrackSpeed  = 0

    @animationTimer = Qt::Timer.new(self)
    connect(@animationTimer, SIGNAL('timeout()'),
            self, SLOT('moveTank()'))

    newGame

    setPalette(Qt::Palette.new(Qt::Color.new(100,200,100)))
    setAutoFillBackground(true)
  end

  def newGame
    if @animationTimer.isActive
      @animationTimer.stop
    end

    @sweepers     = []
    @mines        = []

    @numObstacles.times do |i|
      x = rand(0..@canvasWidth); y = rand(0..@canvasHeight)
      m = Mine.new(self, x, y)
      @mines << m
    end

    @numSweepers.times do |i|
      x = rand(0..@canvasWidth); y = rand(0..@canvasHeight)
      t = Tank.new(self, x, y, @timeStepMs, rand(0..100), rand(0..100))
      @sweepers << t
    end

    update
  end

  def beginSweeping
    if @animationTimer.isActive
      return
    end

    @animationTimer.start(@timeStepMs)
  end

  def stopSweeping
    @animationTimer.stop
  end

  def moveTank
    @sweepers.map(&:move)
    update
  end

  def paintEvent(event)
    @sweepers.each do |s|
      painter = Qt::Painter.new(self)
      s.drawMe(painter)
      painter.end
    end

    @mines.each do |m|
      painter = Qt::Painter.new(self)
      m.drawMe(painter, @sweepers)
      painter.end
    end
  end
end

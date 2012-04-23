class Mine < Qt::Widget
  attr_reader :x, :y

  def minimumSizeHint
    @thisMinSize = Qt::Size.new(@width,@height)
  end

  def sizeHint
    @thisSize = Qt::Size.new(@width,@height)
  end

  def initialize(parent=nil, x=0, y=0)
    super(parent)

    @x = x
    @y = y

    #puts "Init mine x,y #{@x},#{@y}"

    @width = 16; @height = 14;

    @pixmap_off = Qt::Pixmap.new("mine_off.png")
    @pixmap_on = Qt::Pixmap.new("mine_on.png")

    @rect = Qt::Rect.new(-(@width/2),-(@height/2),@width,@height)
  end

  def drawMe(painter, sweepers)
    image_type = @pixmap_off
    sweepers.each_with_index do |s,i|
      x1 = @x
      x2 = s.x
      y1 = @y
      y2 = s.y

      #puts "Sweeper #{s.x},#{s.y} vs Mine #{@x},#{@y}"
      opposite = (y1 - y2)**2
      adjacent = (x1 - x2)**2

      distance = Math.sqrt(opposite + adjacent)
      if distance < 20
        image_type = @pixmap_on
      end

      #puts "Sweeper ##{i} distance #{distance}"
    end

    painter.translate(@x,@y)
    painter.drawPixmap(@rect, image_type)
  end
end

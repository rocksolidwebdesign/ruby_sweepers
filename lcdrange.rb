class LCDRange < Qt::Widget
  signals 'valueChanged(int)'
  slots 'setValue(int)', 'setRange(int, int)'

  def initialize(parent=nil)
    super

    lcd = Qt::LCDNumber.new(3)

    @slider = Qt::Slider.new(Qt::Horizontal)
    @slider.setRange(0, 360)
    @slider.setValue(0)

    connect(@slider, SIGNAL('valueChanged(int)'),
            lcd, SLOT('display(int)'))

    connect(@slider, SIGNAL('valueChanged(int)'),
            self, SIGNAL('valueChanged(int)'))

    layout = Qt::VBoxLayout.new
    layout.addWidget(lcd)
    layout.addWidget(@slider)
    setLayout(layout)

    setFocusProxy(@slider)
  end

  def value
    @slider.value
  end

  def setValue(value)
    @slider.setValue(value)
  end

  def setRange(minVal, maxVal)
    if minVal < 0 || maxVal > 360 || minVal > maxVal
      qWarning("LCDRange::setRange(#{minVal}, #{maxVal})\n" +
               "\tRange must be 0..360\n" +
               "\tand minVal must not be greater than maxVal")
      return
    end

    @slider.setRange(minVal, maxVal)
  end
end

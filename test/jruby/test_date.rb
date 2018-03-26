# encoding: US-ASCII
require 'test/unit'

class TestDate < Test::Unit::TestCase

  def setup
    require 'date'
  end

  def test_years_around_0 # Joda Time vs (Ruby) Date
    (-2..2).each do |year|
      assert_equal year, Date.new(year).year
      assert_equal year, DateTime.new(year).year
      [Date::GREGORIAN, Date::ITALY, Date::ENGLAND, Date::JULIAN].each do |sg|
        assert_equal year, Date.new(year, 1, 1, sg).year
        assert_equal year, DateTime.new(year, 1, 1, 0, 0, 0, 0, sg).year
      end
    end
  end

  def test_new_civil
    date = Date.new
    assert_equal -4712, date.year
    assert_equal 1, date.month
    assert_equal 1, date.day

    assert_equal date, Date.send(:civil)
    assert_equal date, Date.send(:new)

    date = Date.new -4712
    assert_equal -4712, date.year
    assert_equal 1, date.month
    assert_equal 1, date.day

    date = Date.new 0
    assert_equal 0, date.year
    assert_equal 1, date.month
    assert_equal 1, date.day

    date = Date.civil 1
    assert_equal 1, date.year
    assert_equal 1, date.month
    assert_equal 1, date.day

    date = Date.send :civil, -1
    assert_equal -1, date.year
    assert_equal 1, date.month
    assert_equal 1, date.day

    date = Date.new -2, 10
    assert_equal -2, date.year
    assert_equal 10, date.month
    assert_equal 1, date.day

    date = Date.new 1492, -3, -3
    assert_equal 1492, date.year
    assert_equal 10, date.month
    assert_equal 29, date.day

    date = Date.send(:civil, -6, -6, -6)
    assert_equal -6, date.year
    assert_equal 7, date.month
    assert_equal 26, date.day

    date = Date.send(:new, -9, -11, -20)
    assert_equal -9, date.year
    assert_equal 2, date.month
    assert_equal 9, date.day

    date = Date.new -9999, -12, -31
    assert_equal -9999, date.year
    assert_equal 1, date.month
    assert_equal 1, date.day

    date = Date.new -6, -6, -6, Date::ITALY
    assert_equal -6, date.year
    assert_equal 7, date.month
    assert_equal 26, date.day

    date = Date.new -6, -6, -6, Date::GREGORIAN
    assert_equal -6, date.year
    assert_equal 7, date.month
    assert_equal 26, date.day
  end

  def test_new_civil_send
    args = [ 2018, 7 ]
    date = Date.send(:new, *args) { raise 'block-not-called' }
    assert_equal 2018, date.year
    assert_equal 7, date.month
    assert_equal 1, date.day
    date = Date.public_send(:new, 2018, 7)
    assert_equal 2018, date.year
    assert_equal 7, date.month
    assert_equal 1, date.day

    args = [ 2018 ]
    date = DateTime.send(:civil, *args) { raise 'block-not-called' }
    assert_equal 2018, date.year
    assert_equal 1, date.month
    assert_equal 1, date.day

    date = DateTime.public_send(:civil, 2018) { raise 'block-not-called' }
    assert_equal 2018, date.year
    assert_equal 1, date.month
    assert_equal 1, date.day
  end

  def test_date_time_methods
    date = Date.new(1, 2, 3)
    assert_equal 1, date.year
    assert_equal 2, date.month
    assert_equal 3, date.day
    assert_equal 34, date.yday
    assert_equal 4, date.wday
    assert_equal 1, date.cwyear
    assert_equal 0, date.send(:hour)
    assert_equal 0, date.send(:min)
    assert_equal 0, date.send(:second)

    date = Date.new(2001, 3, -1)
    assert_equal 2001, date.year
    assert_equal 3, date.month
    assert_equal 31, date.day

    date = Date.new(1001, 2, -10)
    assert_equal 1001, date.year
    assert_equal 2, date.month
    assert_equal 19, date.day

    begin
      Date.new(1900, 1, 0)
      fail 'expected to fail'
    rescue ArgumentError => e
      assert_equal 'invalid date', e.message
    end
  end

  def test_new_start
    date = Date.new(2000, 1, 1)

    new_date = date.italy
    assert_equal 2000, new_date.year
    assert_equal 1, new_date.month
    assert_equal 1, new_date.day

    new_date = date.england
    assert_equal 2000, new_date.year
    assert_equal 1, new_date.month
    assert_equal 1, new_date.day

    new_date = date.julian
    assert_equal 1999, new_date.year
    assert_equal 12, new_date.month
    assert_equal 19, new_date.day

    new_date = date.new_start
    assert_equal 2000, new_date.year
    assert_equal 1, new_date.month
    assert_equal 1, new_date.day
    assert_equal Date::ITALY, new_date.start

    new_date = date.new_start(Date::JULIAN)
    assert_equal 1999, new_date.year
    assert_equal 12, new_date.month
    assert_equal 19, new_date.day
    assert_equal Date::JULIAN, new_date.start

    new_date = new_date.new_start(Date::GREGORIAN)
    assert_equal 2000, new_date.year
    assert_equal 1, new_date.month
    assert_equal 1, new_date.day
    assert_equal Date::GREGORIAN, new_date.start

    # new_date = date.new_start(1)
    # assert_equal 1999, new_date.year
    # assert_equal 12, new_date.month
    # assert_equal 19, new_date.day
  end

  def test_new_offset
    date = Date.new(2000, 1, 1)

    assert_equal '+00:00', date.send(:zone)
    new_date = date.send :new_offset, 'nst'
    assert_equal 1999, new_date.year
    assert_equal 12, new_date.month
    assert_equal 31, new_date.day
    assert_equal '-03:30', new_date.send(:zone)
    assert_equal 20, new_date.send(:hour)
    assert_equal 30, new_date.send(:min)
    assert_equal 0, new_date.send(:sec)

    new_date = date.send :new_offset, Rational(7, 24)
    assert_equal 2000, new_date.year
    assert_equal 1, new_date.month
    assert_equal 1, new_date.day
    assert_equal '+07:00', new_date.send(:zone)
    assert_equal 7, new_date.send(:hour)
    assert_equal 0, new_date.send(:min)
    assert_equal 0, new_date.send(:sec)
  end

  def test_new_with_rational
    date = Date.new(y = Rational(2005/2), m = -Rational(5/2), d = Rational(31/3))
    assert_equal '1002-11-10', date.to_s

    date = DateTime.new(y, m, d = Rational(31/2), Rational(42, 2), -17, -35)
    assert_equal '1002-11-15T21:43:25+00:00', date.to_s

    d = DateTime.new(2001, 2, Rational(7, 2))
    assert_equal [ 2001, 2, 3, 12, 0, 0, 0 ], [ d.year, d.mon, d.mday, d.hour, d.min, d.sec, d.offset ]

    assert_equal '2001-02-03', d.to_date.to_s
    date = Date.new(2001, 2, 3 + 1.to_r / 2)
    assert_equal '2001-02-03', date.to_s
    d = date.to_datetime
    assert_equal [ 2001, 2, 3, 0, 0, 0, 0 ], [ d.year, d.mon, d.mday, d.hour, d.min, d.sec, d.offset ]

    d = DateTime.new(2001, 2, 3 + 2.to_r / 3)
    assert_equal [ 2001, 2, 3, 16, 0, 0, 0 ], [ d.year, d.mon, d.mday, d.hour, d.min, d.sec, d.offset ]

    d = DateTime.new(2001, 2, 3 + 11.to_r / 13)
    assert_equal [ 2001, 2, 3, 20, 18, 27, 0 ], [ d.year, d.mon, d.mday, d.hour, d.min, d.sec, d.offset ]

    d = DateTime.new(2001, 2, 3, 4, 5, 6 + 1.to_r / 2)
    assert_equal [2001, 2, 3, 4, 5, 6, 0], [ d.year, d.mon, d.mday, d.hour, d.min, d.sec, d.offset ]
    assert_equal Rational(1, 2), d.sec_fraction

    d = DateTime.civil(1, 2, 3, Rational(9, 2))
    assert_equal [ 1, 2, 3, 4, 30, 0, 0 ], [ d.year, d.mon, d.mday, d.hour, d.min, d.sec, d.offset ]

    args = [ 2020, 12, 23 + (1.to_r / 3), 5 ]
    if defined? JRUBY_VERSION
      d = DateTime.new(*args)
      assert_equal [ 2020, 12, 23, 8 + 5, 0, 0, 0 ], [ d.year, d.mon, d.mday, d.hour, d.min, d.sec, d.sec_fraction ]
    else
      assert_raise(ArgumentError) { DateTime.new(*args) }
    end

    args = [ 2018, 10, 7.to_r / 3, 5, 0, Rational(10, 3) ]
    if defined? JRUBY_VERSION
      d = DateTime.new(*args)
      assert_equal [ 2018, 10, 2, 13, 0, 3, 1.to_r / 3 ], [ d.year, d.mon, d.mday, d.hour, d.min, d.sec, d.sec_fraction ]
    else
      # MRI raises ArgumentError
    end
  end

  def test_new_invalid
    y = Rational(2005/2); m = -Rational(5/2); d = Rational(31/3);

    #assert_raise(ArgumentError) { DateTime.new(y, m, d, Rational(43, 2), -17, -35) }
    assert_raise(ArgumentError) { DateTime.new(y, m, d, 10, -17, -80) }
    assert_raise(ArgumentError) { DateTime.new(y, m, d, 10, 67) }
    begin
      DateTime.new(y, m, d, 25); fail 'expected to raise!'
    rescue ArgumentError => ex
      assert_equal 'invalid date', ex.message
    end

    assert_raise(ArgumentError) { DateTime.new(2001, 2, 11.to_r / 13, Rational(10, 3), Rational(200, 21)) }
  end

  def test_sec_fraction
    d = DateTime.new(2018, 2, 20, 12, 58, Rational(10, 3))
    if defined? JRUBY_VERSION # confirm its set the same as before 9.2
      assert_equal 1519131483333, d.to_java.getDateTime.millis
    end
    assert_equal Rational(1, 3), d.sec_fraction
  end

  def test_jd
    assert Date.jd.is_a?(Date)
    assert DateTime.jd.is_a?(DateTime)

    d = DateTime.jd(0, 0,0,0, '+0900')
    assert_equal([-4712, 1, 1, 0, 0, 0, 9.to_r/24], [d.year, d.mon, d.mday, d.hour, d.min, d.sec, d.offset])

    dt = DateTime.new(2012, 12, 24, 12, 23, 00, '+05:00')
    assert_equal 2456286, dt.jd
    assert_equal 2456286, dt.to_date.jd

    assert_equal 0, dt.to_date.send(:hour)
    assert_equal 0, dt.to_date.send(:minute)
    assert_equal 0, dt.to_date.send(:second)
  end

  def test_ordinal
    d = Date.ordinal
    dt = DateTime.ordinal
    assert_equal [-4712, 1, 1], [ d.year, d.mon, d.mday ]
    assert_equal [-4712, 1, 1], [ dt.year, dt.mon, dt.mday ]
    assert_equal [0, 0, 0], [ dt.hour, dt.min, dt.sec ]
    assert dt.is_a?(DateTime)

    assert_equal Date.ordinal(-4712, 1), d
    assert_equal DateTime.ordinal(-4712, 1), dt

    d = Date.ordinal(2500, -10)
    assert_equal [2500, 12, 22], [ d.year, d.mon, d.mday ]
  end

  def test__plus
    d = Date.new(2000,2,29) + (-1)
    assert_equal [2000, 2, 28], [d.year, d.mon, d.mday]
    d = Date.new(2000,2,29) + 1.1
    assert_equal [2000, 3, 1], [d.year, d.mon, d.mday]
    d = Date.new(1999,12,31) + Rational(4, 3)
    assert_equal [2000, 1, 1], [d.year, d.mon, d.mday]
    d = Date.new(1999,12,31) + Rational(3, 4)
    assert_equal [1999, 12, 31], [d.year, d.mon, d.mday]

    d = DateTime.new(2000,2,29) + Rational(1, 2)
    assert_equal DateTime, d.class
    assert_equal [2000, 2, 29, 12, 0, 0], [d.year, d.mon, d.mday, d.hour, d.min, d.sec]
  end

  def test_prev_next
    d = DateTime.new(2000, 3, 1).prev_day(2)
    assert_equal [2000, 2, 28, 00, 0, 0], [d.year, d.mon, d.mday, d.hour, d.min, d.sec]

    d = DateTime.new(2000,3,1).prev_day(1.to_r/2)
    assert_equal [2000, 2, 29, 12, 0, 0], [d.year, d.mon, d.mday, d.hour, d.min, d.sec]

    d = DateTime.new(2000,3,1).prev_day(3.to_r/5)
    assert_equal [2000, 2, 29, 9, 36, 0], [d.year, d.mon, d.mday, d.hour, d.min, d.sec]

    d = DateTime.new(2000,3,1).next_day(0.5)
    assert_equal [2000, 3, 1, 12, 0, 0], [d.year, d.mon, d.mday, d.hour, d.min, d.sec]

    d = DateTime.new(2000,3,1).next_day(0.4444)
    assert_equal [2000, 3, 1, 10, 39, 56], [d.year, d.mon, d.mday, d.hour, d.min, d.sec]

    d = DateTime.new(2000,3,1).next_day(0.55555)
    # NOTE: likely a (minor) rounding issue - JRuby gets time: 13:20:00
    #assert_equal [2000, 3, 1, 13, 19, 59], [d.year, d.mon, d.mday, d.hour, d.min, d.sec]

    d = DateTime.new(2000,3,1).next_day(-0.1)
    assert_equal [2000, 2, 29, 21, 36, 0], [d.year, d.mon, d.mday, d.hour, d.min, d.sec]

    d = Date.new(2000,3,1).prev_day(1.to_r/2)
    assert_equal [2000, 2, 29], [d.year, d.mon, d.mday]

    d = Date.new(2000,3,1).prev_day(Rational(8, 9))
    assert_equal [2000, 2, 29], [d.year, d.mon, d.mday]

    d = Date.new(2000,3,1).prev_day(Rational(1, 10))
    assert_equal [2000, 2, 29], [d.year, d.mon, d.mday]

    d = Date.new(2000,3,1).prev_day(Rational(1, 1))
    assert_equal [2000, 2, 29], [d.year, d.mon, d.mday]

    d = Date.new(2000,3,1).prev_day(Rational(0, 1))
    assert_equal [2000, 3, 1], [d.year, d.mon, d.mday]

    d = Date.new(2000,3,1).next_day(0.7)
    assert_equal [2000, 3, 1], [d.year, d.mon, d.mday]

    d = Date.new(2000,3,1).next_day(1.7)
    assert_equal [2000, 3, 2], [d.year, d.mon, d.mday]

    d = DateTime.new(2000,3,1).next_month(1)
    assert_equal [2000, 4, 1, 0, 0, 0], [d.year, d.mon, d.mday, d.hour, d.min, d.sec]

    d = DateTime.new(2000,3,1).next_month(1.5)
    assert_equal [2000, 4, 1, 0, 0, 0], [d.year, d.mon, d.mday, d.hour, d.min, d.sec]

    d = Date.new(2000,3,1).prev_month(Rational(1, 4))
    assert_equal [2000, 2, 1], [d.year, d.mon, d.mday]

    d = Date.new(2000,3,1).next_month(1.9)
    assert_equal [2000, 4, 1], [d.year, d.mon, d.mday]

    d = DateTime.new(2000,3,1).prev_month(Rational(1, 3))
    assert_equal [2000, 2, 1, 0, 0, 0], [d.year, d.mon, d.mday, d.hour, d.min, d.sec]

    d = DateTime.new(2000,3,1).prev_month(Rational(4, 3))
    assert_equal [2000, 1, 1, 0, 0, 0], [d.year, d.mon, d.mday, d.hour, d.min, d.sec]

    d = Date.new(2000, 3, 1).next_year(-1)
    assert_equal [1999, 3, 1], [d.year, d.mon, d.mday]

    d = Date.new(2000, 3, 1).next_year(Rational(-1, 2))
    assert_equal [1999, 9, 1], [d.year, d.mon, d.mday]

    d = Date.new(2000, 3, 1).next_year(-1.9)
    assert_equal [1998, 4, 1], [d.year, d.mon, d.mday]

    d = Date.new(2000, 3, 1).prev_year(+1.5)
    assert_equal [1998, 9, 1], [d.year, d.mon, d.mday]
  end

  def test_julian
    date = Date.new(2000, 1, 1)
    assert_equal true, date.gregorian?
    assert_equal false, date.julian?

    date = Date.new(1000, 1, 1)
    assert_equal true, date.julian?

    date = Date.new(1582, 10, 15)
    assert_equal false, date.julian?
    assert_equal true, (date - 1).julian?

    date = DateTime.new(1582, 10, 15)
    assert_equal false, date.julian?
    assert_equal true, (date - 1).julian?

    date = DateTime.new(1582, 10, 15, 0, 0, 0)
    assert_equal '#<DateTime: 1582-10-15T00:00:00+00:00 ((2299161j,0s,0n),+0s,2299161j)>', date.inspect
    assert_equal false, date.julian?
    date = DateTime.new(1582, 10, 15, 1, 0, 0)
    assert_equal false, date.julian?
    # NOTE: MRI's crazy-bits - NOT IMPLEMENTED seems like a bug
    date = DateTime.new(1582, 10, 15, 0, 0, 0, '+01:00')
    #assert_equal true, date.julian?
    date = DateTime.new(1582, 10, 15, 0, 59, 59, '+01:00')
    #assert_equal true, date.julian?
    date = DateTime.new(1582, 10, 15, 1, 0, 0, '+01:00')
    assert_equal '#<DateTime: 1582-10-15T01:00:00+01:00 ((2299161j,0s,0n),+3600s,2299161j)>', date.inspect
    assert_equal false, date.julian?

    d = DateTime.new(-123456789,2,3,4,5,6,0)
    assert d.julian?
    assert_equal [-123456789, 2, 3, 4, 5, 6, 1], [d.year, d.mon, d.mday, d.hour, d.min, d.sec, d.wday]
    d2 = d.gregorian
    assert d2.gregorian?
    assert_equal [-123459325, 12, 27, 4, 5, 6, 1], [d2.year, d2.mon, d2.mday, d.hour, d.min, d.sec, d.wday]
  end

  def test_to_s_strftime
    date = Date.civil(2000, 1, 1)
    assert_equal '2000-01-01', date.to_s
    assert_equal '2000-01-01', date.strftime

    date = Date.new(-111, 10, 11)
    assert_equal '-0111-10-11', date.to_s

    date = Date.new(-1111, 11)
    assert_equal '-1111-11-01', date.strftime
  end

  def test_inspect
    date = Date.new(2000, 12, 31)
    assert_equal '#<Date: 2000-12-31 ((2451910j,0s,0n),+0s,2299161j)>', date.inspect

    date = Date.new(-2, 2)
    assert_equal '#<Date: -0002-02-01 ((1720359j,0s,0n),+0s,2299161j)>', date.inspect

    date = Date.today
    assert_match /#<Date: 20\d\d\-\d\d\-\d\d \(\(\d+j,0s,0n\),\+0s,2299161j\)>/, date.inspect
  end

  def test_shift
    date = Date.new(2000, 1, 1)
    new_date = date >> 11
    assert_equal 12, new_date.month
    assert_equal 1, new_date.day
    assert_equal 1, (date >> 12).day
    assert_equal 1, (date >> 12).month
    assert_equal 2001, (date >> 12).year

    assert_raise(TypeError) { date >> "foo" }
  end

  def test_plus
    date = Date.new(2000, 1, 1)
    new_date = date + 31
    assert_equal 2, new_date.month
    assert_equal 1, new_date.day
    assert_equal 2000, new_date.year

    new_date = date + 10.5
    assert_equal 1, new_date.month
    assert_equal 11, new_date.day
    assert_equal 2000, new_date.year

    assert_raise(TypeError) { date + Object.new }
  end

  def test_day_fraction
    date = Date.new(2000, 1, 1)
    assert_equal 0, date.day_fraction

    date = DateTime.new(2000, 1, 10)
    assert date.day_fraction.eql? Rational(0, 1)

    date = DateTime.new(2000, 10, 10, 12, 24, 36)
    assert_equal Rational(1241, 2400), date.day_fraction
    assert_equal '2000-10-10T12:24:36+00:00', date.to_s

    date = DateTime.new(2000, 10, 10, 12, 24, 36, Rational(11, 24))
    assert_equal Rational(1241, 2400), date.day_fraction
    assert_equal '2000-10-10T12:24:36+11:00', date.to_s
  end

  def test_civil_invalid_offset
    if defined? JRUBY_VERSION # this is how all JRubies (< 9.2) worked
      assert_raise(ArgumentError) do
        DateTime.new(2000, 10, 10, 12, 24, 36, Rational(25, 24))
      end
    else # MRI handles 'invalid' offsets just fine
      date = DateTime.new(2000, 10, 10, 12, 24, 36, Rational(25, 24))
      assert_equal '2000-10-10T12:24:36+25:00', date.to_s
    end
  end

  def test_civil_invalid_sg
    date = Date.civil(2000, 1, 1, sg = 2426355 + 1_000_000)
    assert_equal 2000, date.year
    assert_equal 1, date.month
    assert_equal 1, date.day

    date = Date.civil(2000, 1, 1, sg = Date::JULIAN)
    assert_equal 2000, date.year
    assert_equal 1, date.month
    assert_equal 1, date.day
  end

  def test_now_zone
    begin
      old_tz, ENV['TZ'] = ENV['TZ'], 'UTC+9:45'
      time = DateTime.now
      strf = time.strftime('%FT%T%z')
      assert strf.end_with?('-0945'), "invalid zone for: #{strf} (expected '-0945')"
      date = Time.now.strftime('%F')
      assert strf.start_with?(date), "DateTime '#{strf}' does not start with: '#{date}'"
    ensure
      ENV['TZ'] = old_tz
    end
  end

  def test_now_local
    time = DateTime.now
    zone = Time.new.strftime('%:z')
    assert time.to_s.end_with?(zone), "invalid zone for: #{time.to_s} (expected '#{zone}')"
  end

  def test_time_conv
    today = Date.today
    assert_equal today.to_s, Date.today.to_time.strftime('%F')
    assert_equal today, Date.today.to_time.to_date

    time = DateTime.now
    #assert_equal nil, time.to_time.zone
    assert_equal time.to_s, time.to_time.strftime('%FT%T%:z')
    assert_equal time, time.to_time.to_datetime

    time = Time.now
    assert_equal time.nsec.to_r / 1_000_000_000, time.to_datetime.sec_fraction

    time2 = time.to_time.to_datetime.to_time
    assert_equal time.nsec, time2.nsec
    assert_equal time.usec, time2.usec
    assert_equal time, time2

    time = Time.new(2018, 2, 25, 12, 21, 33 + Rational(999_999_999, 1_000_000_000), '+10:30')
    assert_equal time.nsec.to_r / 1_000_000_000, time.to_datetime.sec_fraction

    assert_equal '+10:30', time.to_datetime.zone
    assert_equal time.to_s, time.to_datetime.strftime('%F %T %z')

    time2 = time.to_time.to_datetime.to_time
    assert_equal time.nsec, time2.nsec
    assert_equal time.usec, time2.usec
    assert_equal time, time2
  end

  def test_to_datetime
    time = Time.new(1008, 12, 25, 10, 44, 36, '-11:00')
    dt = DateTime.new(1008, 12, 25, 10, 44, 36, '-11:00')
    assert_equal '#<DateTime: 1008-12-25T10:44:36-11:00 ((2089589j,78276s,0n),-39600s,2299161j)>', time.to_datetime.inspect
    assert_equal dt, time.to_datetime

    time = Time.utc(3, 12, 31, 23, 58, 59)
    datetime = time.to_datetime

    assert_equal time, datetime.to_time.utc
    assert_equal time, datetime.to_time

    time = Time.new(-8, 1, 2, 23, 54, 0, '+11:00')
    dt = DateTime.new(-8, 1, 2, 23, 54, 0, '+11:00')
    assert_equal '#<DateTime: -0008-01-02T23:54:00+11:00 ((1718137j,46440s,0n),+39600s,2299161j)>', time.to_datetime.inspect
    assert_equal dt, time.to_datetime

    time = Time.new(0, 1, 1, 11, 00, 0, '+11:00')
    dt = DateTime.new(0, 1, 1, 11, 00, 0, '+11:00')
    assert_equal '#<DateTime: 0000-01-01T11:00:00+11:00 ((1721058j,0s,0n),+39600s,2299161j)>', time.to_datetime.inspect
    assert_equal dt, time.to_datetime
  end

  def test_to_datetime_reform
    time = Time.utc(1582, 10, 15, 1, 2, 3)
    dt = time.to_datetime
    assert_equal [1582, 10, 15, 1, 2, 3], [ dt.year, dt.month, dt.day, dt.hour, dt.min, dt.sec ]

    utc_time = Time.utc(1582, 10, 14, 1, 2, 3, 45 + Rational(6789, 10_000))
    dt = utc_time.to_datetime
    assert_equal DateTime::ITALY, dt.start
    assert_equal [1582, 10, 24, 1, 2, 3], [ dt.year, dt.month, dt.day, dt.hour, dt.min, dt.sec ]
    time = dt.to_time
    assert_equal [1582, 10, 24], [ time.year, time.month, time.day ]
    assert utc_time != time # no round-trip possible
  end

  def test_to_time_roundtrip # based on AR-JDBC testing
    time = Time.utc(3, 12, 31, 23, 58, 59)
    time2 = time.to_datetime.to_time # '0004-01-01 00:56:43 +0057' in < 9.2
    assert_equal time, time2
    assert_equal 3, time2.year
    assert_equal 31, time2.day
    assert_equal 0, time2.utc_offset
    assert_equal time.zone, time2.zone if defined? JRUBY_VERSION
    # MRI: bug? <"UTC"> expected but was <nil>
  end

  def test_to_date
    dt = DateTime.new(2012, 12, 31, 12, 23, 00, '+05:00')
    date = dt.to_date
    assert_equal 2012, date.year
    assert_equal 12, date.month
    assert_equal 31, date.day
    assert_equal 0, date.send(:hour)
    assert_equal 0, date.send(:minute)
    assert_equal 0, date.send(:second)
    assert_equal Date::ITALY, date.start

    date = dt.to_time.to_date
    assert_equal 2012, date.year
    assert_equal 12, date.month
    assert_equal 31, date.day
    assert_equal 0, date.send(:hour)
    assert_equal 0, date.send(:minute)
    assert_equal 0, date.send(:second)
    assert_equal Date::ITALY, date.start

    dt = DateTime.new(1008, 12, 9, 10, 40, 00, '+11:00')
    date = dt.to_date
    assert_equal 1008, date.year
    assert_equal 12, date.month
    assert_equal 9, date.day
    assert_equal 0, date.send(:hour)
    assert_equal 0, date.send(:minute)
    assert_equal 0, date.send(:second)

    date = dt.to_time.to_date
    assert_equal 1008, date.year
    assert_equal 12, date.month
    assert_equal 3, date.day
    assert_equal 0, date.send(:hour)
    assert_equal 0, date.send(:minute)
    assert_equal 0, date.send(:second)
  end

  def test_parse_strftime
    d = DateTime.parse('2001-02-03T04:05:06+09:00')
    assert_equal('Sat Feb  3 04:05:06 2001', d.strftime('%-100c'))
    #assert_equal('Sat Feb  3 04:05:06 2001'.rjust(26), d.strftime('%26c'))
    assert_equal('00000020010000000006', d.strftime('%10Y%10w'))

    s = '2006-08-08T23:15:33.123456789'; f = '%FT%T.%N'

    d = DateTime.parse(s)
    assert_equal Rational(123456789, 1000000000), d.sec_fraction
    assert_equal(s, d.strftime(f))
    d = DateTime.strptime(s, f)
    assert_equal(s, d.strftime(f))

    d = DateTime.parse(s + '1234')
    assert_equal Rational(617283945617, 5000000000000), d.sec_fraction
    assert_equal(s, d.strftime(f))

    prec = 1_000_000_000
    args = [ 0, 3, 6, 11, 17, Rational(prec - 1, prec) ]
    d = DateTime.send(:new, *args)
    assert_equal [ 0, 3, 6, 11, 17, 0 ], [ d.year, d.month, d.day, d.hour, d.minute, d.second ]
    assert_equal(Rational(prec - 1, prec), d.sec_fraction)
    assert_equal('9' * 9, d.strftime('%9N'))

    prec = 1_000_000_000_000
    args = [ -4712, 1, 1, 11, 11, Rational(prec - 1, prec) ]
    d = DateTime.send(:new, *args)
    assert_equal(Rational(prec - 1, prec), d.sec_fraction)
    assert_equal('9' * 12, d.strftime('%12N'))
  end


  def test_24_hours
    d = DateTime.new(2025, 12, 31, 24)
    assert_equal [2026, 1, 1, 0, 0, 0, 0], [d.year, d.mon, d.mday, d.hour, d.min, d.sec, d.offset]

    assert_raises(ArgumentError) { DateTime.new(2025, 12, 31, 24, 1) }
    DateTime.new(1008, 12, 31, 24, 0)
    assert_raises(ArgumentError) { DateTime.new(2025, 11, 30, 24, 0, 30) }
    DateTime.new(2025, 11, 30, 24, 0, 0)
  end

  # from MRI's test @see test/mri/date/test_switch_hitter.rb
  def test_period2 # except big dates (years) - not supported
    cm_period0 = 71149239
    cm_period = 0xfffffff.div(cm_period0) * cm_period0
    #period2_iter(-cm_period * (1 << 64) - 3, -cm_period * (1 << 64) + 3)
    period2_iter(-cm_period - 3, -cm_period + 3)
    period2_iter(0 - 3, 0 + 3)
    period2_iter(+cm_period - 3, +cm_period + 3)
    #period2_iter(+cm_period * (1 << 64) - 3, +cm_period * (1 << 64) + 3)
  end

  def period2_iter2(from, to, sg)
    (from..to).each do |j|
      d = Date.jd(j, sg)
      d2 = Date.new(d.year, d.mon, d.mday, sg)
      assert_equal(d2.jd, j)
      assert_equal(d2.ajd, d.ajd)
      assert_equal(d2.year, d.year)

      d = DateTime.jd(j, 12,0,0, '+12:00', sg)
      d2 = DateTime.new(d.year, d.mon, d.mday,
                        d.hour, d.min, d.sec, d.offset, sg)
      assert_equal(d2.jd, j)
      assert_equal(d2.ajd, d.ajd)
      assert_equal(d2.year, d.year)
    end
  end

  def period2_iter(from, to)
    period2_iter2(from, to, Date::GREGORIAN)
    period2_iter2(from, to, Date::ITALY)
    period2_iter2(from, to, Date::ENGLAND)
    period2_iter2(from, to, Date::JULIAN)
  end

  # from MRI's test @see test/mri/date/test_date_strftime.rb
  def test_strftime__offset
    s = '2006-08-08T23:15:33'
    (-23..23).collect { |x| '%+.2d' % x }.each do |hh| # (-24..24)
      %w(00 30).each do |mm|
        r = hh + mm
        r = '+0000' if r[-4,4] == '2430'
        d = DateTime.parse(s + hh + mm)
        assert_equal(r, d.strftime('%z'))
      end
    end
  end

  def test_jd_day_fraction
    t = 86400 * DateTime.new(1970, 1, 1).jd + Time.utc(2018, 3, 18, 23).to_i
    dt = DateTime.jd((t + 0)/86400r)
    assert_equal '2018-03-18T23:00:00+00:00', dt.to_s
    dt = DateTime.jd((t + 1)/86400r)
    assert_equal '2018-03-18T23:00:01+00:00', dt.to_s
  end

end
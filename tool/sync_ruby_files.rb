STDLIB_FILES = %w[
  English.rb
  abbrev.rb
  base64.rb
  benchmark.rb
  cgi
  cgi.rb
  date
  date.rb
  debug.rb
  delegate.rb
  drb
  drb.rb
  e2mmap.rb
  erb.rb
  find.rb
  forwardable
  forwardable.rb
  getoptlong.rb
  ipaddr.rb
  irb
  irb.rb
  logger.rb
  matrix
  matrix.rb
  monitor.rb
  mutex_m.rb
  net
  observer.rb
  open-uri.rb
  open3.rb
  optionparser.rb
  optparse
  optparse.rb
  ostruct.rb
  pp.rb
  prettyprint.rb
  prime.rb
  profile.rb
  profiler.rb
  pstore.rb
  resolv-replace.rb
  resolv.rb
  rexml
  rinda
  rss
  rss.rb
  set.rb
  shell
  shell.rb
  shellwords.rb
  singleton.rb
  sync.rb
  thwait.rb
  time.rb
  tmpdir.rb
  tracer.rb
  tsort.rb
  un.rb
  unicode_normalize
  uri
  uri.rb
  weakref.rb
  yaml
  yaml.rb
]

EXT_FILES = {
  'ext/bigdecimal/lib/bigdecimal' => 'bigdecimal',
  'ext/digest/lib/digest.rb' => 'digest.rb',
  'ext/digest/sha2/lib/sha2.rb' => 'digest/sha2.rb',
  'ext/nkf/lib/kconv.rb' => 'kconv.rb',
  'ext/pathname/lib/pathname.rb' => 'pathname.rb',
  'ext/pty/lib/expect.rb' => 'expect.rb',
  'ext/socket/lib/socket.rb' => 'socket.rb',
  'ext/win32/lib/win32' => 'win32',
  'ext/fiddle/lib/fiddle.rb' => 'fiddle.rb',
  'ext/fiddle/lib/fiddle' => 'fiddle',
  'ext/ripper/lib/ripper' => 'ripper',
  'ext/ripper/lib/ripper.rb' => 'ripper.rb',
}

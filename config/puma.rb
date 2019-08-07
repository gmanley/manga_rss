# Set the environment in which the rack's app will run. The value must be a string.
#
# The default is "development".
#
environment ENV['RACK_ENV'] || 'development'

port ENV['PORT'] || 9293

# Daemonize the server into the background. Highly suggest that
# this be combined with "pidfile" and "stdout_redirect".
#
# The default is "false".
#
# daemonize
# daemonize false

# Store the pid of the server in the file at "path".
#
pidfile 'tmp/puma.pid'

# Configure "min" to be the minimum number of threads to use to answer
# requests and "max" the maximum.
#
# The default is "0, 16".
#
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

# How many worker processes to run.  Typically this is set to
# to the number of available cores.
#
# The default is "0".
#
# workers 2

workers Integer(ENV['WEB_CONCURRENCY'] || 2)

# Verifies that all workers have checked in to the master process within
# the given timeout. If not the worker process will be restarted. This is
# not a request timeout, it is to protect against a hung or dead process.
# Setting this value will not protect against slow requests.
#
# The minimum value is 6 seconds, the default value is 60 seconds.
#
# Heroku is 30
worker_timeout 25

# Change the default worker timeout for booting
#
# If unspecified, this defaults to the value of worker_timeout.
#
# worker_boot_timeout 60

# Preload the application before starting the workers; this conflicts with
# phased restart feature. (off by default)

preload_app!

# Dev settings so to make usage easier
if ENV['RACK_ENV'] == 'development'
  threads 1, 1
  worker_timeout 3600
  workers 1
end

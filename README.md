This is a Redis mini clone using ruby.
In trying to make the first acceptance test to pass, our server now has a basic tcp handling capability

IO
---------------

There are two types. Bloking and Non-blocking.


| Blocking | Non-Blocking(used by redis)
|:--------------- |:-------- |
| Many threads| Single thread| Many commands can execute simultaneously| Single CPU hungry operation can block others| coordination overhead| No coordination hence higher throughput


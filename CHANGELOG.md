## master

Nothing

## 0.3.2

* Use same keys and key types as other QueueAdapters do, to not break ActiveJob test helpers #33 [Brian Moran]

## 0.3.1

* Fix `NoMethodError` when using the cancel methods with the default queue name

## 0.3.0

* Add support for Active Job `TestAdapter` #19 [Hermann Mayer]

## 0.2.0

* Add support for `resque`
* Fix(SidekiqAdapter): fix case when worker's first argument is not a Hash #21 [Nguyễn Đức Long]

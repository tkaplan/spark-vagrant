include base
include yarn
class { 'spark':
	slave => true
}
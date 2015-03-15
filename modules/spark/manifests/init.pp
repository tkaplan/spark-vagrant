class spark (
	$slave = false,
	$with_yarn = false,
	$spark_included = false
) {
  class { 'spark::download':
  	spark_included => $spark_included
  }
  class { 'spark::users':
  	with_yarn => $with_yarn
  }
  class { 'spark::daemons':
  	master => !$slave
  }
  class { 'spark::fs':
    with_yarn => $with_yarn
  }
}
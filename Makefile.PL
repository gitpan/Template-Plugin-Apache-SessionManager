use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	'NAME'		=> 'Template::Plugin::Apache::SessionManager',
	'AUTHOR'	=> 'Enrico Sorcinelli <enrico@sorcinelli.it>',
	'VERSION_FROM'	=> 'SessionManager.pm', # finds $VERSION
	'PREREQ_PM'	=> {
		'Template' => 2.07,
		'Apache::SessionManager' => 0.04
	}, 
);

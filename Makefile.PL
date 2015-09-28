    use strict;
    use warnings;
     
    use 5.008;
     
    use ExtUtils::MakeMaker;
    WriteMakefile
    (
    NAME => 'Rictus-Bot',
    VERSION_FROM => 'lib/POE/Component/IRC/Plugin/Rictus.pm',
     BUILD_REQUIRES => {
		'POE' => '1.366',
		'POE::Component::IRC' => '6.88',
		'Config-Simple' => '4.59'
		},
    );
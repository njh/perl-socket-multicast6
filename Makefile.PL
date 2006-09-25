use 5.006001;
use ExtUtils::Constant qw(WriteConstants);
use ExtUtils::MakeMaker;

WriteConstants(
	NAME => 'Socket::Multicast6',
	NAMES => [qw(
		IP_MULTICAST_IF
		IP_MULTICAST_TTL
		IP_MULTICAST_LOOP
		IP_ADD_MEMBERSHIP
		IP_DROP_MEMBERSHIP
		IP_ADD_SOURCE_MEMBERSHIP
		IP_DROP_SOURCE_MEMBERSHIP
		IPV6_MULTICAST_IF
		IPV6_MULTICAST_HOPS
		IPV6_MULTICAST_LOOP
		IPV6_JOIN_GROUP
		IPV6_LEAVE_GROUP
		MCAST_JOIN_GROUP
		MCAST_BLOCK_SOURCE
		MCAST_UNBLOCK_SOURCE
		MCAST_LEAVE_GROUP
		MCAST_JOIN_SOURCE_GROUP
		MCAST_LEAVE_SOURCE_GROUP
	)]
);

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Socket::Multicast6',
    VERSION_FROM      => 'lib/Socket/Multicast6.pm', # finds $VERSION
    PREREQ_PM         => {
    	ExtUtils::MakeMaker => 0,
    	ExtUtils::Constant => 0,
    	Test::More => 0,
		Socket => 0,
		Socket6 => 0,
    },
	ABSTRACT_FROM  => 'lib/Socket/Multicast6.pm',
	AUTHOR         => 'Nicholas J Humfrey <njh@cpan.org>',
);

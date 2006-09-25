use Test::More tests => 100;

use Socket;
use Socket::Multicast6 qw/:all/;

SKIP: {
	skip("Source Specific Multicast isn't available", 100) unless (defined IP_ADD_SOURCE_MEMBERSHIP);
	
	foreach (1..100) {
		my $multiaddr = inet_aton( rand_ip() );
		my $sourceaddr = inet_aton( rand_ip() );
		my $interface = inet_aton( rand_ip() );
	
		my $pack_ip_mreq = Socket::Multicast6::pack_ip_mreq_source( $multiaddr, $sourceaddr, $interface );
	
		my $manual = $multiaddr . $interface . $sourceaddr;
	
		is( $pack_ip_mreq, $manual, "Packed structures match" );
	}
};



sub rand_ip {
	return join '.', map { int rand 255 } (1..4);
}
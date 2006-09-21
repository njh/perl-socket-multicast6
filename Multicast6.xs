#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <sys/socket.h>
#include <netinet/in.h>

#ifdef WIN32
// winsock.h is for winsock <= 1.1
// #include <winsock.h>

// ws2tcpip.h is for winsock >= 2.0
#include <ws2tcpip.h>
#endif

#include "const-c.inc"

MODULE = Socket::Multicast6		PACKAGE = Socket::Multicast6

INCLUDE: const-xs.inc

PROTOTYPES: ENABLE

void
pack_ip_mreq(imr_multiaddr_sv, imr_interface_sv)
	SV* imr_multiaddr_sv
	SV* imr_interface_sv
  PREINIT:
	struct ip_mreq mreq;
	struct in_addr imr_multiaddr;
	struct in_addr imr_interface;
  CODE:
	{

	STRLEN addrlen;
	char * addr;
	
	// Byte load multicast address, machine order
	addr = SvPVbyte(imr_multiaddr_sv, addrlen);

	if (addrlen == sizeof(imr_multiaddr) || addrlen == 4)
		imr_multiaddr.s_addr =
	            (addr[0] & 0xFF) << 24 |
	            (addr[1] & 0xFF) << 16 |
	            (addr[2] & 0xFF) <<  8 |
	            (addr[3] & 0xFF);
	else
		croak("Bad arg length for %s, length is %d, should be %d",
		      "Socket::Multicast6::pack_ip_mreq",
		      addrlen, sizeof(addr));

	// Byte load interface address, machine order
	addr = SvPVbyte(imr_interface_sv, addrlen);

	if (addrlen == sizeof(imr_interface) || addrlen == 4)
		imr_interface.s_addr =
		    (addr[0] & 0xFF) << 24 |
		    (addr[1] & 0xFF) << 16 |
		    (addr[2] & 0xFF) << 8 |
		    (addr[3] & 0xFF);
	else
		croak("Bad arg length for %s, length is %d, should be %d",
		      "Socket::Multicast6::pack_ip_mreq",
		      addrlen, sizeof(addr));

	// Clear out final struct
	Zero( &mreq, sizeof mreq, char );

	// Load values into struct and convert to network order
	mreq.imr_multiaddr.s_addr = htonl(imr_multiaddr.s_addr);
	mreq.imr_interface.s_addr = htonl(imr_interface.s_addr);

	// new mortal string, return it.
	ST(0) = sv_2mortal(newSVpvn((char *)&mreq, sizeof(mreq)));
	}
	

void
pack_ipv6_mreq(imr_multiaddr_sv, imr_interface_idx)
	SV* imr_multiaddr_sv
	unsigned int imr_interface_idx
  PREINIT:
	struct ipv6_mreq mreq;
  CODE:
	{

	STRLEN addrlen;
	char * addr;

	// Clear out final struct
	Zero( &mreq, sizeof mreq, char );

	// Copy accross the interface number
	mreq.ipv6mr_interface = imr_interface_idx;


	// Byte load multicast address, machine order
	addr = SvPVbyte(imr_multiaddr_sv, addrlen);

	if (addrlen == sizeof(mreq.ipv6mr_multiaddr) || addrlen == 16)

		// Copy accross the multicast address
		Copy( addr, mreq.ipv6mr_multiaddr.s6_addr, 1, struct in6_addr );

	else
		croak("Bad arg length for %s, length is %d, should be %d",
		      "Socket::Multicast6::pack_ipv6_mreq",
		      addrlen, sizeof(mreq.ipv6mr_multiaddr));

	// new mortal string, return it.
	ST(0) = sv_2mortal(newSVpvn((char *)&mreq, sizeof(mreq)));
	}

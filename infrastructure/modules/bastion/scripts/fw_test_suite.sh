#!/bin/bash
# Bastion Firewall Outbound Rules Testing Script
# Run this after SSH'ing into your bastion node

echo "=== BASTION FIREWALL OUTBOUND RULES TESTING ==="
echo "Testing each outbound rule to ensure they work as expected"
echo

# Test 1: DNS Resolution (TCP/UDP Port 53)
echo "1. Testing DNS Resolution (Port 53 TCP/UDP)"
echo "----------------------------------------"
# Test DNS over UDP (most common)
echo "Testing DNS over UDP:"
nslookup google.com 8.8.8.8
if [ $? -eq 0 ]; then
    echo "✅ DNS UDP (port 53) - WORKING"
else
    echo "❌ DNS UDP (port 53) - FAILED"
fi

# Test DNS over TCP (less common but should work)
echo "Testing DNS over TCP:"
dig +tcp @8.8.8.8 google.com
if [ $? -eq 0 ]; then
    echo "✅ DNS TCP (port 53) - WORKING"
else
    echo "❌ DNS TCP (port 53) - FAILED"
fi
echo

# Test 2: HTTP Traffic (Port 80)
echo "2. Testing HTTP Traffic (Port 80)"
echo "---------------------------------"
curl -I --connect-timeout 10 http://httpbin.org/get 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ HTTP (port 80) - WORKING"
else
    echo "❌ HTTP (port 80) - FAILED"
fi

# Alternative HTTP test
wget --spider --timeout=10 http://example.com 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ HTTP wget test - WORKING"
else
    echo "❌ HTTP wget test - FAILED"
fi
echo

# Test 3: HTTPS Traffic (Port 443)
echo "3. Testing HTTPS Traffic (Port 443)"
echo "-----------------------------------"
curl -I --connect-timeout 10 https://httpbin.org/get 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ HTTPS (port 443) - WORKING"
else
    echo "❌ HTTPS (port 443) - FAILED"
fi

# Test package manager (uses HTTPS)
apt update 2>/dev/null | head -5
if [ $? -eq 0 ]; then
    echo "✅ Package manager HTTPS - WORKING"
else
    echo "❌ Package manager HTTPS - FAILED"
fi
echo

# Test 4: NTP Time Synchronization (UDP Port 123)
echo "4. Testing NTP Time Sync (Port 123 UDP)"
echo "---------------------------------------"
# Test NTP query
if command -v chronyc &> /dev/null; then
    chronyc sources 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✅ Chrony NTP - WORKING"
    fi
fi
echo

# Test 5: ICMP Outbound (Ping)
echo "5. Testing ICMP Outbound (Ping)"
echo "-------------------------------"
ping -c 3 8.8.8.8 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ ICMP Ping - WORKING"
else
    echo "❌ ICMP Ping - FAILED"
fi

# Test ping to different destinations
ping -c 2 1.1.1.1 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ ICMP Ping (1.1.1.1) - WORKING"
else
    echo "❌ ICMP Ping (1.1.1.1) - FAILED"
fi
echo

# Test 6: Cluster Management Ports (6443, 50000)
echo "6. Testing Cluster Management Access"
echo "-----------------------------------"
# Note: Replace CLUSTER_NODE_IP with actual cluster node IP
CLUSTER_NODE_IP="10.0.1.10"  # Update this with your cluster node IP

echo "Testing kubectl API server port (6443):"
timeout 5 bash -c "</dev/tcp/${CLUSTER_NODE_IP}/6443" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ Kubernetes API (port 6443) - REACHABLE"
else
    echo "❌ Kubernetes API (port 6443) - UNREACHABLE"
fi

echo "Testing Talos API port (50000):"
timeout 5 bash -c "</dev/tcp/${CLUSTER_NODE_IP}/50000" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ Talos API (port 50000) - REACHABLE"
else
    echo "❌ Talos API (port 50000) - UNREACHABLE"
fi
echo

# Test 7: Blocked Ports (Should Fail)
echo "7. Testing Blocked Ports (Should FAIL)"
echo "-------------------------------------"
echo "Testing blocked port 25 (SMTP):"
timeout 5 bash -c "</dev/tcp/gmail-smtp-in.l.google.com/25" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "⚠️  SMTP (port 25) - WORKING (Unexpected - should be blocked)"
else
    echo "✅ SMTP (port 25) - BLOCKED (Expected)"
fi

echo "Testing blocked port 21 (FTP):"
timeout 5 bash -c "</dev/tcp/ftp.debian.org/21" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "⚠️  FTP (port 21) - WORKING (Unexpected - should be blocked)"
else
    echo "✅ FTP (port 21) - BLOCKED (Expected)"
fi
echo

# Test 8: Network Utilities Installation Test
echo "8. Testing Package Management"
echo "-----------------------------"
echo "Testing if we can install network utilities:"
apt update && apt install -y netcat-traditional curl wget dnsutils ntpdate 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ Package installation - WORKING"
else
    echo "❌ Package installation - FAILED"
fi
echo

# Test 9: Advanced Network Tests using netcat
echo "9. Advanced Network Tests"
echo "------------------------"
if command -v nc &> /dev/null; then
    echo "Testing HTTP with netcat:"
    echo -e "GET / HTTP/1.0\r\nHost: httpbin.org\r\n\r\n" | nc -w 5 httpbin.org 80 | head -1
    
    echo "Testing HTTPS port connectivity:"
    nc -z -w5 google.com 443 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✅ HTTPS port (443) connectivity - WORKING"
    else
        echo "❌ HTTPS port (443) connectivity - FAILED"
    fi
fi
echo

# Test 10: Comprehensive Connectivity Summary
echo "10. SUMMARY REPORT"
echo "=================="
echo "Essential Services Status:"

# DNS
host google.com >/dev/null 2>&1 && echo "✅ DNS Resolution: OK" || echo "❌ DNS Resolution: FAILED"

# HTTP/HTTPS
curl -s --connect-timeout 5 http://httpbin.org/ip >/dev/null 2>&1 && echo "✅ HTTP Connectivity: OK" || echo "❌ HTTP Connectivity: FAILED"
curl -s --connect-timeout 5 https://httpbin.org/ip >/dev/null 2>&1 && echo "✅ HTTPS Connectivity: OK" || echo "❌ HTTPS Connectivity: FAILED"

# ICMP
ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "✅ ICMP/Ping: OK" || echo "❌ ICMP/Ping: FAILED"

# Time sync
ntpdate -q pool.ntp.org >/dev/null 2>&1 && echo "✅ NTP Sync: OK" || echo "❌ NTP Sync: FAILED"

echo
echo "=== TEST COMPLETED ==="
echo "If any essential services show as FAILED, check your firewall rules."
echo "If blocked ports show as WORKING, your firewall may be too permissive."
#!/bin/bash
rm -rf ~/.m2/repository/*

rm -rf ~/.cache/netbeans/8.2/*
#rm -rf ~/.cache/netbeans/8.2/index/*
#rm -rf ~/.cache/netbeans/8.2/catalogcache/*
#rm -rf ~/.cache/netbeans/8.2/mavenindex/*
#rm -rf ~/.cache/netbeans/8.2/mavencachedirs/*
rm -rf ~/.netbeans/8.2/var/log/*

#rm -rf ~/GlassFish_Payara41/glassfish/domains/domain1/autodeploy/*
#rm -rf ~/GlassFish_Payara41/glassfish/domains/domain1/generated/*
#rm -rf ~/GlassFish_Payara41/glassfish/domains/domain1/logs/*
#rm -rf ~/GlassFish_Payara41/glassfish/domains/domain1/osgi-cache/felix/*

rm -rf ~/GlassFish_Server3/glassfish/domains/domain1/autodeploy/*
rm -rf ~/GlassFish_Server3/glassfish/domains/domain1/generated/*
rm -rf ~/GlassFish_Server3/glassfish/domains/domain1/logs/*
rm -rf ~/GlassFish_Server3/glassfish/domains/domain1/osgi-cache/felix/*

#rm -rf ~/GlassFish_Server3/glassfish/domains/domain2/autodeploy/*
#rm -rf ~/GlassFish_Server3/glassfish/domains/domain2/generated/*
#rm -rf ~/GlassFish_Server3/glassfish/domains/domain2/logs/*
#rm -rf ~/GlassFish_Server3/glassfish/domains/domain2/osgi-cache/felix/*

#find /home/Projekte/misa2 -name target -type d -exec rm -rf {} \;

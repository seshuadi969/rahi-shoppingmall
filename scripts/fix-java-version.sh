#!/bin/bash

echo "🔧 Fixing Java Version for Jenkins"
echo "================================="

set -e

echo "1. Checking current Java version..."
java -version 2>&1 | head -n 1 || echo "Java not found"

echo ""
echo "2. Installing Java 17..."
sudo apt update
sudo apt install openjdk-17-jdk -y

echo ""
echo "3. Setting Java 17 as default..."
sudo update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/java-17-openjdk-amd64/bin/javac

echo ""
echo "4. Verifying Java installation..."
java -version
javac -version

echo ""
echo "5. Updating Jenkins configuration..."
# Backup original config
sudo cp /etc/default/jenkins /etc/default/jenkins.backup

# Update JAVA_HOME in Jenkins config
sudo sed -i 's|JAVA_HOME=.*|JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64|' /etc/default/jenkins

# Verify the change
echo "JAVA_HOME in Jenkins config:"
sudo grep JAVA_HOME /etc/default/jenkins

echo ""
echo "6. Starting Jenkins service..."
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Wait for service to start
sleep 10

echo ""
echo "7. Checking Jenkins status..."
if sudo systemctl is-active --quiet jenkins; then
    echo "✅ Jenkins service is running!"
    
    # Check port
    if sudo netstat -tlnp | grep -q 8080; then
        echo "✅ Jenkins is listening on port 8080"
    else
        echo "❌ Jenkins is not listening on port 8080"
    fi
    
    # Get initial password
    if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
        echo "🔑 Initial Admin Password: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)"
    else
        echo "⏳ Initial password file not ready yet (check in 30 seconds)"
    fi
else
    echo "❌ Jenkins service failed to start"
    echo "Checking logs..."
    sudo journalctl -u jenkins.service --no-pager -n 10
    exit 1
fi

echo ""
echo "🌐 Access Jenkins at: http://$(hostname -I | awk '{print $1}'):8080"
echo ""
echo "🎉 Java version issue fixed! Jenkins should now be running."

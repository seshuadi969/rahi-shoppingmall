#!/bin/bash

echo "🚀 Setting up Jenkins for Rahi Shopping Mall..."

# Create Jenkins configuration
JENKINS_URL="http://localhost:8080"
JENKINS_USER="admin"
JENKINS_PASSWORD="password"

echo "📝 Configuring Jenkins..."

# Create credentials using Jenkins CLI or REST API
echo "Please manually configure these credentials in Jenkins:"
echo ""
echo "1. railway-token (Secret text)"
echo "   - ID: railway-token"
echo "   - Secret: Your Railway API token"
echo ""
echo "2. vercel-token (Secret text)"
echo "   - ID: vercel-token" 
echo "   - Secret: Your Vercel API token"
echo ""
echo "3. vercel-org-id (Secret text)"
echo "   - ID: vercel-org-id"
echo "   - Secret: Your Vercel Organization ID"
echo ""
echo "4. vercel-project-id (Secret text)"
echo "   - ID: vercel-project-id"
echo "   - Secret: Your Vercel Project ID"
echo ""

# Create the pipeline job
echo "Creating Jenkins pipeline..."

cat > scripts/jenkins/create-pipeline.xml << 'EOF'
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job@2.40">
  <actions/>
  <description>Rahi Shopping Mall Full Stack Deployment</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
      <triggers>
        <hudson.triggers.SCMTrigger>
          <spec>H/5 * * * *</spec>
          <ignorePostCommitHooks>false</ignorePostCommitHooks>
        </hudson.triggers.SCMTrigger>
      </triggers>
    </org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
  </properties>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps@2.90">
    <scm class="hudson.plugins.git.GitSCM" plugin="git@4.10.0">
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>https://github.com/your-username/rahi-shopping-mall.git</url>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/main</name>
        </hudson.plugins.git.BranchSpec>
        <hudson.plugins.git.BranchSpec>
          <name>*/develop</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="list"/>
      <extensions/>
    </scm>
    <scriptPath>Jenkinsfile</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <disabled>false</disabled>
</flow-definition>
EOF

echo "✅ Jenkins setup completed!"
echo ""
echo "📋 Next Steps:"
echo "1. Install required Jenkins plugins:"
echo "   - Pipeline"
echo "   - GitHub Integration" 
echo "   - NodeJS Plugin"
echo "   - Slack Notification Plugin"
echo "   - Email Extension Plugin"
echo ""
echo "2. Configure credentials as listed above"
echo "3. Create a new Pipeline job in Jenkins"
echo "4. Set Pipeline definition to 'Pipeline script from SCM'"
echo "5. Configure your Git repository"
echo "6. Set Script Path to 'Jenkinsfile'"
echo "7. Save and run the pipeline!"

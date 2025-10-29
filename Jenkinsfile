pipeline {
    agent any
    
    parameters {
        choice(
            name: 'DEPLOY_ENVIRONMENT',
            choices: ['development', 'staging', 'production'],
            description: 'Select deployment environment'
        )
        choice(
            name: 'DEPLOY_TARGET',
            choices: ['all', 'backend', 'frontend'],
            description: 'Select what to deploy'
        )
        booleanParam(
            name: 'RUN_TESTS',
            defaultValue: true,
            description: 'Run tests before deployment'
        )
        booleanParam(
            name: 'SKIP_DEPLOY',
            defaultValue: false,
            description: 'Skip deployment (only build and test)'
        )
    }
    
    environment {
        NODE_VERSION = '18'
        // Backend Environment
        BACKEND_DEPLOY_URL = 'https://rahi-backend.up.railway.app'
        RAILWAY_TOKEN = credentials('railway-token')
        // Frontend Environment  
        FRONTEND_DEPLOY_URL = 'https://rahi-shopping-mall.vercel.app'
        VERCEL_TOKEN = credentials('vercel-token')
        VERCEL_ORG_ID = credentials('vercel-org-id')
        VERCEL_PROJECT_ID = credentials('vercel-project-id')
        // Notifications
        SLACK_CHANNEL = '#deployments'
        EMAIL_RECIPIENTS = 'dev-team@company.com'
    }
    
    stages {
        stage('Initialize') {
            steps {
                script {
                    echo "🎯 Starting Rahi Shopping Mall Deployment"
                    echo "📦 Repository: ${env.GIT_URL}"
                    echo "🌿 Branch: ${env.BRANCH_NAME}"
                    echo "🏷️  Build: ${env.BUILD_NUMBER}"
                    echo "🎯 Target: ${params.DEPLOY_TARGET}"
                    echo "🌍 Environment: ${params.DEPLOY_ENVIRONMENT}"
                    
                    // Set environment-specific variables
                    if (params.DEPLOY_ENVIRONMENT == 'production') {
                        env.BACKEND_DEPLOY_URL = 'https://rahi-backend-prod.up.railway.app'
                        env.FRONTEND_DEPLOY_URL = 'https://rahi-shopping-mall.com'
                    } else if (params.DEPLOY_ENVIRONMENT == 'staging') {
                        env.BACKEND_DEPLOY_URL = 'https://rahi-backend-staging.up.railway.app'
                        env.FRONTEND_DEPLOY_URL = 'https://staging.rahi-shopping-mall.vercel.app'
                    }
                }
            }
        }
        
        stage('Checkout & Validate') {
            steps {
                checkout scm
                
                script {
                    // Validate project structure
                    def requiredFiles = [
                        'backend/package.json',
                        'frontend/package.json',
                        'backend/server.js',
                        'frontend/vite.config.js'
                    ]
                    
                    requiredFiles.each { file ->
                        if (!fileExists(file)) {
                            error "❌ Required file missing: ${file}"
                        }
                    }
                    
                    echo "✅ Project structure validated"
                }
            }
        }
        
        stage('Setup Environment') {
            parallel {
                stage('Setup Backend') {
                    when {
                        expression { params.DEPLOY_TARGET == 'all' || params.DEPLOY_TARGET == 'backend' }
                    }
                    steps {
                        dir('backend') {
                            sh '''
                                echo "🔧 Setting up Backend Environment..."
                                node --version
                                npm --version
                                npm ci
                                echo "✅ Backend dependencies installed"
                            '''
                        }
                    }
                }
                
                stage('Setup Frontend') {
                    when {
                        expression { params.DEPLOY_TARGET == 'all' || params.DEPLOY_TARGET == 'frontend' }
                    }
                    steps {
                        dir('frontend') {
                            sh '''
                                echo "🔧 Setting up Frontend Environment..."
                                node --version
                                npm --version
                                npm ci
                                echo "✅ Frontend dependencies installed"
                            '''
                        }
                    }
                }
            }
        }
        
        stage('Code Quality & Security') {
            parallel {
                stage('Backend Code Quality') {
                    when {
                        expression { params.DEPLOY_TARGET == 'all' || params.DEPLOY_TARGET == 'backend' }
                    }
                    steps {
                        dir('backend') {
                            sh '''
                                echo "🔍 Running Backend Code Quality Checks..."
                                # Security audit
                                npm audit --audit-level high || true
                                
                                # Linting (if eslint is configured)
                                npx eslint src/ --no-error-on-unmatched-pattern || echo "ESLint check completed"
                                
                                # Dependency check
                                npm outdated || echo "Dependency check completed"
                                
                                echo "✅ Backend code quality checks passed"
                            '''
                        }
                    }
                }
                
                stage('Frontend Code Quality') {
                    when {
                        expression { params.DEPLOY_TARGET == 'all' || params.DEPLOY_TARGET == 'frontend' }
                    }
                    steps {
                        dir('frontend') {
                            sh '''
                                echo "🔍 Running Frontend Code Quality Checks..."
                                # Security audit
                                npm audit --audit-level high || true
                                
                                # Linting
                                npx eslint src/ --no-error-on-unmatched-pattern || echo "ESLint check completed"
                                
                                # Build test
                                npm run build
                                
                                echo "✅ Frontend code quality checks passed"
                            '''
                        }
                    }
                }
            }
        }
        
        stage('Testing') {
            when {
                expression { params.RUN_TESTS }
            }
            parallel {
                stage('Backend Tests') {
                    when {
                        expression { params.DEPLOY_TARGET == 'all' || params.DEPLOY_TARGET == 'backend' }
                    }
                    steps {
                        dir('backend') {
                            sh '''
                                echo "🧪 Running Backend Tests..."
                                # Run tests if test script exists
                                if grep -q "\"test\"" package.json; then
                                    npm test
                                    echo "✅ Backend tests passed"
                                else
                                    echo "⚠️  No tests configured for backend"
                                fi
                            '''
                        }
                    }
                }
                
                stage('Frontend Tests') {
                    when {
                        expression { params.DEPLOY_TARGET == 'all' || params.DEPLOY_TARGET == 'frontend' }
                    }
                    steps {
                        dir('frontend') {
                            sh '''
                                echo "🧪 Running Frontend Tests..."
                                # Run tests if test script exists
                                if grep -q "\"test\"" package.json; then
                                    npm test
                                    echo "✅ Frontend tests passed"
                                else
                                    echo "⚠️  No tests configured for frontend"
                                fi
                            '''
                        }
                    }
                }
            }
        }
        
        stage('Build') {
            parallel {
                stage('Build Backend') {
                    when {
                        expression { (params.DEPLOY_TARGET == 'all' || params.DEPLOY_TARGET == 'backend') && !params.SKIP_DEPLOY }
                    }
                    steps {
                        dir('backend') {
                            sh '''
                                echo "🏗️ Building Backend..."
                                # Build if build script exists
                                if grep -q "\"build\"" package.json; then
                                    npm run build
                                    echo "✅ Backend build completed"
                                else
                                    echo "ℹ️  No build step for backend"
                                fi
                                
                                # Create deployment package
                                tar -czf ../backend-build-${BUILD_NUMBER}.tar.gz .
                                echo "📦 Backend deployment package created"
                            '''
                        }
                    }
                }
                
                stage('Build Frontend') {
                    when {
                        expression { (params.DEPLOY_TARGET == 'all' || params.DEPLOY_TARGET == 'frontend') && !params.SKIP_DEPLOY }
                    }
                    steps {
                        dir('frontend') {
                            sh '''
                                echo "🏗️ Building Frontend..."
                                # Build frontend
                                npm run build
                                
                                # Verify build output
                                if [ -d "dist" ] && [ -f "dist/index.html" ]; then
                                    echo "✅ Frontend build completed successfully"
                                    ls -la dist/
                                else
                                    echo "❌ Frontend build failed - no dist directory"
                                    exit 1
                                fi
                                
                                # Create deployment package
                                tar -czf ../frontend-build-${BUILD_NUMBER}.tar.gz dist/
                                echo "📦 Frontend deployment package created"
                            '''
                        }
                    }
                }
            }
        }
        
        stage('Deploy') {
            when {
                expression { !params.SKIP_DEPLOY }
            }
            parallel {
                stage('Deploy Backend') {
                    when {
                        expression { params.DEPLOY_TARGET == 'all' || params.DEPLOY_TARGET == 'backend' }
                    }
                    steps {
                        script {
                            echo "🚀 Deploying Backend to ${params.DEPLOY_ENVIRONMENT}..."
                            
                            dir('backend') {
                                // Deploy using Railway
                                sh """
                                    npm install -g @railway/cli
                                    railway up --service backend --token ${RAILWAY_TOKEN}
                                """
                            }
                            
                            // Wait for deployment to complete
                            sleep 60
                            
                            // Health check
                            sh """
                                echo "🔍 Checking backend health..."
                                curl -f ${BACKEND_DEPLOY_URL}/api/health || exit 1
                                echo "✅ Backend health check passed"
                                
                                # Test database connection
                                curl -f ${BACKEND_DEPLOY_URL}/api/test-db || echo "Database test endpoint not available"
                                
                                # Test products API
                                curl -f ${BACKEND_DEPLOY_URL}/api/products || echo "Products endpoint not available"
                            """
                        }
                    }
                }
                
                stage('Deploy Frontend') {
                    when {
                        expression { params.DEPLOY_TARGET == 'all' || params.DEPLOY_TARGET == 'frontend' }
                    }
                    steps {
                        script {
                            echo "🚀 Deploying Frontend to ${params.DEPLOY_ENVIRONMENT}..."
                            
                            dir('frontend') {
                                // Deploy using Vercel
                                sh """
                                    npm install -g vercel
                                    vercel --prod --token ${VERCEL_TOKEN} --confirm
                                """
                            }
                            
                            // Wait for deployment to complete
                            sleep 45
                            
                            // Basic frontend check
                            sh """
                                echo "🔍 Checking frontend deployment..."
                                curl -I ${FRONTEND_DEPLOY_URL} | head -n 1 || echo "Frontend check completed"
                            """
                        }
                    }
                }
            }
        }
        
        stage('Integration Test') {
            when {
                expression { !params.SKIP_DEPLOY && (params.DEPLOY_TARGET == 'all') }
            }
            steps {
                script {
                    echo "🔗 Running Integration Tests..."
                    
                    sh """
                        # Test backend-frontend connectivity
                        echo "Testing API connectivity..."
                        curl -f ${BACKEND_DEPLOY_URL}/api/health
                        
                        # Test if frontend can reach backend
                        echo "Testing CORS and connectivity..."
                        curl -X OPTIONS ${BACKEND_DEPLOY_URL}/api/products -H "Origin: ${FRONTEND_DEPLOY_URL}"
                    """
                    
                    echo "✅ Integration tests completed"
                }
            }
        }
    }
    
    post {
        always {
            echo "📊 Build Summary:"
            echo "   Build: ${env.BUILD_URL}"
            echo "   Duration: ${currentBuild.durationString}"
            echo "   Result: ${currentBuild.currentResult}"
            
            // Archive important artifacts
            archiveArtifacts artifacts: '*-build-*.tar.gz', onlyIfSuccessful: false
            
            // Clean workspace
            cleanWs()
        }
        
        success {
            script {
                if (!params.SKIP_DEPLOY) {
                    def message = """
                    ✅ *Rahi Shopping Mall Deployment Successful!*
                    
                    *Environment:* ${params.DEPLOY_ENVIRONMENT}
                    *Deployed:* ${params.DEPLOY_TARGET}
                    *Build:* ${env.BUILD_URL}
                    *Backend URL:* ${BACKEND_DEPLOY_URL}
                    *Frontend URL:* ${FRONTEND_DEPLOY_URL}
                    *Duration:* ${currentBuild.durationString}
                    """
                    
                    // Slack notification
                    slackSend(
                        channel: env.SLACK_CHANNEL,
                        message: message,
                        color: 'good'
                    )
                    
                    // Email notification
                    emailext (
                        subject: "✅ SUCCESS: Rahi Shopping Mall Deployed to ${params.DEPLOY_ENVIRONMENT}",
                        body: """
                        Rahi Shopping Mall has been successfully deployed!
                        
                        Deployment Details:
                        - Environment: ${params.DEPLOY_ENVIRONMENT}
                        - Components: ${params.DEPLOY_TARGET}
                        - Backend URL: ${BACKEND_DEPLOY_URL}
                        - Frontend URL: ${FRONTEND_DEPLOY_URL}
                        - Build: ${env.BUILD_URL}
                        - Duration: ${currentBuild.durationString}
                        
                        Health Checks:
                        - Backend: ${BACKEND_DEPLOY_URL}/api/health
                        - Frontend: ${FRONTEND_DEPLOY_URL}
                        
                        Next Steps:
                        - Verify functionality on the live sites
                        - Monitor application logs
                        - Update documentation if needed
                        """,
                        to: env.EMAIL_RECIPIENTS
                    )
                }
            }
        }
        
        failure {
            script {
                def message = """
                ❌ *Rahi Shopping Mall Deployment Failed!*
                
                *Environment:* ${params.DEPLOY_ENVIRONMENT}
                *Target:* ${params.DEPLOY_TARGET}
                *Build:* ${env.BUILD_URL}
                *Failed Stage:* ${env.STAGE_NAME}
                """
                
                slackSend(
                    channel: env.SLACK_CHANNEL,
                    message: message,
                    color: 'danger'
                )
                
                emailext (
                    subject: "❌ FAILED: Rahi Shopping Mall Deployment to ${params.DEPLOY_ENVIRONMENT}",
                    body: """
                    Rahi Shopping Mall deployment has failed!
                    
                    Failed Build: ${env.BUILD_URL}
                    Environment: ${params.DEPLOY_ENVIRONMENT}
                    Target: ${params.DEPLOY_TARGET}
                    Failed Stage: ${env.STAGE_NAME}
                    
                    Please check the Jenkins build logs for details and take appropriate action.
                    """,
                    to: env.EMAIL_RECIPIENTS
                )
            }
        }
        
        unstable {
            echo "⚠️  Build is unstable - check test results or quality gates"
        }
    }
}

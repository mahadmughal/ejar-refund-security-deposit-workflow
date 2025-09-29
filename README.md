# ejar-security-deposit-workflow

## 🔄 Refund Security Deposit Workflow

### Overview
This repository contains the workflow for processing **security deposit refunds** to tenants.

### Structure
- **`update_script.rb`**  
  Used to update the `input_params` array inside the workflow scripts.  
- **`scripts/` folder**  
  Contains all the Ruby scripts required for the workflow.  
- **`refund_security_deposit_workflow.json`**  
  Main workflow file to refund the security deposit.
- **`Execute gitlab pipeline.json`**  
  Sub workflow file to execute gitlab pipeline. This file is used as sub-workflow in main workflow.

### Usage
To ensure the workflow triggers correctly:
1. Setup the github repo located at https://github.com/mahadmughal/gitlab_automation_tool as well. This repo should be setup locally and this repo is responsible to execute sub-workflow(Execute gitlab pipeline).
2. Verify that the paths to the script files are properly configured in the **Code** and **Command** nodes.  
3. Import both the workflows in n8n and then execute the main workflow(refund_security_deposit_workflow.json) 

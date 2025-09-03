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
  Defines the workflow logic and execution steps.

### Usage
To ensure the workflow triggers correctly:
1. Verify that the paths to the script files are properly configured in the **Code** and **Command** nodes.  
2. Run the workflow using the `refund_security_deposit_workflow.json` definition.  

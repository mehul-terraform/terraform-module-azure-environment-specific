import re

def fix_yaml(filepath, container_name):
    with open(filepath, 'r') as f:
        content = f.read()
    
    # Switch Installer
    content = re.sub(
        r'task: charleszipp.*?TerraformInstaller@1', 
        r'task: ms-devlabs.custom-terraform-tasks.custom-terraform-installer-task.TerraformInstaller@0', 
        content
    )
    
    # Replace CLI task with TerraformTaskV1@0
    content = re.sub(
        r'task: charleszipp.*?TerraformCLI@1',
        r'task: ms-devlabs.custom-terraform-tasks.custom-terraform-release-task.TerraformTaskV1@0',
        content
    )

    # Insert provider: 'azurerm' after any command: '...' if it doesn't already have provider
    def add_provider(match):
        return f"command: {match.group(1)}\n        provider: 'azurerm'"
        
    content = re.sub(r'command:\s*\'(init|validate|plan|apply|fmt)\'', add_provider, content)

    # Replace environmentServiceName with environmentServiceNameAzureRM
    content = re.sub(r'environmentServiceName:\s*\'MyExample-Azure\'', r"environmentServiceNameAzureRM: 'MyExample-Azure'", content)

    # Inject explicit backend properties into the 'init' command
    backend_props = f"""backendServiceArm: 'MyExample-Azure'
        backendAzureRmResourceGroupName: 'myexample-tf-rg'
        backendAzureRmStorageAccountName: 'myexampletfstorage'
        backendAzureRmContainerName: '{container_name}'
        backendAzureRmKey: 'terraform.tfstate'"""
    
    content = re.sub(r"backendServiceArm:\s*'MyExample-Azure'", backend_props, content)

    with open(filepath, 'w') as f:
        f.write(content)

fix_yaml('myexample-dev.yml', 'myexample-dev-tfstate')
fix_yaml('myexample-uat.yml', 'myexample-uat-tfstate')

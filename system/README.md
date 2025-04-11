```bash
# Install ansible (As root)
./ansible-setup.sh

# This can be used in future to sync configs as well
ansible-playbook --ask-become-pass --diff playbooks/sync.yml
```
> NOTE: Replace --extra-vars value with required ones

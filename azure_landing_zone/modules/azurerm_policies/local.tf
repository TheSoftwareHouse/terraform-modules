locals {
  policy_assignments = flatten([
    for policy_key, policy in var.policies : [
      for assignment_key, assignment in policy.assignments : {
        policy_key                        = policy_key
        assignment_key                    = assignment_key
        assignment_group                  = assignment.assignment_group
        assignment_name                   = assignment.assignment_name
        assignment_non_compliance_message = assignment.assignment_non_compliance_message
        assignment_non_scopes             = assignment.assignment_non_scopes
      }
    ]
  ])
}
AWS Config Rules


```
module "my_config_rules" {
  source = "./aws_config_rules_module"

  enabled = true
  recorder_name = "my-config-recorder"
  role_arn = "arn:aws:iam::123456789012:role/myConfigRole"
  
  enable_alerting = true
  sns_topic_name  = "my-config-alerts"

  config_rules = [
    {
      name = "s3-bucket-versioning-enabled"
      source = {
        owner = "AWS"
        identifier = "S3_BUCKET_VERSIONING_ENABLED"
        detail = {
          event_source = "aws.config"
          message_type = "ConfigurationItemChangeNotification"
          maximum_execution_frequency = "TwentyFour_Hours"
        }
      }
      input_parameters = "{}"
      maximum_execution_frequency = "TwentyFour_Hours"
      scope = {
        compliance_resource_id = null
        compliance_resource_types = []
        tag_key = null
        tag_value = null
      }
    },
    {
      name = "ec2-volume-in-use-check"
      source = {
        owner = "AWS"
        identifier = "EC2_VOLUME_INUSE_CHECK"
        detail = {
          event_source = "aws.config"
          message_type = "ConfigurationItemChangeNotification"
          maximum_execution_frequency = "TwentyFour_Hours"
        }
      }
      input_parameters = "{}"
      maximum_execution_frequency = "TwentyFour_Hours"
      scope = {
        compliance_resource_id = null
        compliance_resource_types = []
        tag_key = null
        tag_value = null
      }
    }
  ]
}

```